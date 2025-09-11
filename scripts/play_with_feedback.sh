#!/bin/bash

# Script para reproducir audio con retroalimentación visual
# Uso: ./play_with_feedback.sh archivo_de_audio.wav

if [ $# -eq 0 ]; then
    echo "Uso: $0 <archivo_de_audio>"
    exit 1
fi

AUDIO_FILE="$1"

if [ ! -f "$AUDIO_FILE" ]; then
    echo "Error: El archivo '$AUDIO_FILE' no existe"
    exit 1
fi

echo "🎵 REPRODUCIENDO: $(basename "$AUDIO_FILE")"
echo "▶️  Iniciando reproducción..."

# Función para mostrar indicador visual durante reproducción
show_playing_indicator() {
    local duration=$1
    local chars="⣾⣽⣻⢿⡿⣟⣯⣷"
    local char_count=${#chars}
    local sleep_time=0.1
    local iterations=$((duration * 10))
    
    for ((i=0; i<iterations; i++)); do
        local char_index=$((i % char_count))
        printf "\r🔊 REPRODUCIENDO ${chars:$char_index:1} "
        sleep $sleep_time
    done
}

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

# Reproducir audio en background y mostrar indicador
paplay "$AUDIO_FILE" &
PAPLAY_PID=$!

# Mostrar indicador visual
show_playing_indicator $DURATION &
INDICATOR_PID=$!

# Esperar a que termine la reproducción
wait $PAPLAY_PID
PLAYBACK_RESULT=$?

# Terminar el indicador visual
kill $INDICATOR_PID 2>/dev/null

if [ $PLAYBACK_RESULT -eq 0 ]; then
    echo -e "\r✅ REPRODUCCIÓN COMPLETADA                    "
else
    echo -e "\r❌ ERROR EN LA REPRODUCCIÓN                   "
fi

echo ""