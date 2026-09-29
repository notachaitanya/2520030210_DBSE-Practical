from fastapi import FastAPI
from routes.catalog import router as catalog_router
from routes.admin import router as admin_router

app = FastAPI(
    title="BookFlow Library API"
)

app.include_router(catalog_router)
app.include_router(admin_router)
