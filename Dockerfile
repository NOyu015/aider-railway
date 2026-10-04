# Aider 网页终端（部署到 Railway，手机直接用）
#
# 部署步骤（Railway Dashboard）：
# 1. New Project -> Deploy from GitHub repo -> 选这个仓库
# 2. Variables 里填：GEMINI_API_KEY / OPENROUTER_API_KEY / GROQ_API_KEY / TTYD_USER / TTYD_PASSWORD
# 3. Settings -> Networking -> Generate Domain，拿到公网地址
# 手机打开地址，输入 TTYD_USER / TTYD_PASSWORD 登录，进终端后输入 aider 回车即用。

FROM python:3.12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates nginx apache2-utils \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir aider-chat \
    && curl -fsSL -o /usr/local/bin/ttyd \
         https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x /usr/local/bin/ttyd \
    && aider --version

WORKDIR /workspace
RUN git init -q . \
    && printf 'model: gemini/gemini-3.8-flash\n' > .aider.conf.yml \
    && printf '.aider*\n' > .gitignore \
    && git add -A \
    && git -c user.email=aider@local -c user.name=aider commit -qm init 2>/dev/null || true

COPY start.sh /usr/local/bin/start.sh
COPY nginx-aider.conf.template /usr/local/share/aider/nginx-aider.conf.template
RUN chmod +x /usr/local/bin/start.sh \
    && rm -f /etc/nginx/sites-enabled/default

CMD ["/usr/local/bin/start.sh"]
