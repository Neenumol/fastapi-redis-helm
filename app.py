from fastapi import FastAPI, HTTPException
import redis
import os

app=FastAPI()

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))
REDIS_PASSWORD = os.getenv("REDIS_PASSWORD")

r=redis.Redis(host='redis', port=6379)

@app.get("/")
def root():
    return{"message": "FastAPI is working"}

@app.post("/api/set")
def store_value(key: str, value: str):
    r.set(key,value)
    return{"message":f"stored key '{key}'"}

@app.get("/api/get")
def get_value(key: str):
    value =r.get(key)
    if value is None:
        raise HTTPException(status_code=404, detail="key not found")
    return{"key":key, "value":value.decode()}


@app.get("/secret-test")
def show_secret():
    return{"password": os.getenv("REDIS_PASSWORD")}