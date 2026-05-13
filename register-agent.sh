#!/bin/bash
# Sincroniza todos los agentes del repo en ~/.claude/agents/ como copias reales.
# Idempotente: se puede correr las veces que quieras.
# Uso: ./register-agent.sh

set -e

AGENTS_DIR="/Users/cappa/Dev/agents"
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"

mkdir -p "$CLAUDE_AGENTS_DIR"

find "$AGENTS_DIR" -name "*.md" -not -name "README.md" | while read SOURCE; do
  NAME=$(basename "$SOURCE")
  cp -f "$SOURCE" "$CLAUDE_AGENTS_DIR/$NAME"
  echo "✓ $NAME"
done
