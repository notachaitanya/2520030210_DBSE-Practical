import os

import httpx
from fastapi import FastAPI
from fastapi.responses import JSONResponse

app = FastAPI(title="BookFlow Gateway")

SPRING_SERVICE = os.getenv("SPRING_SERVICE_URL", "http://localhost:8081")


async def forward(method: str, path: str, body: dict | None = None):
    """Send the request to Spring Boot and pass back its status code and JSON."""
    try:
        async with httpx.AsyncClient(timeout=5.0) as client:
            r = await client.request(method, f"{SPRING_SERVICE}{path}", json=body)
        return JSONResponse(status_code=r.status_code, content=r.json())
    except httpx.TimeoutException:
        return JSONResponse(status_code=504,
                            content={"error": "Spring Boot service timed out"})
    except httpx.RequestError:
        return JSONResponse(status_code=503,
                            content={"error": "Spring Boot service unavailable"})


@app.get("/health")
def health():
    return {"service": "bookflow-gateway", "status": "UP"}


@app.post("/gateway/orders")
async def create_order(order: dict):
    return await forward("POST", "/orders", order)


@app.get("/gateway/orders")
async def list_orders():
    return await forward("GET", "/orders")


@app.get("/gateway/inventory/{book_id}")
async def get_inventory(book_id: int):
    return await forward("GET", f"/inventory/{book_id}")


@app.post("/gateway/inventory")
async def save_inventory(item: dict):
    return await forward("POST", "/inventory", item)
