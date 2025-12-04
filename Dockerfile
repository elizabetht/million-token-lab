# Dockerfile for vLLM on ARM64 (DGX Spark, Grace Hopper)
# Uses NVIDIA's PyTorch container which supports ARM64 + CUDA

FROM nvcr.io/nvidia/pytorch:24.01-py3

# Install vLLM
RUN pip install --no-cache-dir vllm

ENV PORT=8000
ENV HOST=0.0.0.0

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]