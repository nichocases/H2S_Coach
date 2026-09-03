from functools import lru_cache
from typing import Any

from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    api_env: str = Field(default="local", validation_alias="API_ENV")
    api_key: str = Field(default="development-only", validation_alias="API_KEY")
    database_url: str = Field(
        default="postgresql+asyncpg://app:app@localhost:5432/inline_hockey",
        validation_alias="DATABASE_URL",
    )
    cors_origins: list[str] = Field(
        default=["*"], validation_alias="CORS_ORIGINS"
    )

    @field_validator("database_url", mode="before")
    def fix_database_url(cls, v: Any) -> Any:
        if isinstance(v, str):
            # Strip query params like ?pgbouncer=true which asyncpg rejects
            if "?" in v:
                v = v.split("?")[0]
                
            if v.startswith("postgres://"):
                v = v.replace("postgres://", "postgresql+asyncpg://", 1)
            elif v.startswith("postgresql://"):
                v = v.replace("postgresql://", "postgresql+asyncpg://", 1)
        return v


@lru_cache
def get_settings() -> Settings:
    return Settings()
