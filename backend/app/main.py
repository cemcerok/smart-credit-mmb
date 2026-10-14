from fastapi import FastAPI

from app.api.routers.health import router as health_router

app = FastAPI()

app.include_router(health_router)

@app.get("/")
async def root():
    return {"message": "Smart Credit MMB API"}
