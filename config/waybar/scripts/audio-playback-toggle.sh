#!/bin/bash

# Waybar Audio Playback Control Script
# Stops all active audio playback or opens recordings folder

RECORDINGS_DIR="$HOME/Recordings"

# Find and stop all active playback
stopped_count=0
stopped_files=""

for pid_file in /tmp/audio-player-*.pid; do
    if [ -f "$pid_file" ]; then
        filename=$(basename "$pid_file" .pid | sed 's/audio-player-//')
        pid=$(cat "$pid_file" 2>/dev/null)
        
        if kill -0 "$pid" 2>/dev/null; then
            if kill "$pid" 2>/dev/null; then
                if [ -z "$stopped_files" ]; then
                    stopped_files="$filename"
                else
                    stopped_files="$stopped_files, $filename"
                fi
                stopped_count=$((stopped_count + 1))
            fi
            rm -f "$pid_file" "/tmp/audio-player-progress.txt" 2>/dev/null
        else
            # Clean up stale files
            rm -f "$pid_file" 2>/dev/null
        fi
    fi
done

if [ $stopped_count -gt 0 ]; then
    if [ $stopped_count -eq 1 ]; then
        notify-send "⏹ AUDIO DETENIDO" "$stopped_files\n\nReproducción detenida desde waybar" -t 2000 -i audio-x-generic
    else
        notify-send "⏹ AUDIO DETENIDO" "$stopped_count archivos detenidos:\n$stopped_files" -t 2000 -i audio-x-generic
    fi
else
    # No playback active, just show a message
    notify-send "🎵 Reproductor Audio" "No hay reproducción activa\n\n💡 Haz doble-clic en archivos .wav para reproducir" -t 2000 -i audio-x-generic
fi