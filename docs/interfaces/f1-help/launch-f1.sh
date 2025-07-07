#\!/bin/bash
# F1 Help System Launcher - Consolidated version

HELP_FILE="$HOME/arch-dotfiles/docs/interfaces/f1-help/help.html"

if [[ ! -f "$HELP_FILE" ]]; then
    notify-send "F1 Error" "Help file not found: $HELP_FILE"
    exit 1
fi

# Try different browsers
if command -v firefox >/dev/null; then
    firefox --new-window "file://$HELP_FILE" &
elif command -v chromium >/dev/null; then
    chromium --new-window "file://$HELP_FILE" &
else
    xdg-open "file://$HELP_FILE" &
fi

notify-send "F1 Help" "Sistema de ayuda abierto" -t 2000
