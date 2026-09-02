from typing import Annotated

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.session import get_session
from app.schemas.entities import SyncRequestSchema, SyncResponseSchema
from app.services.sync import DatabaseSyncProcessor, SyncProcessorProtocol

router = APIRouter(prefix="/api/v1", tags=["sync"])


def get_sync_processor(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> SyncProcessorProtocol:
    return DatabaseSyncProcessor(session)


@router.post("/sync", response_model=SyncResponseSchema)
async def sync(
    request: SyncRequestSchema,
    processor: Annotated[SyncProcessorProtocol, Depends(get_sync_processor)],
) -> SyncResponseSchema:
    return await processor.process(request)
