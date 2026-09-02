from __future__ import annotations

from collections.abc import Iterable
from dataclasses import dataclass
from datetime import UTC, datetime
from enum import StrEnum
from typing import Any, Protocol
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.entities import (
    Coach,
    GoalkeeperAction,
    MatchAction,
    Player,
    SessionPlayer,
    ShootDetails,
    Team,
    TournamentSession,
)
from app.schemas.entities import (
    GoalkeeperActionSchema,
    MatchActionSchema,
    SessionPlayerSchema,
    SyncEntityTypeSchema,
    SyncItemResultSchema,
    SyncItemStatusSchema,
    SyncRequestSchema,
    SyncResponseSchema,
)


class SyncProcessorProtocol(Protocol):
    async def process(self, request: SyncRequestSchema) -> SyncResponseSchema: ...


@dataclass
class StoredSyncRecord:
    entity_type: SyncEntityTypeSchema
    entity_id: str
    version: int
    device_id: str | None = None
    client_event_id: str | None = None


def _result(
    entity_type: SyncEntityTypeSchema,
    entity_id: str,
    status: SyncItemStatusSchema,
    server_version: int,
    *,
    error_code: str | None = None,
    message: str | None = None,
) -> SyncItemResultSchema:
    return SyncItemResultSchema(
        entity_type=entity_type,
        entity_id=entity_id,
        status=status,
        server_version=server_version,
        error_code=error_code,
        message=message,
    )


def _entity_id(item: Any) -> str:
    if isinstance(item, SessionPlayerSchema):
        return f"{item.session_id}:{item.player_id}"
    return str(item.id)


def _iter_items(
    request: SyncRequestSchema,
) -> Iterable[tuple[SyncEntityTypeSchema, Any]]:
    yield from ((SyncEntityTypeSchema.COACH, item) for item in request.coaches)
    yield from ((SyncEntityTypeSchema.TEAM, item) for item in request.teams)
    yield from ((SyncEntityTypeSchema.PLAYER, item) for item in request.players)
    yield from ((SyncEntityTypeSchema.SESSION, item) for item in request.sessions)
    yield from (
        (SyncEntityTypeSchema.SESSION_PLAYER, item) for item in request.session_players
    )
    yield from (
        (SyncEntityTypeSchema.MATCH_ACTION, item) for item in request.player_actions
    )
    yield from (
        (SyncEntityTypeSchema.GOALKEEPER_ACTION, item)
        for item in request.goalkeeper_actions
    )


class InMemorySyncProcessor:
    def __init__(self) -> None:
        self._records: dict[tuple[SyncEntityTypeSchema, str], StoredSyncRecord] = {}
        self._event_keys: dict[
            tuple[SyncEntityTypeSchema, str, str], StoredSyncRecord
        ] = {}

    async def process(self, request: SyncRequestSchema) -> SyncResponseSchema:
        results = [
            self._process_item(entity_type, item)
            for entity_type, item in _iter_items(request)
        ]
        return SyncResponseSchema(
            batch_id=request.batch_id,
            processed_at=datetime.now(UTC),
            results=results,
        )

    def _process_item(
        self,
        entity_type: SyncEntityTypeSchema,
        item: Any,
    ) -> SyncItemResultSchema:
        item_id = _entity_id(item)
        key = (entity_type, item_id)
        event_key = self._event_key(entity_type, item)
        existing_by_id = self._records.get(key)
        existing_by_event = self._event_keys.get(event_key) if event_key else None

        if existing_by_event and existing_by_event.entity_id != item_id:
            return _result(
                entity_type,
                item_id,
                SyncItemStatusSchema.REJECTED,
                existing_by_event.version,
                error_code="duplicate_client_event",
                message="client_event_id already belongs to another entity",
            )
        if (
            existing_by_id
            and event_key
            and existing_by_id.client_event_id
            and existing_by_id.client_event_id != event_key[2]
        ):
            return _result(
                entity_type,
                item_id,
                SyncItemStatusSchema.REJECTED,
                existing_by_id.version,
                error_code="entity_id_conflict",
                message="entity id already exists with a different client_event_id",
            )

        existing = existing_by_id or existing_by_event
        if existing:
            if item.version < existing.version:
                return _result(
                    entity_type,
                    item_id,
                    SyncItemStatusSchema.CONFLICT,
                    existing.version,
                    error_code="stale_version",
                    message="server has a newer version",
                )
            if item.version == existing.version:
                return _result(
                    entity_type,
                    item_id,
                    SyncItemStatusSchema.DUPLICATE,
                    existing.version,
                )

        record = StoredSyncRecord(
            entity_type=entity_type,
            entity_id=item_id,
            version=item.version,
            device_id=getattr(item, "device_id", None),
            client_event_id=getattr(item, "client_event_id", None),
        )
        self._records[key] = record
        if event_key:
            self._event_keys[event_key] = record
        return _result(
            entity_type,
            item_id,
            SyncItemStatusSchema.ACCEPTED,
            item.version,
        )

    @staticmethod
    def _event_key(
        entity_type: SyncEntityTypeSchema,
        item: Any,
    ) -> tuple[SyncEntityTypeSchema, str, str] | None:
        if not hasattr(item, "device_id") or not hasattr(item, "client_event_id"):
            return None
        return (entity_type, str(item.device_id), str(item.client_event_id))


class DatabaseSyncProcessor:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def process(self, request: SyncRequestSchema) -> SyncResponseSchema:
        results: list[SyncItemResultSchema] = []
        for entity_type, item in _iter_items(request):
            results.append(await self._process_item(entity_type, item))
        await self._session.commit()
        return SyncResponseSchema(
            batch_id=request.batch_id,
            processed_at=datetime.now(UTC),
            results=results,
        )

    async def _process_item(
        self,
        entity_type: SyncEntityTypeSchema,
        item: Any,
    ) -> SyncItemResultSchema:
        try:
            async with self._session.begin_nested():
                result = await self._upsert(entity_type, item)
                await self._session.flush()
        except SQLAlchemyError as exc:
            return _result(
                entity_type,
                _entity_id(item),
                SyncItemStatusSchema.REJECTED,
                getattr(item, "version", 0),
                error_code="persistence_error",
                message=str(exc.__class__.__name__),
            )
        return result

    async def _upsert(
        self,
        entity_type: SyncEntityTypeSchema,
        item: Any,
    ) -> SyncItemResultSchema:
        if entity_type is SyncEntityTypeSchema.COACH:
            return await self._upsert_simple(Coach, entity_type, item)
        if entity_type is SyncEntityTypeSchema.TEAM:
            return await self._upsert_simple(Team, entity_type, item)
        if entity_type is SyncEntityTypeSchema.PLAYER:
            return await self._upsert_simple(Player, entity_type, item)
        if entity_type is SyncEntityTypeSchema.SESSION:
            return await self._upsert_simple(TournamentSession, entity_type, item)
        if entity_type is SyncEntityTypeSchema.SESSION_PLAYER:
            return await self._upsert_session_player(item)
        if entity_type is SyncEntityTypeSchema.MATCH_ACTION:
            return await self._upsert_event(MatchAction, entity_type, item)
        return await self._upsert_event(GoalkeeperAction, entity_type, item)

    async def _upsert_simple(
        self,
        model_type: type[Any],
        entity_type: SyncEntityTypeSchema,
        item: Any,
    ) -> SyncItemResultSchema:
        item_id = _entity_id(item)
        existing = await self._session.get(model_type, item.id)
        decision = self._decision(entity_type, item_id, item.version, existing)
        if decision:
            return decision

        data = _model_data(item)
        if existing:
            _write_attributes(existing, data)
        else:
            self._session.add(model_type(**data))
        return _result(
            entity_type,
            item_id,
            SyncItemStatusSchema.ACCEPTED,
            item.version,
        )

    async def _upsert_session_player(
        self,
        item: SessionPlayerSchema,
    ) -> SyncItemResultSchema:
        entity_type = SyncEntityTypeSchema.SESSION_PLAYER
        item_id = _entity_id(item)
        existing = await self._session.scalar(
            select(SessionPlayer).where(
                SessionPlayer.session_id == item.session_id,
                SessionPlayer.player_id == item.player_id,
            )
        )
        decision = self._decision(entity_type, item_id, item.version, existing)
        if decision:
            return decision

        data = _model_data(item)
        if existing:
            _write_attributes(existing, data)
        else:
            self._session.add(SessionPlayer(**data))
        return _result(
            entity_type,
            item_id,
            SyncItemStatusSchema.ACCEPTED,
            item.version,
        )

    async def _upsert_event(
        self,
        model_type: type[Any],
        entity_type: SyncEntityTypeSchema,
        item: GoalkeeperActionSchema | MatchActionSchema,
    ) -> SyncItemResultSchema:
        item_id = _entity_id(item)
        existing_by_event = await self._session.scalar(
            select(model_type).where(
                model_type.device_id == item.device_id,
                model_type.client_event_id == item.client_event_id,
            )
        )
        existing_by_id = await self._session.get(model_type, item.id)

        if existing_by_event and str(existing_by_event.id) != item_id:
            return _result(
                entity_type,
                item_id,
                SyncItemStatusSchema.REJECTED,
                existing_by_event.version,
                error_code="duplicate_client_event",
                message="client_event_id already belongs to another entity",
            )
        if existing_by_id and existing_by_id.client_event_id != item.client_event_id:
            return _result(
                entity_type,
                item_id,
                SyncItemStatusSchema.REJECTED,
                existing_by_id.version,
                error_code="entity_id_conflict",
                message="entity id already exists with a different client_event_id",
            )

        existing = existing_by_id or existing_by_event
        decision = self._decision(entity_type, item_id, item.version, existing)
        if decision:
            return decision

        if isinstance(item, MatchActionSchema):
            data = _model_data(item, exclude={"shoot_details"})
        else:
            data = _model_data(item)

        if existing:
            _write_attributes(existing, data)
        else:
            existing = model_type(**data)
            self._session.add(existing)

        if isinstance(item, MatchActionSchema):
            await self._sync_shoot_details(item)

        return _result(
            entity_type,
            item_id,
            SyncItemStatusSchema.ACCEPTED,
            item.version,
        )

    async def _sync_shoot_details(self, item: MatchActionSchema) -> None:
        existing = await self._session.get(ShootDetails, item.id)
        if item.shoot_details is None:
            if existing:
                await self._session.delete(existing)
            return

        data = _model_data(item.shoot_details) | {"action_id": item.id}
        if existing:
            _write_attributes(existing, data)
        else:
            self._session.add(ShootDetails(**data))

    @staticmethod
    def _decision(
        entity_type: SyncEntityTypeSchema,
        entity_id: str,
        incoming_version: int,
        existing: Any | None,
    ) -> SyncItemResultSchema | None:
        if not existing:
            return None
        if incoming_version < existing.version:
            return _result(
                entity_type,
                entity_id,
                SyncItemStatusSchema.CONFLICT,
                existing.version,
                error_code="stale_version",
                message="server has a newer version",
            )
        if incoming_version == existing.version:
            return _result(
                entity_type,
                entity_id,
                SyncItemStatusSchema.DUPLICATE,
                existing.version,
            )
        return None


def _model_data(item: Any, *, exclude: set[str] | None = None) -> dict[str, Any]:
    data = item.model_dump(exclude=exclude or set())
    return {key: _db_value(value) for key, value in data.items()}


def _db_value(value: Any) -> Any:
    if isinstance(value, StrEnum):
        return value.value
    if isinstance(value, UUID):
        return value
    if isinstance(value, dict):
        return {key: _db_value(inner) for key, inner in value.items()}
    return value


def _write_attributes(target: Any, data: dict[str, Any]) -> None:
    for key, value in data.items():
        setattr(target, key, value)
