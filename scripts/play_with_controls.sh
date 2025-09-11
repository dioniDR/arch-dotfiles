#!/bin/bash

# Advanced audio player with progress bar and stop functionality
# Uso: ./play_with_controls.sh archivo_de_audio.wav

if [ $# -eq 0 ]; then
    notify-send "Error" "No se especificó archivo de audio"
    exit 1
fi

AUDIO_FILE="$1"

if [ ! -f "$AUDIO_FILE" ]; then
    notify-send "Error" "El archivo '$AUDIO_FILE' no existe"
    exit 1
fi

FILENAME=$(basename "$AUDIO_FILE")
PID_FILE="/tmp/audio-player-${FILENAME}.pid"
PROGRESS_FILE="/tmp/audio-player-progress.txt"

# Check if already playing this file
if [ -f "$PID_FILE" ]; then
    if kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        notify-send "⏹ DETENIDO" "$FILENAME\n\nReproducción detenida por el usuario" -t 2000 -i audio-x-generic
        kill "$(cat "$PID_FILE")" 2>/dev/null
        rm -f "$PID_FILE" "$PROGRESS_FILE"
        exit 0
    else
        rm -f "$PID_FILE"
    fi
fi

# Get audio duration
if command -v ffprobe &> /dev/null; then
    DURATION=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$AUDIO_FILE" 2>/dev/null)
    DURATION_INT=${DURATION%.*}
else
    # Estimate duration from file size
    FILE_SIZE=$(stat -c%s "$AUDIO_FILE")
    DURATION_INT=$((FILE_SIZE / 88200))
fi

if [ -z "$DURATION_INT" ] || [ "$DURATION_INT" -eq 0 ]; then
    DURATION_INT=3
fi

# Create progress monitoring function
show_progress() {
    local duration=$1
    local filename="$2"
    local start_time=$(date +%s)
    
    for ((i=0; i<=duration; i++)); do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        local percentage=$((elapsed * 100 / duration))
        
        # Create progress bar
        local bar_length=15
        local filled=$((elapsed * bar_length / duration))
        local bar=""
        
        for ((j=0; j<bar_length; j++)); do
            if [ $j -lt $filled ]; then
                bar="${bar}■"
            else
                bar="${bar}□"
            fi
        done
        
        # Format time
        local min=$((elapsed / 60))
        local sec=$((elapsed % 60))
        local total_min=$((duration / 60))
        local total_sec=$((duration % 60))
        
        local time_str=$(printf "%02d:%02d / %02d:%02d" $min $sec $total_min $total_sec)
        
        # Update progress file for external monitoring
        echo "$percentage|$bar|$time_str" > "$PROGRESS_FILE"
        
        # Show notification every 3 seconds or at start
        if [ $((i % 3)) -eq 0 ] || [ $i -eq 0 ]; then
            notify-send "▶ REPRODUCIENDO" "$filename\n\n$bar $percentage%\n$time_str\n\n⏹ DETENER: Doble-clic en el mismo archivo" -t 2500 -i audio-x-generic
        fi
        
        sleep 1
        
        # Check if playback was stopped externally
        if [ ! -f "$PID_FILE" ]; then
            break
        fi
    done
}

# Start playback in background
(
    paplay "$AUDIO_FILE" &
    PAPLAY_PID=$!
    echo $PAPLAY_PID > "$PID_FILE"
    
    # Show progress in parallel
    show_progress "$DURATION_INT" "$FILENAME" &
    PROGRESS_PID=$!
    
    # Wait for playback to finish
    wait $PAPLAY_PID
    PLAYBACK_RESULT=$?
    
    # Clean up
    kill $PROGRESS_PID 2>/dev/null
    rm -f "$PID_FILE" "$PROGRESS_FILE"
    
    if [ $PLAYBACK_RESULT -eq 0 ]; then
        notify-send "✅ COMPLETADO" "$FILENAME\n\nReproducción finalizada" -t 2000 -i audio-x-generic
    else
        notify-send "❌ ERROR" "$FILENAME\n\nError durante la reproducción" -t 2000 -i dialog-error
    fi
) &

# Store main process PID
echo $! > "$PID_FILE"

notify-send "▶ INICIANDO" "$FILENAME\n\nReproduciendo con controles avanzados\n⏹ PARA DETENER: Doble-clic en el mismo archivo\n\nActualizaciones cada 3 segundos..." -t 4000 -i audio-x-generic