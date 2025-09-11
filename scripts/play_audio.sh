#!/bin/bash

# Script simple para reproducir cualquier archivo de audio en el directorio
# Uso: ./play_audio.sh [nombre_archivo]

RECORDINGS_DIR="/home/dioni/Recordings"

if [ $# -eq 0 ]; then
    echo "Archivos de audio disponibles:"
    ls -1 "$RECORDINGS_DIR"/*.{wav,mp3,ogg,flac,m4a} 2>/dev/null | xargs -n1 basename
    echo ""
    echo "Uso: $0 <nombre_archivo>"
    echo "Ejemplo: $0 nota_20250911_141031.wav"
    exit 1
fi

AUDIO_FILE="$1"

# Si no es ruta absoluta, buscar en el directorio de grabaciones
if [[ "$AUDIO_FILE" != /* ]]; then
    AUDIO_FILE="$RECORDINGS_DIR/$AUDIO_FILE"
fi

if [ ! -f "$AUDIO_FILE" ]; then
    echo "Error: El archivo '$AUDIO_FILE' no existe"
    echo "Archivos disponibles en $RECORDINGS_DIR:"
    ls -1 "$RECORDINGS_DIR"/*.{wav,mp3,ogg,flac,m4a} 2>/dev/null | xargs -n1 basename
    exit 1
fi

# Usar el script de reproducción con feedback
exec "$RECORDINGS_DIR/play_with_feedback.sh" "$AUDIO_FILE"