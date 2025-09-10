#!/bin/bash

# Waybar Recording Status Script
# Returns JSON for waybar display

FLAG_FILE="/tmp/waybar-recording.flag"

if [ -f "$FLAG_FILE" ]; then
    # Recording active
    echo '{"text": "REC", "tooltip": "🔴 Recording voice note...\n▶️ Click to stop\n📁 Right-click: Open recordings\n🎛️ Middle-click: Volume control", "class": "recording"}'
else
    # Recording inactive
    echo '{"text": "MIC", "tooltip": "🎙️ Voice recorder\n▶️ Click to start recording\n📁 Right-click: Open recordings\n🎛️ Middle-click: Volume control", "class": "idle"}'
fi