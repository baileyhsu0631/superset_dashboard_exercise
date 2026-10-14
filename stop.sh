#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SUPERSET_DIR="$ROOT/superset"

if [[ ! -d "$SUPERSET_DIR" ]]; then
  echo "No local ./superset clone found; nothing to stop."
  exit 0
fi

cd "$SUPERSET_DIR"
docker compose -f docker-compose-image-tag.yml stop
echo "Superset stopped. Data is kept; run ./start.sh to resume."
