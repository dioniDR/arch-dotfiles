#!/bin/bash

VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o 'yes')

if [ "$MUTED" = "yes" ]; then
    echo '{"text":"󰸈 Muted","tooltip":"Audio muted","class":"muted"}'
else
    if [ "$VOLUME" -ge 70 ]; then
        ICON="󰕾"
    elif [ "$VOLUME" -ge 30 ]; then
        ICON="󰖀"
    else
        ICON="󰕿"
    fi
    echo "{\"text\":\"$ICON $VOLUME%\",\"tooltip\":\"Volume: $VOLUME%\",\"class\":\"normal\"}"
fi
