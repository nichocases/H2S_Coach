from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.v1.health import router as health_router
from app.api.v1.sync import router as sync_router
from app.core.config import get_settings


def create_app() -> FastAPI:
    app = FastAPI(title="Inline Hockey Coach API", version="1.0.0")
    settings = get_settings()

    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    app.include_router(health_router)
    app.include_router(sync_router)
    return app

app = create_app()
