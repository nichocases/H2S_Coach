import asyncio
from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy import text
import os

async def main():
    engine = create_async_engine("postgresql+asyncpg" + os.environ["DATABASE_URL"][10:])
    async with engine.connect() as conn:
        profiles = await conn.execute(text("SELECT id, role FROM public.profiles"))
        print("Profiles in DB:", profiles.fetchall())

asyncio.run(main())
