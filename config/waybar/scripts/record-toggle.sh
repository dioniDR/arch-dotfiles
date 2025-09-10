#!/bin/bash

# Waybar Recording Toggle Script
# Backend: GStreamer + PipeWire

RECORDING_DIR="$HOME/Recordings"
PID_FILE="/tmp/waybar-recording.pid"
FLAG_FILE="/tmp/waybar-recording.flag"

# Ensure recordings directory exists
mkdir -p "$RECORDING_DIR"

if [ -f "$FLAG_FILE" ]; then
    # Stop recording
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -TERM "$PID" 2>/dev/null; then
            echo "Recording stopped (PID: $PID)"
        fi
        rm -f "$PID_FILE"
    fi
    rm -f "$FLAG_FILE"
    
    # Send notification
    notify-send "🎙️ Recording" "Voice note saved to ~/Recordings/" -t 2000
    
else
    # Start recording
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    OUTPUT_FILE="$RECORDING_DIR/nota_$TIMESTAMP.wav"
    
    # Start GStreamer recording in background
    gst-launch-1.0 pulsesrc ! audioconvert ! audioresample ! \
        audio/x-raw,format=S16LE,channels=1,rate=44100 ! \
        wavenc ! filesink location="$OUTPUT_FILE" &
    
    # Store PID and create flag
    echo $! > "$PID_FILE"
    touch "$FLAG_FILE"
    
    # Send notification
    notify-send "🔴 Recording" "Voice note started..." -t 2000
fi