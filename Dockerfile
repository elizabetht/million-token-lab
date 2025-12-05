# Dockerfile for vLLM on DGX Spark (Grace Hopper)
# Builds vLLM from source with CUDA 12.1a architecture

FROM nvidia/cuda:13.0.2-cudnn-devel-ubuntu24.04

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-dev \
    cmake \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Create virtual env
RUN python3.12 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip
RUN pip install --upgrade pip

# Set environment for DGX Spark (CUDA arch 12.1a)
ENV TORCH_CUDA_ARCH_LIST="12.1"
ENV TRITON_PTXAS_PATH=/usr/local/cuda/bin/ptxas
ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Install PyTorch + CUDA
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130

# Install vLLM dependencies
RUN pip install --no-cache-dir \
    xgrammar \
    triton

# Try to install flashinfer (may have prebuilt wheels for ARM64)
RUN pip install --no-cache-dir flashinfer-python --prerelease=allow || echo "flashinfer not available, skipping"

# Clone vLLM
ARG VLLM_VERSION=main
RUN git clone --depth 1 --branch ${VLLM_VERSION} https://github.com/vllm-project/vllm.git /vllm

# Build vLLM from source
WORKDIR /vllm
RUN python3 use_existing_torch.py \
    && pip install --no-cache-dir -r requirements/build.txt \
    && pip install --no-build-isolation -e . --prerelease=allow

ENV PORT=8000
ENV HOST=0.0.0.0

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]