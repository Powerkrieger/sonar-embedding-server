# CUDA 12.4 runtime + cuDNN
FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

# -------------------------
# System setup
# -------------------------
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

# -------------------------
# Python setup
# -------------------------
RUN pip install --upgrade pip

# -------------------------
# PyTorch (CUDA 12.4)
# -------------------------
RUN pip install torch --index-url https://download.pytorch.org/whl/cu124

# -------------------------
# fairseq2 FIRST (important)
# -------------------------
RUN pip install fairseq2 --extra-index-url https://fair.pkg.atmeta.com/fairseq2/whl/pt2.6.0/cu124

# -------------------------
# Remaining deps (SONAR, API)
# -------------------------
RUN pip install sonar-space fastapi uvicorn pydantic

# -------------------------
# App code
# -------------------------
COPY embedding_server.py .

# -------------------------
# Runtime config
# -------------------------
ENV PYTHONUNBUFFERED=1
ENV CUDA_VISIBLE_DEVICES=0

EXPOSE 8808

# -------------------------
# Start server
# -------------------------
CMD ["uvicorn", "embedding_server:app", "--host", "0.0.0.0", "--port", "8808"]

