#!/bin/sh
set -e

mkdir -p /root/.hermes

cat > /root/.hermes/config.yaml <<EOF
model:
  provider: custom
  base_url: ${CURSOR_PROXY_URL}
  api_key: no-key-needed
  default: auto
EOF

cat > /root/.hermes/.env <<EOF
API_SERVER_ENABLED=false
EOF

exec hermes "$@"
