import asyncio
from sqlalchemy.ext.asyncio import create_async_engine
from sqlalchemy import text
import os

async def main():
    engine = create_async_engine("postgresql+asyncpg" + os.environ["DATABASE_URL"][10:])
    async with engine.connect() as conn:
        users = await conn.execute(text("SELECT id, email FROM auth.users"))
        print("Users:", users.fetchall())
        profiles = await conn.execute(text("SELECT * FROM public.profiles"))
        print("Profiles:", profiles.fetchall())

asyncio.run(main())
