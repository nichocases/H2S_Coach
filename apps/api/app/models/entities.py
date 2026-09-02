from __future__ import annotations

from datetime import date, datetime, time
from enum import StrEnum
from uuid import UUID

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    Date,
    DateTime,
    Enum,
    ForeignKey,
    Index,
    Integer,
    String,
    Time,
    UniqueConstraint,
    text,
)
from sqlalchemy.dialects.postgresql import UUID as PostgresUUID
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.sql import func

from app.db.base import Base


class PlayerRole(StrEnum):
    FIELD = "FIELD"
    GOALKEEPER = "GOALKEEPER"


class SessionStatus(StrEnum):
    PLANNED = "PLANNED"
    IN_PROGRESS = "IN_PROGRESS"
    PAUSED = "PAUSED"
    FINISHED = "FINISHED"
    ABANDONED = "ABANDONED"


class SessionPlayerRole(StrEnum):
    STARTER = "STARTER"
    SUBSTITUTE = "SUBSTITUTE"
    GOALKEEPER = "GOALKEEPER"


class ActionType(StrEnum):
    PASS = "PASS"
    FAIL_PASS = "FAIL_PASS"
    ASSIST = "ASSIST"
    SHOOT = "SHOOT"


class ShotResult(StrEnum):
    GOAL = "GOAL"
    MISSED = "MISSED"
    HIT_KEEPER = "HIT_KEEPER"
    BLOCKED = "BLOCKED"


class GoalTargetZone(StrEnum):
    TOP_LEFT = "TOP_LEFT"
    TOP_MIDDLE = "TOP_MIDDLE"
    TOP_RIGHT = "TOP_RIGHT"
    BOTTOM_LEFT = "BOTTOM_LEFT"
    BOTTOM_MIDDLE = "BOTTOM_MIDDLE"
    BOTTOM_RIGHT = "BOTTOM_RIGHT"


class KeeperSide(StrEnum):
    GLOVE = "GLOVE"
    PAD = "PAD"
    UNKNOWN = "UNKNOWN"


class ShotOriginZone(StrEnum):
    ZONE_1 = "ZONE_1"
    ZONE_2 = "ZONE_2"
    ZONE_3 = "ZONE_3"
    ZONE_4 = "ZONE_4"


class GoalkeeperActionResult(StrEnum):
    SAVE = "SAVE"
    GOAL_ALLOWED = "GOAL_ALLOWED"


def enum_column(enum_type: type[StrEnum]) -> Enum:
    return Enum(
        enum_type,
        values_callable=lambda values: [item.value for item in values],
        native_enum=False,
        create_constraint=True,
    )


class TimestampMixin:
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )


class VersionMixin:
    version: Mapped[int] = mapped_column(Integer, nullable=False, default=1)


class Coach(TimestampMixin, VersionMixin, Base):
    __tablename__ = "coaches"
    __table_args__ = (CheckConstraint("version >= 1", name="ck_coaches_version"),)

    id: Mapped[UUID] = mapped_column(PostgresUUID(as_uuid=True), primary_key=True)
    full_name: Mapped[str] = mapped_column(String(120), nullable=False)
    email: Mapped[str | None] = mapped_column(String(180))


class Team(TimestampMixin, VersionMixin, Base):
    __tablename__ = "teams"
    __table_args__ = (CheckConstraint("version >= 1", name="ck_teams_version"),)

    id: Mapped[UUID] = mapped_column(PostgresUUID(as_uuid=True), primary_key=True)
    coach_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("coaches.id"),
        nullable=False,
    )
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    category: Mapped[str | None] = mapped_column(String(80))

    coach: Mapped[Coach] = relationship()


class Player(TimestampMixin, VersionMixin, Base):
    __tablename__ = "players"
    __table_args__ = (
        CheckConstraint(
            "jersey_number >= 0 AND jersey_number <= 999",
            name="ck_players_jersey_number",
        ),
        CheckConstraint("version >= 1", name="ck_players_version"),
        Index(
            "uq_players_active_team_jersey",
            "team_id",
            "jersey_number",
            unique=True,
            postgresql_where=text("active"),
        ),
    )

    id: Mapped[UUID] = mapped_column(PostgresUUID(as_uuid=True), primary_key=True)
    team_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("teams.id"),
        nullable=False,
    )
    display_name: Mapped[str] = mapped_column(String(120), nullable=False)
    jersey_number: Mapped[int] = mapped_column(Integer, nullable=False)
    default_role: Mapped[PlayerRole] = mapped_column(enum_column(PlayerRole))
    active: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)

    team: Mapped[Team] = relationship()


class TournamentSession(TimestampMixin, VersionMixin, Base):
    __tablename__ = "tournament_sessions"
    __table_args__ = (
        CheckConstraint("elapsed_ms >= 0", name="ck_sessions_elapsed_ms"),
        CheckConstraint("version >= 1", name="ck_sessions_version"),
    )

    id: Mapped[UUID] = mapped_column(PostgresUUID(as_uuid=True), primary_key=True)
    tournament_name: Mapped[str] = mapped_column(String(160), nullable=False)
    scheduled_date: Mapped[date] = mapped_column(Date, nullable=False)
    start_time: Mapped[time | None] = mapped_column(Time(timezone=False))
    team_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("teams.id"),
        nullable=False,
    )
    coach_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("coaches.id"),
        nullable=False,
    )
    active_goalkeeper_id: Mapped[UUID | None] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("players.id"),
    )
    status: Mapped[SessionStatus] = mapped_column(enum_column(SessionStatus))
    elapsed_ms: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    device_id: Mapped[str] = mapped_column(String(120), nullable=False)

    coach: Mapped[Coach] = relationship()
    team: Mapped[Team] = relationship()
    active_goalkeeper: Mapped[Player | None] = relationship()


class SessionPlayer(TimestampMixin, VersionMixin, Base):
    __tablename__ = "session_players"
    __table_args__ = (
        CheckConstraint("version >= 1", name="ck_session_players_version"),
    )

    session_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("tournament_sessions.id", ondelete="CASCADE"),
        primary_key=True,
    )
    player_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("players.id"),
        primary_key=True,
    )
    role: Mapped[SessionPlayerRole] = mapped_column(enum_column(SessionPlayerRole))

    player: Mapped[Player] = relationship()
    session: Mapped[TournamentSession] = relationship()


class MatchAction(TimestampMixin, VersionMixin, Base):
    __tablename__ = "match_actions"
    __table_args__ = (
        CheckConstraint("chronometer_ms >= 0", name="ck_match_actions_chronometer_ms"),
        CheckConstraint("version >= 1", name="ck_match_actions_version"),
        UniqueConstraint(
            "device_id",
            "client_event_id",
            name="uq_match_actions_device_event",
        ),
        Index("ix_match_actions_session_chrono", "session_id", "chronometer_ms"),
    )

    id: Mapped[UUID] = mapped_column(PostgresUUID(as_uuid=True), primary_key=True)
    session_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("tournament_sessions.id"),
        nullable=False,
    )
    player_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("players.id"),
        nullable=False,
    )
    action_type: Mapped[ActionType] = mapped_column(enum_column(ActionType))
    chronometer_ms: Mapped[int] = mapped_column(Integer, nullable=False)
    client_event_id: Mapped[str] = mapped_column(String(120), nullable=False)
    device_id: Mapped[str] = mapped_column(String(120), nullable=False)
    voided_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True))
    void_reason: Mapped[str | None] = mapped_column(String(160))

    player: Mapped[Player] = relationship()
    session: Mapped[TournamentSession] = relationship()
    shoot_details: Mapped[ShootDetails | None] = relationship(
        back_populates="action",
        cascade="all, delete-orphan",
        uselist=False,
    )


class ShootDetails(Base):
    __tablename__ = "shoot_details"

    action_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("match_actions.id", ondelete="CASCADE"),
        primary_key=True,
    )
    result: Mapped[ShotResult] = mapped_column(enum_column(ShotResult))
    target_zone: Mapped[GoalTargetZone] = mapped_column(enum_column(GoalTargetZone))
    keeper_side: Mapped[KeeperSide] = mapped_column(
        enum_column(KeeperSide),
        default=KeeperSide.UNKNOWN,
    )

    action: Mapped[MatchAction] = relationship(back_populates="shoot_details")


class GoalkeeperAction(TimestampMixin, VersionMixin, Base):
    __tablename__ = "goalkeeper_actions"
    __table_args__ = (
        CheckConstraint(
            "chronometer_ms >= 0",
            name="ck_goalkeeper_actions_chronometer_ms",
        ),
        CheckConstraint("version >= 1", name="ck_goalkeeper_actions_version"),
        UniqueConstraint(
            "device_id",
            "client_event_id",
            name="uq_goalkeeper_actions_device_event",
        ),
        Index(
            "ix_goalkeeper_actions_session_chrono",
            "session_id",
            "chronometer_ms",
        ),
    )

    id: Mapped[UUID] = mapped_column(PostgresUUID(as_uuid=True), primary_key=True)
    session_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("tournament_sessions.id"),
        nullable=False,
    )
    goalkeeper_id: Mapped[UUID] = mapped_column(
        PostgresUUID(as_uuid=True),
        ForeignKey("players.id"),
        nullable=False,
    )
    shot_origin_zone: Mapped[ShotOriginZone] = mapped_column(
        enum_column(ShotOriginZone)
    )
    result: Mapped[GoalkeeperActionResult] = mapped_column(
        enum_column(GoalkeeperActionResult)
    )
    chronometer_ms: Mapped[int] = mapped_column(Integer, nullable=False)
    client_event_id: Mapped[str] = mapped_column(String(120), nullable=False)
    device_id: Mapped[str] = mapped_column(String(120), nullable=False)

    goalkeeper: Mapped[Player] = relationship()
    session: Mapped[TournamentSession] = relationship()
