#!/usr/bin/env bash
# Boot local Apache Superset via the official Docker Compose quickstart.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SUPERSET_DIR="$ROOT/superset"
TAG="${SUPERSET_TAG:-6.0.0}"

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Start Docker Desktop, then re-run ./start.sh"
  exit 1
fi

if [[ ! -d "$SUPERSET_DIR/.git" ]]; then
  echo "Cloning Apache Superset @ $TAG ..."
  git clone --depth 1 --branch "$TAG" https://github.com/apache/superset.git "$SUPERSET_DIR"
fi

cd "$SUPERSET_DIR"
echo "Starting Superset (first run pulls images + loads examples; can take a few minutes) ..."
docker compose -f docker-compose-image-tag.yml up -d

echo ""
echo "Superset is coming up at http://localhost:8088"
echo "Login: admin / admin"
echo ""
echo "Watch logs:  cd superset && docker compose -f docker-compose-image-tag.yml logs -f"
echo "Stop:        ./stop.sh"
