#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Seleccionar wallpaper aleatorio
WALLPAPER=$(find "$WALLPAPER_DIR" -name "*.jpg" -o -name "*.png" | shuf -n 1)

if [ -f "$WALLPAPER" ]; then
    # Actualizar hyprpaper config
    echo "preload = $WALLPAPER" > ~/.config/hypr/hyprpaper.conf
    echo "wallpaper = ,$WALLPAPER" >> ~/.config/hypr/hyprpaper.conf
    echo "splash = false" >> ~/.config/hypr/hyprpaper.conf
    echo "ipc = on" >> ~/.config/hypr/hyprpaper.conf
    
    # Reiniciar hyprpaper
    pkill hyprpaper
    hyprpaper &
    
    echo "🎨 Wallpaper cambiado a: $(basename "$WALLPAPER")"
    
    # Mostrar notificación
    if command -v notify-send &> /dev/null; then
        notify-send "Wallpaper" "Cambiado a: $(basename "$WALLPAPER")" -i preferences-desktop-wallpaper
    fi
else
    echo "❌ No se encontraron wallpapers"
fi
