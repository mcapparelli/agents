#!/bin/bash
# Sincroniza todos los agentes del repo en ~/.claude/agents/.
# Valida que el campo `name` use formato lowercase-con-guiones.
# Idempotente — correrlo las veces que quieras.

set -e

AGENTS_DIR="/Users/cappa/Dev/agents"
CLAUDE_AGENTS_DIR="$HOME/.claude/agents"
ERRORS=0

mkdir -p "$CLAUDE_AGENTS_DIR"

find "$AGENTS_DIR" -name "*.md" -not -name "README.md" | while read SOURCE; do
  NAME=$(basename "$SOURCE")

  # Extraer el campo name del frontmatter
  AGENT_NAME=$(grep -m1 "^name:" "$SOURCE" | sed 's/^name: *//')

  # Validar formato lowercase-con-guiones
  if echo "$AGENT_NAME" | grep -qE '[A-Z ]'; then
    echo "✗ $NAME — name inválido: '$AGENT_NAME' (debe ser lowercase-con-guiones)"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  cp -f "$SOURCE" "$CLAUDE_AGENTS_DIR/$NAME"
  echo "✓ $NAME (name: $AGENT_NAME)"
done

if [ "$ERRORS" -gt 0 ]; then
  echo ""
  echo "⚠ $ERRORS agente(s) con errores — corregi el campo 'name' y volvé a correr el script."
  exit 1
fi
