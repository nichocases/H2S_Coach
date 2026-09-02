from functools import lru_cache

from pydantic import Field
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


@lru_cache
def get_settings() -> Settings:
    return Settings()
