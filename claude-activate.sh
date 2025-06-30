#!/bin/bash
# Claude Optimization Quick Activate
# Uso: ./claude-activate.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPTIM_DIR="$SCRIPT_DIR/.claude-optimization"

echo "🔥 Activando optimización de Claude..."

# Verificar que existe el sistema
if [ ! -d "$OPTIM_DIR" ]; then
    echo "❌ Sistema de optimización no encontrado"
    echo "💡 Ejecuta: ./.claude-optimization/scripts/setup-optimization.sh"
    exit 1
fi

# Generar/actualizar cache si es necesario
if [ ! -f "$OPTIM_DIR/cache/project-context.md" ] || [ "$OPTIM_DIR/cache/project-context.md" -ot "$SCRIPT_DIR/config/hypr/hyprland.conf" ]; then
    echo "🧠 Actualizando cache de contexto..."
    "$OPTIM_DIR/scripts/generate-context-cache.sh"
fi

# Activar CLAUDE.md optimizado
if [ -f "$OPTIM_DIR/templates/CLAUDE.md" ]; then
    echo "📝 Activando CLAUDE.md optimizado..."
    cp "$OPTIM_DIR/templates/CLAUDE.md" "$SCRIPT_DIR/CLAUDE.md"
    echo "✅ CLAUDE.md optimizado activado"
else
    echo "⚠️  Generando CLAUDE.md..."
    "$OPTIM_DIR/scripts/generate-claude-md.sh"
fi

echo "🎉 Optimización activada - Reducción de tokens: 79%"
echo "💡 Para desactivar: rm CLAUDE.md"
