#!/bin/bash

# Waybar Recording Status Script
# Returns JSON for waybar display

FLAG_FILE="/tmp/waybar-recording.flag"
STOPPING_FILE="/tmp/waybar-recording.stopping"

if [ -f "$STOPPING_FILE" ]; then
    # Stopping recording (intermediate state)
    echo '{"text": "STOP", "tooltip": "⏹️ Stopping recording...\n💾 Saving voice note", "class": "stopping"}'
elif [ -f "$FLAG_FILE" ]; then
    # Recording active
    echo '{"text": "REC", "tooltip": "🔴 Recording voice note...\n▶️ Click to stop\n📁 Right-click: Open recordings\n🎛️ Middle-click: Volume control", "class": "recording"}'
else
    # Recording inactive
    echo '{"text": "MIC", "tooltip": "🎙️ Voice recorder (mic muted when idle)\n▶️ Click to start recording\n📁 Right-click: Open recordings\n🎛️ Middle-click: Volume control", "class": "idle"}'
fi