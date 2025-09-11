#!/bin/bash

# Waybar Recording Toggle Script
# Backend: GStreamer + PipeWire

RECORDING_DIR="$HOME/Recordings"
PID_FILE="/tmp/waybar-recording.pid"
FLAG_FILE="/tmp/waybar-recording.flag"
STOPPING_FILE="/tmp/waybar-recording.stopping"

# Ensure recordings directory exists
mkdir -p "$RECORDING_DIR"

if [ -f "$FLAG_FILE" ]; then
    # Stop recording
    touch "$STOPPING_FILE"  # Set stopping state
    
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -TERM "$PID" 2>/dev/null; then
            echo "Recording stopped (PID: $PID)"
        fi
        rm -f "$PID_FILE"
    fi
    
    # Mute microphone when not recording
    pactl set-source-mute alsa_input.pci-0000_63_00.6.analog-stereo 1
    
    rm -f "$FLAG_FILE"
    
    # Brief delay for visual feedback
    sleep 0.5
    rm -f "$STOPPING_FILE"
    
    # Send notification
    notify-send "🎙️ Recording" "Voice note saved to ~/Recordings/" -t 2000
    
else
    # Start recording
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    OUTPUT_FILE="$RECORDING_DIR/nota_$TIMESTAMP.wav"
    
    # Unmute microphone for recording
    pactl set-source-mute alsa_input.pci-0000_63_00.6.analog-stereo 0
    
    # Start GStreamer recording in background using specific device
    gst-launch-1.0 pulsesrc device="alsa_input.pci-0000_63_00.6.analog-stereo" ! audioconvert ! audioresample ! \
        audio/x-raw,format=S16LE,channels=1,rate=44100 ! \
        wavenc ! filesink location="$OUTPUT_FILE" &
    
    # Store PID and create flag
    echo $! > "$PID_FILE"
    touch "$FLAG_FILE"
    
    # Send notification
    notify-send "🔴 Recording" "Voice note started..." -t 2000
fi