#!/bin/bash

# Script para monitorear y mostrar el estado de reproducción de audio
# Uso: ./audio-status-monitor.sh

RECORDINGS_DIR="$HOME/Recordings"

echo "🎵 Estado de reproducción de audio:"
echo "=================================="

# Buscar archivos de PID activos
found_playing=false

for pid_file in /tmp/audio-player-*.pid; do
    if [ -f "$pid_file" ]; then
        filename=$(basename "$pid_file" .pid | sed 's/audio-player-//')
        pid=$(cat "$pid_file" 2>/dev/null)
        
        if kill -0 "$pid" 2>/dev/null; then
            echo "▶ REPRODUCIENDO: $filename"
            
            # Mostrar progreso si está disponible
            progress_file="/tmp/audio-player-progress.txt"
            if [ -f "$progress_file" ]; then
                progress_info=$(cat "$progress_file")
                percentage=$(echo "$progress_info" | cut -d'|' -f1)
                bar=$(echo "$progress_info" | cut -d'|' -f2)
                time_str=$(echo "$progress_info" | cut -d'|' -f3)
                
                echo "   Progreso: $bar $percentage%"
                echo "   Tiempo: $time_str"
            fi
            
            echo "   ⏹ Para detener: Doble-clic en $filename"
            echo ""
            found_playing=true
        else
            # Limpiar archivo PID obsoleto
            rm -f "$pid_file" 2>/dev/null
        fi
    fi
done

if ! $found_playing; then
    echo "⏸ No hay audio reproduciéndose actualmente"
    echo ""
    echo "📁 Archivos disponibles en $RECORDINGS_DIR:"
    ls -1 "$RECORDINGS_DIR"/*.wav 2>/dev/null | xargs -n1 basename || echo "   (Sin archivos de audio)"
fi

echo ""
echo "💡 Uso:"
echo "   • Doble-clic en archivo .wav = Reproducir"
echo "   • Doble-clic en archivo reproduciéndose = Detener"