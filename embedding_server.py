import torch
from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

from sonar.inference_pipelines.text import TextToEmbeddingModelPipeline

torch.set_grad_enabled(False)

DEVICE = "cuda" if torch.cuda.is_available() else "cpu"

model = TextToEmbeddingModelPipeline(
  encoder="text_sonar_basic_encoder", 
  tokenizer="text_sonar_basic_encoder", 
  device=torch.device("cuda"),
  dtype=torch.float16,
)

# FP16 is correct for RTX 2080 Ti
model.model.half()

app = FastAPI(title="SONAR Embeddings API")

class EmbeddingRequest(BaseModel):
    input: List[str]
    model: str | None = None

@app.post("/v1/embeddings")
def create_embeddings(req: EmbeddingRequest):
    vectors = model.predict(req.input, source_lang="eng_Latn")
    return {
        "object": "list",
        "model": "sonar_text",
        "data": [
            {"object": "embedding", "embedding": vec.tolist(), "index": i}
            for i, vec in enumerate(vectors)
        ],
    }
