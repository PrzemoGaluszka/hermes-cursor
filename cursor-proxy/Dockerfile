FROM node:22-slim

RUN apt-get update && apt-get install -y curl ca-certificates --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install Cursor CLI
RUN curl https://cursor.com/install -fsS | bash

ENV PATH="/root/.local/bin:/root/.cursor/bin:$PATH"

# Install the OpenAI-compatible proxy for Cursor
RUN npm install -g cursor-api-proxy

EXPOSE 8765

# --tailscale binds to 0.0.0.0 (required for Docker networking)
CMD ["cursor-api-proxy", "--tailscale"]
