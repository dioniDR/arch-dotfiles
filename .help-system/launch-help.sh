#!/bin/bash

# Script de lanzamiento del sistema de ayuda F1
# Para arch-dotfiles project

HELP_DIR="$HOME/arch-dotfiles/.help-system"
HELP_HTML="$HELP_DIR/help.html"

# Verificar que existe el sistema de ayuda
if [ ! -f "$HELP_HTML" ]; then
    notify-send "Error" "Sistema de ayuda no encontrado en $HELP_DIR" -i dialog-error
    exit 1
fi

# Detectar navegador disponible (prioridad: Firefox, Chromium, Chrome, otros)
BROWSER=""
if command -v firefox >/dev/null 2>&1; then
    BROWSER="firefox"
elif command -v chromium >/dev/null 2>&1; then
    BROWSER="chromium"
elif command -v google-chrome >/dev/null 2>&1; then
    BROWSER="google-chrome"
elif command -v brave >/dev/null 2>&1; then
    BROWSER="brave"
else
    # Usar xdg-open como fallback
    BROWSER="xdg-open"
fi

# Crear ventana de ayuda con tamaño específico
if [ "$BROWSER" = "firefox" ]; then
    firefox --new-window "file://$HELP_HTML" &
elif [ "$BROWSER" = "chromium" ] || [ "$BROWSER" = "google-chrome" ]; then
    $BROWSER --new-window --window-size=1200,800 --app="file://$HELP_HTML" &
elif [ "$BROWSER" = "brave" ]; then
    brave --new-window --window-size=1200,800 --app="file://$HELP_HTML" &
else
    # Fallback genérico
    xdg-open "file://$HELP_HTML" &
fi

# Notificación de que se abrió la ayuda
notify-send "Ayuda F1" "Sistema de ayuda abierto" -i dialog-information -t 2000

# Log del evento
echo "$(date): F1 Help System launched" >> "$HOME/arch-dotfiles/.help-system/usage.log"