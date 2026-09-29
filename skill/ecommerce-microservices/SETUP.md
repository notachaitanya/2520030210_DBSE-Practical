# Setup (run once)

Node services (user-service, activity-service):
    cd user-service
    npm install
    cd ..\activity-service
    npm install

Python services (product-service, inventory-service, order-service, api-gateway):
    cd product-service
    python -m venv .venv
    .venv\Scripts\activate
    pip install -r requirements.txt
  (repeat in the other three folders)

# Run (six terminals, all stay open)
    user-service:      node server.js
    activity-service:  node server.js
    product-service:   .venv\Scripts\activate  then  uvicorn main:app --reload --port 8003
    inventory-service: .venv\Scripts\activate  then  uvicorn main:app --reload --port 8004
    order-service:     .venv\Scripts\activate  then  uvicorn main:app --reload --port 8005
    api-gateway:       .venv\Scripts\activate  then  uvicorn main:app --reload --port 8000
