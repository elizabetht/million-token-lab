# Pin to a specific vLLM OpenAI-compatible image tag
FROM vllm/vllm-openai:v0.11.2

# Optional tools (health checks, debugging)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

ENV PORT=8000
ENV HOST=0.0.0.0

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]