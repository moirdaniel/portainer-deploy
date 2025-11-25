#!/usr/bin/env bash
set -e

echo "[deploy.sh] Ejecutando deploy en $(pwd)"

if [ -f docker-compose.yml ] || [ -f docker-compose.yaml ]; then
  echo "[deploy.sh] Estado ANTES:"
  docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}' | grep proxy || echo "(no proxy*)"

  echo "[deploy.sh] docker compose down..."
  docker compose down || true

  echo "[deploy.sh] docker compose pull..."
  docker compose pull

  echo "[deploy.sh] docker compose up -d --remove-orphans..."
  docker compose up -d --remove-orphans

  echo "[deploy.sh] Estado DESPUÉS:"
  docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}' | grep proxy || echo "(no proxy*)"
else
  echo "❌ ERROR: No se encontró docker-compose.yml ni docker-compose.yaml en $(pwd)"
  ls -la
  exit 1
fi
