# Aider 网页终端

把开源 AI 编程工具 [Aider](https://aider.chat) 跑在 Railway 上，手机浏览器打开就能用，不用绑卡，用免费 Key。

## Railway 部署

1. Railway 里 New Project → Deploy from GitHub repo，选本仓库。
2. Variables 里填 5 个环境变量：
   - `GEMINI_API_KEY`：Google AI Studio 的免费 Key
   - `OPENROUTER_API_KEY`：OpenRouter 的 Key
   - `GROQ_API_KEY`：Groq 的 Key
   - `TTYD_USER`：网页终端登录用户名（默认 fei）
   - `TTYD_PASSWORD`：网页终端登录密码（自己定个随机的）
3. Settings → Networking → Generate Domain，拿到公网地址。
4. 手机打开地址 → 输入用户名密码 → 进终端输入 `aider` 回车。

默认模型 `groq/qwen/qwen3.8-27b`（免费、速度快），可在终端里用 `/model` 切换，
或改 `/workspace/.aider.conf.yml`。

## 花费

ttyd + aider 待机几乎不占资源，按量计费下偶尔用一个月也就几毛钱。
不用的时候在 Railway 里把 Service 暂停（Stop），一分钱不烧。
