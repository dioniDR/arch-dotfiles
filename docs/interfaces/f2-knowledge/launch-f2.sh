#\!/bin/bash
# F2 Knowledge Base Launcher - Consolidated version

F2_URL="http://127.0.0.1:8011"
F2_SERVICE="knowledge-base"

# Verificar si el servicio está activo
if \! systemctl --user is-active "$F2_SERVICE" >/dev/null 2>&1; then
    echo "⚠️ Servicio $F2_SERVICE no está activo"
    notify-send "F2 Warning" "Servicio knowledge-base no está activo"
    
    # Intentar iniciar el servicio
    if systemctl --user start "$F2_SERVICE" 2>/dev/null; then
        echo "✅ Servicio iniciado"
        sleep 2
    else
        echo "❌ No se pudo iniciar el servicio"
        exit 1
    fi
fi

# Verificar conectividad
if curl -s "$F2_URL" >/dev/null 2>&1; then
    echo "🌐 Conectando a $F2_URL"
    
    # Abrir en navegador
    if command -v firefox >/dev/null; then
        firefox --new-window "$F2_URL" &
    elif command -v chromium >/dev/null; then
        chromium --new-window "$F2_URL" &
    else
        xdg-open "$F2_URL" &
    fi
    
    notify-send "F2 Knowledge" "Base de conocimiento abierta" -t 2000
else
    echo "❌ No se puede conectar a $F2_URL"
    notify-send "F2 Error" "No se puede conectar al puerto 8011"
    exit 1
fi
