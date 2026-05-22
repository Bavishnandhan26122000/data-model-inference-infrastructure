from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import time
import uuid

app = FastAPI(title="Data Model Inference API", version="1.0.0")

class InferenceRequest(BaseModel):
    data: list[float]
    model_version: str = "latest"

class InferenceResponse(BaseModel):
    request_id: str
    prediction: list[float]
    latency_ms: float

# Dummy model class simulating a neural network or ML model
class DummyModel:
    def predict(self, data):
        # Simulate inference time
        time.sleep(0.05)
        # Return a simple transformation as the prediction
        return [x * 2.5 for x in data]

model = DummyModel()

@app.post("/predict", response_model=InferenceResponse)
async def predict(request: InferenceRequest):
    if not request.data:
        raise HTTPException(status_code=400, detail="Data cannot be empty")
    
    start_time = time.time()
    
    try:
        prediction = model.predict(request.data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
    latency = (time.time() - start_time) * 1000
    
    return InferenceResponse(
        request_id=str(uuid.uuid4()),
        prediction=prediction,
        latency_ms=latency
    )

@app.get("/health")
async def health_check():
    return {"status": "healthy", "model_loaded": True}
