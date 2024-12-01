# syntax=docker/dockerfile:1
# Use CUDA-enabled Python image as base
FROM python:3.10-slim

# Set labels for container metadata
LABEL org.opencontainers.image.source="https://github.com/comfyanonymous/ComfyUI"
LABEL org.opencontainers.image.description="ComfyUI - A powerful and modular stable diffusion GUI"
LABEL org.opencontainers.image.licenses="GPL-3.0"

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Clone ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git .

# Install Python dependencies
RUN pip install --no-cache-dir \
    torch \
    torchvision \
    torchaudio \
    opencv-python \
    pillow \
    transformers \
    scipy \
    numpy \
    aiohttp \
    einops \
    safetensors \
    accelerate

# Create directories for models and outputs
RUN mkdir -p models/checkpoints \
    models/clip \
    models/vae \
    models/loras \
    input \
    output

# Expose port
EXPOSE 8188

# Set environment variables
ENV PYTHONPATH="${PYTHONPATH}:/app"
ENV CUDA_HOME="/usr/local/cuda"

# Command to run the application
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188"]