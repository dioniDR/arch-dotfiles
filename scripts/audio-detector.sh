#!/bin/bash
# =============================================================================
# DETECTOR DE AUDIO ACTIVO PARA WAYBAR
# Detecta streams de audio y cambia iconos/estados dinámicamente
# Optimizado para AMD Ryzen AI 9 365 + PulseAudio/PipeWire
# =============================================================================

# Verificar si hay streams de audio activos
ACTIVE_STREAMS=$(pactl list short sink-inputs 2>/dev/null | wc -l)
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -Po '\d+(?=%)' | head -1)
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -o "yes")

# Si no se puede obtener volumen, usar valor por defecto
if [[ -z "$VOLUME" ]]; then
    VOLUME="50"
fi

# Determinar dispositivo de salida actual
OUTPUT_DEVICE=$(pactl info 2>/dev/null | grep "Default Sink" | cut -d: -f2 | xargs)
DEVICE_DESC=""

if [[ -n "$OUTPUT_DEVICE" ]]; then
    DEVICE_DESC=$(pactl list sinks 2>/dev/null | grep -A 10 "Name: $OUTPUT_DEVICE" | grep "Description:" | cut -d: -f2 | xargs)
fi

# Detectar tipo de dispositivo para iconos específicos
if echo "$DEVICE_DESC" | grep -qi "headphone\|headset"; then
    DEVICE_ICON=""
elif echo "$DEVICE_DESC" | grep -qi "bluetooth"; then
    DEVICE_ICON=""
elif echo "$DEVICE_DESC" | grep -qi "hdmi\|display"; then
    DEVICE_ICON=""
else
    DEVICE_ICON=""
fi

# Lógica de estados
if [[ $ACTIVE_STREAMS -gt 0 ]]; then
    # Hay audio reproduciéndose
    if [[ -n $MUTED ]]; then
        # Audio activo pero silenciado
        echo "{\"text\": \" $DEVICE_ICON $VOLUME%\", \"class\": \"muted-active\", \"tooltip\": \"🔇 Audio muted - $ACTIVE_STREAMS stream(s) active\\nDevice: ${DEVICE_DESC:-Unknown}\"}"
    else
        # Audio reproduciéndose normalmente
        if [[ $VOLUME -lt 30 ]]; then
            VOLUME_ICON=""
        elif [[ $VOLUME -lt 70 ]]; then
            VOLUME_ICON=""
        else
            VOLUME_ICON=""
        fi
        echo "{\"text\": \"$VOLUME_ICON $DEVICE_ICON $VOLUME%\", \"class\": \"playing\", \"tooltip\": \"🎵 Audio playing - $ACTIVE_STREAMS stream(s)\\nVolume: $VOLUME%\\nDevice: ${DEVICE_DESC:-Unknown}\"}"
    fi
else
    # No hay audio activo
    if [[ -n $MUTED ]]; then
        # Silenciado y sin reproducir
        echo "{\"text\": \" $DEVICE_ICON $VOLUME%\", \"class\": \"muted\", \"tooltip\": \"🔇 Audio muted\\nDevice: ${DEVICE_DESC:-Unknown}\"}"
    else
        # Listo para reproducir
        if [[ $VOLUME -lt 30 ]]; then
            VOLUME_ICON=""
        elif [[ $VOLUME -lt 70 ]]; then
            VOLUME_ICON=""
        else
            VOLUME_ICON=""
        fi
        echo "{\"text\": \"$VOLUME_ICON $DEVICE_ICON $VOLUME%\", \"class\": \"idle\", \"tooltip\": \"🔊 Audio ready\\nVolume: $VOLUME%\\nDevice: ${DEVICE_DESC:-Unknown}\"}"
    fi
fi