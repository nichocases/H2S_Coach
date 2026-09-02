"""Create MVP persistence schema.

Revision ID: 0001_initial_schema
Revises:
Create Date: 2026-09-01 00:00:00.000000
"""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

revision: str = "0001_initial_schema"
down_revision: str | None = None
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

player_role = sa.Enum(
    "FIELD",
    "GOALKEEPER",
    name="player_role",
    native_enum=False,
    create_constraint=True,
)
session_status = sa.Enum(
    "PLANNED",
    "IN_PROGRESS",
    "PAUSED",
    "FINISHED",
    "ABANDONED",
    name="session_status",
    native_enum=False,
    create_constraint=True,
)
session_player_role = sa.Enum(
    "STARTER",
    "SUBSTITUTE",
    "GOALKEEPER",
    name="session_player_role",
    native_enum=False,
    create_constraint=True,
)
action_type = sa.Enum(
    "PASS",
    "FAIL_PASS",
    "ASSIST",
    "SHOOT",
    name="action_type",
    native_enum=False,
    create_constraint=True,
)
shot_result = sa.Enum(
    "GOAL",
    "MISSED",
    "HIT_KEEPER",
    "BLOCKED",
    name="shot_result",
    native_enum=False,
    create_constraint=True,
)
goal_target_zone = sa.Enum(
    "TOP_LEFT",
    "TOP_MIDDLE",
    "TOP_RIGHT",
    "BOTTOM_LEFT",
    "BOTTOM_MIDDLE",
    "BOTTOM_RIGHT",
    name="goal_target_zone",
    native_enum=False,
    create_constraint=True,
)
keeper_side = sa.Enum(
    "GLOVE",
    "PAD",
    "UNKNOWN",
    name="keeper_side",
    native_enum=False,
    create_constraint=True,
)
shot_origin_zone = sa.Enum(
    "ZONE_1",
    "ZONE_2",
    "ZONE_3",
    "ZONE_4",
    name="shot_origin_zone",
    native_enum=False,
    create_constraint=True,
)
goalkeeper_action_result = sa.Enum(
    "SAVE",
    "GOAL_ALLOWED",
    name="goalkeeper_action_result",
    native_enum=False,
    create_constraint=True,
)


def timestamp_columns() -> list[sa.Column[sa.DateTime]]:
    return [
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
    ]


def upgrade() -> None:
    op.create_table(
        "coaches",
        sa.Column("id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("full_name", sa.String(length=120), nullable=False),
        sa.Column("email", sa.String(length=180), nullable=True),
        *timestamp_columns(),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.CheckConstraint("version >= 1", name="ck_coaches_version"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "teams",
        sa.Column("id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("coach_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("name", sa.String(length=120), nullable=False),
        sa.Column("category", sa.String(length=80), nullable=True),
        *timestamp_columns(),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.CheckConstraint("version >= 1", name="ck_teams_version"),
        sa.ForeignKeyConstraint(["coach_id"], ["coaches.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "players",
        sa.Column("id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("team_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("display_name", sa.String(length=120), nullable=False),
        sa.Column("jersey_number", sa.Integer(), nullable=False),
        sa.Column("default_role", player_role, nullable=False),
        sa.Column("active", sa.Boolean(), nullable=False, server_default="true"),
        *timestamp_columns(),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.CheckConstraint(
            "jersey_number >= 0 AND jersey_number <= 999",
            name="ck_players_jersey_number",
        ),
        sa.CheckConstraint("version >= 1", name="ck_players_version"),
        sa.ForeignKeyConstraint(["team_id"], ["teams.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        "uq_players_active_team_jersey",
        "players",
        ["team_id", "jersey_number"],
        unique=True,
        postgresql_where=sa.text("active"),
    )
    op.create_table(
        "tournament_sessions",
        sa.Column("id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("tournament_name", sa.String(length=160), nullable=False),
        sa.Column("scheduled_date", sa.Date(), nullable=False),
        sa.Column("start_time", sa.Time(), nullable=True),
        sa.Column("team_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("coach_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("active_goalkeeper_id", postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column("status", session_status, nullable=False),
        sa.Column("elapsed_ms", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("device_id", sa.String(length=120), nullable=False),
        *timestamp_columns(),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.CheckConstraint("elapsed_ms >= 0", name="ck_sessions_elapsed_ms"),
        sa.CheckConstraint("version >= 1", name="ck_sessions_version"),
        sa.ForeignKeyConstraint(["active_goalkeeper_id"], ["players.id"]),
        sa.ForeignKeyConstraint(["coach_id"], ["coaches.id"]),
        sa.ForeignKeyConstraint(["team_id"], ["teams.id"]),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_table(
        "session_players",
        sa.Column("session_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("player_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("role", session_player_role, nullable=False),
        *timestamp_columns(),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.CheckConstraint("version >= 1", name="ck_session_players_version"),
        sa.ForeignKeyConstraint(
            ["session_id"],
            ["tournament_sessions.id"],
            ondelete="CASCADE",
        ),
        sa.ForeignKeyConstraint(["player_id"], ["players.id"]),
        sa.PrimaryKeyConstraint("session_id", "player_id"),
    )
    op.create_table(
        "match_actions",
        sa.Column("id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("session_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("player_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("action_type", action_type, nullable=False),
        sa.Column("chronometer_ms", sa.Integer(), nullable=False),
        sa.Column("client_event_id", sa.String(length=120), nullable=False),
        sa.Column("device_id", sa.String(length=120), nullable=False),
        *timestamp_columns(),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.Column("voided_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("void_reason", sa.String(length=160), nullable=True),
        sa.CheckConstraint(
            "chronometer_ms >= 0",
            name="ck_match_actions_chronometer_ms",
        ),
        sa.CheckConstraint("version >= 1", name="ck_match_actions_version"),
        sa.ForeignKeyConstraint(["player_id"], ["players.id"]),
        sa.ForeignKeyConstraint(["session_id"], ["tournament_sessions.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint(
            "device_id",
            "client_event_id",
            name="uq_match_actions_device_event",
        ),
    )
    op.create_index(
        "ix_match_actions_session_chrono",
        "match_actions",
        ["session_id", "chronometer_ms"],
    )
    op.create_table(
        "shoot_details",
        sa.Column("action_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("result", shot_result, nullable=False),
        sa.Column("target_zone", goal_target_zone, nullable=False),
        sa.Column("keeper_side", keeper_side, nullable=False),
        sa.ForeignKeyConstraint(
            ["action_id"],
            ["match_actions.id"],
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("action_id"),
    )
    op.create_table(
        "goalkeeper_actions",
        sa.Column("id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("session_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("goalkeeper_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("shot_origin_zone", shot_origin_zone, nullable=False),
        sa.Column("result", goalkeeper_action_result, nullable=False),
        sa.Column("chronometer_ms", sa.Integer(), nullable=False),
        sa.Column("client_event_id", sa.String(length=120), nullable=False),
        sa.Column("device_id", sa.String(length=120), nullable=False),
        *timestamp_columns(),
        sa.Column("version", sa.Integer(), nullable=False, server_default="1"),
        sa.CheckConstraint(
            "chronometer_ms >= 0",
            name="ck_goalkeeper_actions_chronometer_ms",
        ),
        sa.CheckConstraint("version >= 1", name="ck_goalkeeper_actions_version"),
        sa.ForeignKeyConstraint(["goalkeeper_id"], ["players.id"]),
        sa.ForeignKeyConstraint(["session_id"], ["tournament_sessions.id"]),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint(
            "device_id",
            "client_event_id",
            name="uq_goalkeeper_actions_device_event",
        ),
    )
    op.create_index(
        "ix_goalkeeper_actions_session_chrono",
        "goalkeeper_actions",
        ["session_id", "chronometer_ms"],
    )


def downgrade() -> None:
    op.drop_index(
        "ix_goalkeeper_actions_session_chrono", table_name="goalkeeper_actions"
    )
    op.drop_table("goalkeeper_actions")
    op.drop_table("shoot_details")
    op.drop_index("ix_match_actions_session_chrono", table_name="match_actions")
    op.drop_table("match_actions")
    op.drop_table("session_players")
    op.drop_table("tournament_sessions")
    op.drop_index("uq_players_active_team_jersey", table_name="players")
    op.drop_table("players")
    op.drop_table("teams")
    op.drop_table("coaches")
