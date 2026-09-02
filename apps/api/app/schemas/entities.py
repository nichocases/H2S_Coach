from __future__ import annotations

from datetime import date, datetime, time
from enum import StrEnum
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field, model_validator


class StrictSchema(BaseModel):
    model_config = ConfigDict(extra="forbid")


class PlayerRoleSchema(StrEnum):
    FIELD = "FIELD"
    GOALKEEPER = "GOALKEEPER"


class SessionStatusSchema(StrEnum):
    PLANNED = "PLANNED"
    IN_PROGRESS = "IN_PROGRESS"
    PAUSED = "PAUSED"
    FINISHED = "FINISHED"
    ABANDONED = "ABANDONED"


class SessionPlayerRoleSchema(StrEnum):
    STARTER = "STARTER"
    SUBSTITUTE = "SUBSTITUTE"
    GOALKEEPER = "GOALKEEPER"


class ActionTypeSchema(StrEnum):
    PASS = "PASS"
    FAIL_PASS = "FAIL_PASS"
    ASSIST = "ASSIST"
    SHOOT = "SHOOT"


class ShotResultSchema(StrEnum):
    GOAL = "GOAL"
    MISSED = "MISSED"
    HIT_KEEPER = "HIT_KEEPER"
    BLOCKED = "BLOCKED"


class GoalTargetZoneSchema(StrEnum):
    TOP_LEFT = "TOP_LEFT"
    TOP_MIDDLE = "TOP_MIDDLE"
    TOP_RIGHT = "TOP_RIGHT"
    BOTTOM_LEFT = "BOTTOM_LEFT"
    BOTTOM_MIDDLE = "BOTTOM_MIDDLE"
    BOTTOM_RIGHT = "BOTTOM_RIGHT"


class KeeperSideSchema(StrEnum):
    GLOVE = "GLOVE"
    PAD = "PAD"
    UNKNOWN = "UNKNOWN"


class ShotOriginZoneSchema(StrEnum):
    ZONE_1 = "ZONE_1"
    ZONE_2 = "ZONE_2"
    ZONE_3 = "ZONE_3"
    ZONE_4 = "ZONE_4"


class GoalkeeperActionResultSchema(StrEnum):
    SAVE = "SAVE"
    GOAL_ALLOWED = "GOAL_ALLOWED"


class SyncEntityTypeSchema(StrEnum):
    COACH = "COACH"
    TEAM = "TEAM"
    PLAYER = "PLAYER"
    SESSION = "SESSION"
    SESSION_PLAYER = "SESSION_PLAYER"
    MATCH_ACTION = "MATCH_ACTION"
    GOALKEEPER_ACTION = "GOALKEEPER_ACTION"


class SyncItemStatusSchema(StrEnum):
    ACCEPTED = "ACCEPTED"
    DUPLICATE = "DUPLICATE"
    CONFLICT = "CONFLICT"
    REJECTED = "REJECTED"


class CoachSchema(StrictSchema):
    id: UUID
    full_name: str = Field(min_length=1, max_length=120)
    email: str | None = Field(default=None, max_length=180)
    created_at: datetime
    updated_at: datetime
    version: int = Field(default=1, ge=1)


class TeamSchema(StrictSchema):
    id: UUID
    coach_id: UUID
    name: str = Field(min_length=1, max_length=120)
    category: str | None = Field(default=None, max_length=80)
    created_at: datetime
    updated_at: datetime
    version: int = Field(default=1, ge=1)


class PlayerSchema(StrictSchema):
    id: UUID
    team_id: UUID
    display_name: str = Field(min_length=1, max_length=120)
    jersey_number: int = Field(ge=0, le=999)
    default_role: PlayerRoleSchema
    active: bool
    version: int = Field(default=1, ge=1)


class TournamentSessionSchema(StrictSchema):
    id: UUID
    tournament_name: str = Field(min_length=1, max_length=160)
    scheduled_date: date
    start_time: time | None = None
    team_id: UUID
    coach_id: UUID
    active_goalkeeper_id: UUID | None = None
    status: SessionStatusSchema
    elapsed_ms: int = Field(ge=0)
    device_id: str = Field(min_length=1, max_length=120)
    created_at: datetime
    updated_at: datetime
    version: int = Field(default=1, ge=1)


class SessionPlayerSchema(StrictSchema):
    session_id: UUID
    player_id: UUID
    role: SessionPlayerRoleSchema
    version: int = Field(default=1, ge=1)


class ShootDetailsSchema(StrictSchema):
    result: ShotResultSchema
    target_zone: GoalTargetZoneSchema
    keeper_side: KeeperSideSchema = KeeperSideSchema.UNKNOWN


class MatchActionSchema(StrictSchema):
    id: UUID
    session_id: UUID
    player_id: UUID
    action_type: ActionTypeSchema
    chronometer_ms: int = Field(ge=0)
    device_id: str = Field(min_length=1, max_length=120)
    client_event_id: str = Field(min_length=1, max_length=120)
    created_at: datetime
    voided_at: datetime | None = None
    void_reason: str | None = Field(default=None, max_length=160)
    shoot_details: ShootDetailsSchema | None = None
    version: int = Field(default=1, ge=1)


class GoalkeeperActionSchema(StrictSchema):
    id: UUID
    session_id: UUID
    goalkeeper_id: UUID
    shot_origin_zone: ShotOriginZoneSchema
    result: GoalkeeperActionResultSchema
    chronometer_ms: int = Field(ge=0)
    device_id: str = Field(min_length=1, max_length=120)
    client_event_id: str = Field(min_length=1, max_length=120)
    created_at: datetime
    version: int = Field(default=1, ge=1)


class SyncRequestSchema(StrictSchema):
    device_id: str = Field(min_length=1, max_length=120)
    batch_id: str = Field(min_length=1, max_length=120)
    coaches: list[CoachSchema]
    teams: list[TeamSchema]
    players: list[PlayerSchema]
    sessions: list[TournamentSessionSchema]
    session_players: list[SessionPlayerSchema]
    player_actions: list[MatchActionSchema]
    goalkeeper_actions: list[GoalkeeperActionSchema]

    @model_validator(mode="after")
    def batch_size_is_bounded(self) -> SyncRequestSchema:
        total = (
            len(self.coaches)
            + len(self.teams)
            + len(self.players)
            + len(self.sessions)
            + len(self.session_players)
            + len(self.player_actions)
            + len(self.goalkeeper_actions)
        )
        if total > 200:
            raise ValueError("sync batch cannot contain more than 200 items")
        return self


class SyncItemResultSchema(StrictSchema):
    entity_type: SyncEntityTypeSchema
    entity_id: str
    status: SyncItemStatusSchema
    server_version: int = Field(ge=0)
    error_code: str | None = Field(default=None, max_length=80)
    message: str | None = Field(default=None, max_length=240)


class SyncResponseSchema(StrictSchema):
    batch_id: str
    processed_at: datetime
    results: list[SyncItemResultSchema]
