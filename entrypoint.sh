#!/usr/bin/env bash
set -euo pipefail

: "${MODEL_NAME:?You must set MODEL_NAME env var (e.g. Qwen/Qwen3-8B)}"

# Optional: external served name (short alias)
SERVED_MODEL_NAME="${SERVED_MODEL_NAME:-$MODEL_NAME}"

# Optional HF token wiring
if [[ -n "${HF_TOKEN:-}" && -z "${HUGGING_FACE_HUB_TOKEN:-}" ]]; then
  export HUGGING_FACE_HUB_TOKEN="$HF_TOKEN"
fi

# Extra flags like --max-model-len, --gpu-memory-utilization, etc.
EXTRA_ARGS=${VLLM_ARGS:-}

echo "Starting vLLM with:"
echo "  model_tag         = ${MODEL_NAME}"
echo "  served_model_name = ${SERVED_MODEL_NAME}"
echo "  host              = ${HOST:-0.0.0.0}"
echo "  port              = ${PORT:-8000}"
echo "  extra args        = ${EXTRA_ARGS}"

set -x
vllm serve "${MODEL_NAME}" \
  --host "${HOST:-0.0.0.0}" \
  --port "${PORT:-8000}" \
  --served-model-name "${SERVED_MODEL_NAME}" \
  ${EXTRA_ARGS}
