#!/bin/bash
# 启动：nginx（系统级账号密码）反代 ttyd（只监听本机，不做自身认证）
set -e

PORT="${PORT:-7681}"
TTYD_PORT="${TTYD_PORT:-7681}"
TTYD_USER="${TTYD_USER:-fei}"

if [ -z "${TTYD_PASSWORD:-}" ]; then
  echo "错误：请在 Railway Variables 里设置 TTYD_PASSWORD" >&2
  exit 1
fi

# 1. 生成 nginx basic auth 密码文件（nginx worker 以 www-data 运行，需可读）
printf '%s' "$TTYD_PASSWORD" | htpasswd -ci /etc/nginx/.htpasswd "$TTYD_USER"
chmod 644 /etc/nginx/.htpasswd

# 2. 渲染 nginx 配置（填入 Railway 注入的 $PORT）
sed -e "s/\${PORT}/$PORT/g" -e "s/\${TTYD_PORT}/$TTYD_PORT/g" \
  /usr/local/share/aider/nginx-aider.conf.template > /etc/nginx/conf.d/aider.conf
rm -f /etc/nginx/sites-enabled/default
nginx -t -q

# 3. 启动 ttyd（只绑本机，无自身认证，认证交给 nginx；打开终端直接进 aider；字体调大适配手机）
ttyd -p "$TTYD_PORT" -i 127.0.0.1 -t fontSize=20 \
  env NO_PROXY=localhost,127.0.0.1 \
    GEMINI_API_KEY="$GEMINI_API_KEY" \
    OPENROUTER_API_KEY="$OPENROUTER_API_KEY" \
    GROQ_API_KEY="$GROQ_API_KEY" \
  bash -c 'cd /workspace && aider; exec bash' &
TTYD_PID=$!

# 4. 前台跑 nginx（容器主进程）
trap "kill $TTYD_PID 2>/dev/null" EXIT
exec nginx -g "daemon off;"
