import os
from bson import ObjectId
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from pymongo import MongoClient
from dotenv import load_dotenv
import httpx

load_dotenv()

app = FastAPI(title="Order Service")

client = MongoClient(os.getenv("MONGO_URI"))
db = client.get_default_database()
orders = db["orders"]

PRODUCT_URL = os.getenv("PRODUCT_SERVICE_URL")
INVENTORY_URL = os.getenv("INVENTORY_SERVICE_URL")
ACTIVITY_URL = os.getenv("ACTIVITY_SERVICE_URL")


class OrderItem(BaseModel):
    productId: str
    quantity: int = Field(gt=0)


class OrderCreate(BaseModel):
    userId: str
    items: list[OrderItem]


@app.get("/health")
def health():
    return {"service": "order-service", "status": "UP"}


@app.post("/orders", status_code=201)
async def create_order(order: OrderCreate):
    total = 0
    product_data = []

    async with httpx.AsyncClient(timeout=3.0) as http:
        # Step 1: ask Product Service for each product's price
        for item in order.items:
            r = await http.get(f"{PRODUCT_URL}/products/{item.productId}")
            if r.status_code != 200:
                raise HTTPException(
                    400, f"Product {item.productId} not available"
                )

            product = r.json()
            total += product["price"] * item.quantity
            product_data.append({
                "productId": item.productId,
                "quantity": item.quantity,
                "price": product["price"]
            })

        # Step 2: save the order as CREATED
        created = orders.insert_one({
            "userId": order.userId,
            "items": product_data,
            "totalAmount": total,
            "status": "CREATED"
        })
        order_id = str(created.inserted_id)

        # Step 3: reserve stock, remembering what we actually reserved
        reserved = []
        try:
            for item in order.items:
                r = await http.post(
                    f"{INVENTORY_URL}/inventory/{item.productId}/reserve",
                    json={"quantity": item.quantity}
                )
                if r.status_code != 200:
                    raise Exception(r.text)
                reserved.append(item)

            orders.update_one(
                {"_id": created.inserted_id},
                {"$set": {"status": "INVENTORY_RESERVED"}}
            )

            # Step 4: log the activity (failure here must not fail the order)
            try:
                await http.post(
                    f"{ACTIVITY_URL}/activities",
                    json={
                        "userId": order.userId,
                        "action": "ORDER_CREATED",
                        "metadata": {"orderId": order_id}
                    }
                )
            except Exception:
                pass

            return {
                "orderId": order_id,
                "status": "INVENTORY_RESERVED",
                "totalAmount": total
            }

        except Exception as exc:
            orders.update_one(
                {"_id": created.inserted_id},
                {"$set": {"status": "CANCELLED"}}
            )

            # Compensation: release ONLY the items we reserved for this order
            for item in reserved:
                try:
                    await http.post(
                        f"{INVENTORY_URL}/inventory/{item.productId}/release",
                        json={"quantity": item.quantity}
                    )
                except Exception:
                    pass

            raise HTTPException(
                409, f"Order failed and compensation was attempted: {exc}"
            )


@app.get("/orders/{order_id}")
def get_order(order_id: str):
    try:
        order = orders.find_one({"_id": ObjectId(order_id)})
    except Exception:
        raise HTTPException(400, "Invalid order id")

    if not order:
        raise HTTPException(404, "Order not found")

    order["_id"] = str(order["_id"])
    return order
