# Jetson Thor / JetPack 7 / CUDA 13 / PyTorch 2.8 base
FROM nvcr.io/nvidia/pytorch:25.08-py3

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Basic OS deps for ComfyUI
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    ca-certificates \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Clone ComfyUI fork that adds proper HunyuanImage2.1 support
RUN git clone --depth=1 https://github.com/KimbingNg/ComfyUI-HunyuanImage2.1.git ComfyUI

WORKDIR /opt/ComfyUI

# Install Python deps (torch is already provided by the base image)
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Create model directories (you'll mount into these)
RUN mkdir -p \
    /opt/ComfyUI/models/text_encoders \
    /opt/ComfyUI/models/vae \
    /opt/ComfyUI/models/diffusion_models

# Expose ComfyUI default port
EXPOSE 8188

# Run ComfyUI, listening on all interfaces
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
