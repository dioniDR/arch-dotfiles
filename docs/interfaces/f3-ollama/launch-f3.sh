#\!/bin/bash
# F3 Ollama Lab Launcher - Consolidated version

F3_URL="http://127.0.0.1:8000"
F3_DIR="$HOME/arch-dotfiles/docs/interfaces/f3-ollama"

# Verificar si Ollama está instalado
if \! command -v ollama >/dev/null; then
    echo "❌ Ollama no está instalado"
    notify-send "F3 Error" "Ollama no está instalado"
    exit 1
fi

# Verificar si el daemon está activo
if \! pgrep ollama >/dev/null; then
    echo "🚀 Iniciando Ollama daemon..."
    ollama serve &
    sleep 3
fi

# Verificar si el servidor web está activo
if \! curl -s "$F3_URL" >/dev/null 2>&1; then
    echo "🌐 Iniciando servidor web en puerto 8000..."
    cd "$F3_DIR"
    python -m http.server 8000 &
    sleep 2
fi

# Verificar conectividad
if curl -s "$F3_URL" >/dev/null 2>&1; then
    echo "✅ Conectando a $F3_URL"
    
    # Abrir en navegador
    if command -v firefox >/dev/null; then
        firefox --new-window "$F3_URL" &
    elif command -v chromium >/dev/null; then
        chromium --new-window "$F3_URL" &
    else
        xdg-open "$F3_URL" &
    fi
    
    notify-send "F3 Ollama" "Lab de IA abierto" -t 2000
else
    echo "❌ No se puede conectar a $F3_URL"
    notify-send "F3 Error" "No se puede conectar al puerto 8000"
    exit 1
fi
