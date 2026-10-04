#!/bin/bash
# Railway 启动脚本：ttyd 网页终端，监听 Railway 注入的 $PORT
set -e

PORT="${PORT:-7681}"
TTYD_USER="${TTYD_USER:-fei}"

if [ -z "${TTYD_PASSWORD:-}" ]; then
  echo "错误：请在 Railway Variables 里设置 TTYD_PASSWORD" >&2
  exit 1
fi

exec ttyd -p "$PORT" -c "${TTYD_USER}:${TTYD_PASSWORD}" \
  env NO_PROXY=localhost,127.0.0.1 \
    GEMINI_API_KEY="$GEMINI_API_KEY" \
    OPENROUTER_API_KEY="$OPENROUTER_API_KEY" \
    GROQ_API_KEY="$GROQ_API_KEY" \
  bash -c 'cd /workspace && exec bash'
