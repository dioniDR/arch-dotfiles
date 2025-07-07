#\!/bin/bash
# Instalador automático F1/F2/F3 - Consolidated version

set -e

echo "🎯 Instalando interfaces F1/F2/F3..."

# Verificar dependencias
check_dependencies() {
    echo "🔍 Verificando dependencias..."
    
    MISSING_DEPS=()
    
    # Browser
    if \! command -v firefox >/dev/null && \! command -v chromium >/dev/null; then
        MISSING_DEPS+=("firefox o chromium")
    fi
    
    # Python (para F3)
    if \! command -v python >/dev/null; then
        MISSING_DEPS+=("python")
    fi
    
    # Ollama (para F3)
    if \! command -v ollama >/dev/null; then
        MISSING_DEPS+=("ollama")
    fi
    
    # Notify-send
    if \! command -v notify-send >/dev/null; then
        MISSING_DEPS+=("libnotify")
    fi
    
    if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
        echo "❌ Dependencias faltantes: ${MISSING_DEPS[*]}"
        echo "🔧 Instalar con: yay -S ${MISSING_DEPS[*]}"
        exit 1
    fi
    
    echo "✅ Todas las dependencias están instaladas"
}

# Verificar servicios
check_services() {
    echo "🔍 Verificando servicios..."
    
    # F2 Knowledge Base
    if systemctl --user list-unit-files | grep -q knowledge-base; then
        echo "✅ Servicio knowledge-base encontrado"
    else
        echo "⚠️ Servicio knowledge-base no encontrado"
    fi
    
    # Ollama
    if systemctl --user list-unit-files | grep -q ollama; then
        echo "✅ Servicio ollama encontrado"
    else
        echo "⚠️ Servicio ollama no encontrado (puede ser normal)"
    fi
}

# Probar launchers
test_launchers() {
    echo "🧪 Probando launchers..."
    
    # F1
    if [[ -x "$HOME/arch-dotfiles/docs/interfaces/f1-help/launch-f1.sh" ]]; then
        echo "✅ F1 launcher OK"
    else
        echo "❌ F1 launcher no ejecutable"
    fi
    
    # F2
    if [[ -x "$HOME/arch-dotfiles/docs/interfaces/f2-knowledge/launch-f2.sh" ]]; then
        echo "✅ F2 launcher OK"
    else
        echo "❌ F2 launcher no ejecutable"
    fi
    
    # F3
    if [[ -x "$HOME/arch-dotfiles/docs/interfaces/f3-ollama/launch-f3.sh" ]]; then
        echo "✅ F3 launcher OK"
    else
        echo "❌ F3 launcher no ejecutable"
    fi
}

# Ejecutar verificaciones
check_dependencies
check_services
test_launchers

echo "🎉 Instalación F1/F2/F3 completada\!"
echo "📋 Usar: F1 (ayuda), F2 (knowledge), F3 (ollama)"
