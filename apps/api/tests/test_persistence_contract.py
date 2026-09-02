from datetime import UTC, date, datetime
from uuid import uuid4

import pytest
from pydantic import ValidationError

from app.db.base import Base
from app.models.entities import MatchAction, Player
from app.schemas import (
    MatchActionSchema,
    PlayerSchema,
    ShootDetailsSchema,
    TournamentSessionSchema,
)
from app.schemas.entities import (
    ActionTypeSchema,
    GoalTargetZoneSchema,
    PlayerRoleSchema,
    SessionStatusSchema,
    ShotResultSchema,
)


def table_names() -> set[str]:
    return set(Base.metadata.tables)


def test_initial_metadata_matches_mvp_entities() -> None:
    assert table_names() == {
        "coaches",
        "teams",
        "players",
        "tournament_sessions",
        "session_players",
        "match_actions",
        "shoot_details",
        "goalkeeper_actions",
    }


def test_player_model_enforces_active_jersey_index() -> None:
    index = next(
        item
        for item in Player.__table__.indexes
        if item.name == "uq_players_active_team_jersey"
    )

    assert index.unique is True
    assert {column.name for column in index.columns} == {"team_id", "jersey_number"}


def test_match_action_model_uses_contract_chronometer_index() -> None:
    index = next(
        item
        for item in MatchAction.__table__.indexes
        if item.name == "ix_match_actions_session_chrono"
    )

    assert {column.name for column in index.columns} == {
        "session_id",
        "chronometer_ms",
    }


def test_public_schemas_validate_uuid_enums_and_bounds() -> None:
    team_id = uuid4()

    PlayerSchema(
        id=uuid4(),
        team_id=team_id,
        display_name="Lina #7",
        jersey_number=7,
        default_role=PlayerRoleSchema.FIELD,
        active=True,
        version=1,
    )

    with pytest.raises(ValidationError):
        PlayerSchema(
            id=uuid4(),
            team_id=team_id,
            display_name="Lina #1000",
            jersey_number=1000,
            default_role=PlayerRoleSchema.FIELD,
            active=True,
            version=1,
        )


def test_public_shoot_details_are_nested_not_orm_shaped() -> None:
    now = datetime.now(UTC)
    session_id = uuid4()
    player_id = uuid4()

    TournamentSessionSchema(
        id=session_id,
        tournament_name="Copa Local",
        scheduled_date=date(2026, 9, 1),
        team_id=uuid4(),
        coach_id=uuid4(),
        active_goalkeeper_id=None,
        status=SessionStatusSchema.PLANNED,
        elapsed_ms=0,
        device_id="tablet-1",
        created_at=now,
        updated_at=now,
        version=1,
    )

    MatchActionSchema(
        id=uuid4(),
        session_id=session_id,
        player_id=player_id,
        action_type=ActionTypeSchema.SHOOT,
        chronometer_ms=1234,
        shoot_details=ShootDetailsSchema(
            result=ShotResultSchema.GOAL,
            target_zone=GoalTargetZoneSchema.TOP_LEFT,
        ),
        client_event_id=str(uuid4()),
        device_id="tablet-1",
        created_at=now,
        version=1,
    )

    with pytest.raises(ValidationError):
        ShootDetailsSchema(
            action_id=uuid4(),
            result=ShotResultSchema.GOAL,
            target_zone=GoalTargetZoneSchema.TOP_LEFT,
        )
