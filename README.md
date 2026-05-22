# hermes-cursor

Runs [Hermes Agent](https://hermes-agent.nousresearch.com/docs/) backed by Cursor's LLM via [cursor-api-proxy](https://github.com/anyrobert/cursor-api-proxy). Two containers, one internal Docker network — no credentials baked into images.

```
cursor-proxy (port 8765)   <──ai-net──>   hermes
  Cursor CLI + OpenAI-compatible API          Hermes Agent
```

## Requirements

- Docker + Compose (OrbStack works out of the box)
- A Cursor account with an active subscription
- Your Cursor auth token (`crsr_...`)

## Setup

```bash
cp .env.example .env
# Edit .env and set your token:
# CURSOR_API_KEY=crsr_...
```

## Build & run

```bash
docker compose build
docker compose up -d
```

## Usage

One-shot query:

```bash
docker compose run --rm hermes chat -q "Hello, which model are you?"
```

Interactive chat:

```bash
docker compose run --rm -it hermes chat
```

Resume a previous session:

```bash
docker compose run --rm hermes chat --resume <session-id>
```

## Configuration

| Variable | Where | Description |
|---|---|---|
| `CURSOR_API_KEY` | `.env` | Cursor auth token (`crsr_...`) |
| `CURSOR_PROXY_URL` | `docker-compose.yml` | Internal proxy URL (default: `http://cursor-proxy:8765/v1`) |

The model is set in `hermes/entrypoint.sh`. Default is `auto` (Cursor picks the model). To pin a specific model change the `default:` field and rebuild:

```bash
# hermes/entrypoint.sh
default: claude-sonnet-4-6
```

```bash
docker compose build hermes && docker compose up hermes -d
```

## Verify proxy

```bash
# Check proxy is up and reachable
docker compose exec cursor-proxy curl http://localhost:8765/v1/models

# Watch proxy logs during a request
docker compose logs -f cursor-proxy
```

## Project structure

```
hermes-cursor/
├── docker-compose.yml
├── .env                   # your secrets (not committed)
├── .env.example
├── cursor-proxy/
│   └── Dockerfile         # node:22-slim + Cursor CLI + cursor-api-proxy
└── hermes/
    ├── Dockerfile         # python:3.12-slim + hermes-agent
    └── entrypoint.sh      # writes ~/.hermes/config.yaml from env, then execs hermes
```

## Notes

- Sessions are persisted in the `hermes-data` Docker volume across restarts.
- No ports are exposed to the host by default. On OrbStack, `cursor-proxy` is also reachable at `cursor-proxy.orb.local:8765` for debugging.
- `cursor-api-proxy` listens on port `8765` (hardcoded) and requires `--tailscale` to bind to `0.0.0.0` inside Docker.
