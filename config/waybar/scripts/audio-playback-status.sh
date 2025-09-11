#!/bin/bash

# Waybar Audio Playback Status Script
# Returns JSON for waybar display

# Check for any active audio playback
playing_files=""
total_playing=0

for pid_file in /tmp/audio-player-*.pid; do
    if [ -f "$pid_file" ]; then
        filename=$(basename "$pid_file" .pid | sed 's/audio-player-//')
        pid=$(cat "$pid_file" 2>/dev/null)
        
        if kill -0 "$pid" 2>/dev/null; then
            if [ -z "$playing_files" ]; then
                playing_files="$filename"
            else
                playing_files="$playing_files, $filename"
            fi
            total_playing=$((total_playing + 1))
        else
            # Clean up stale PID files
            rm -f "$pid_file" 2>/dev/null
        fi
    fi
done

if [ $total_playing -gt 0 ]; then
    if [ $total_playing -eq 1 ]; then
        echo "{\"text\": \"⏸\", \"tooltip\": \"🎵 Reproduciendo: $playing_files\\n⏹ Click: Detener reproducción\\n📁 Right-click: Abrir grabaciones\", \"class\": \"playing\"}"
    else
        echo "{\"text\": \"⏸\", \"tooltip\": \"🎵 Reproduciendo $total_playing archivos\\n⏹ Click: Detener todos\\n📁 Right-click: Abrir grabaciones\", \"class\": \"playing\"}"
    fi
else
    echo "{\"text\": \"🎵\", \"tooltip\": \"🎵 Reproductor de audio\\n▶️ Sin reproducción activa\\n📁 Right-click: Abrir grabaciones\", \"class\": \"idle\"}"
fi