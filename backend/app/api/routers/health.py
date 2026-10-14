from typing import Annotated

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.db.database import get_db

router = APIRouter()

DatabaseSession = Annotated[AsyncSession, Depends(get_db)]

@router.get("/health")
async def health():
    return {"status": "ok"}

@router.get("/health/db")
async def health_db(db: DatabaseSession):
    await db.execute(select(1))

    return {"status": "ok"}
