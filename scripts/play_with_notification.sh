#!/bin/bash

# Script para reproducir audio con notificaciones (sin terminal)
# Uso: ./play_with_notification.sh archivo_de_audio.wav

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

# Notificación de inicio
notify-send "🎵 Reproduciendo" "$FILENAME" -t 2000

# Obtener duración del archivo usando ffprobe si está disponible
if command -v ffprobe &> /dev/null; then
    DURATION=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$AUDIO_FILE" 2>/dev/null)
    DURATION=${DURATION%.*}  # Remover decimales
else
    # Duración estimada basada en tamaño de archivo (aproximado)
    FILE_SIZE=$(stat -c%s "$AUDIO_FILE")
    # Estimación para 44100Hz, 16bit, mono: ~88200 bytes por segundo
    DURATION=$((FILE_SIZE / 88200))
fi

# Si no pudimos obtener duración, usar valor por defecto
if [ -z "$DURATION" ] || [ "$DURATION" -eq 0 ]; then
    DURATION=3
fi

# Reproducir audio en background
paplay "$AUDIO_FILE" &
PAPLAY_PID=$!

# Esperar a que termine la reproducción
wait $PAPLAY_PID
PLAYBACK_RESULT=$?

if [ $PLAYBACK_RESULT -eq 0 ]; then
    notify-send "✅ Completado" "Reproducción de $FILENAME finalizada" -t 1500
else
    notify-send "❌ Error" "Error al reproducir $FILENAME" -t 2000
fi