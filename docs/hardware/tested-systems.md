# 🖥️ Sistemas Donde Se Ha Probado

## Sistema Principal de Desarrollo

### Especificaciones
- **Modelo**: ASUS VivoBook
- **CPU**: $(lscpu  < /dev/null |  grep "Model name" | cut -d: -f2 | xargs)
- **RAM**: $(free -h | grep Mem | awk '{print $2}')
- **GPU**: $(lspci | grep VGA | cut -d: -f3 | xargs)
- **Almacenamiento**: $(df -h / | tail -1 | awk '{print $2}') SSD
- **Pantalla**: $(xrandr 2>/dev/null | grep " connected" | head -1 | awk '{print $3}' || echo "N/A")

### Software Base
- **Kernel**: $(uname -r)
- **Desktop**: Hyprland + GNOME (dual)
- **Display Server**: Wayland
- **Audio**: PipeWire

### Funcionalidades Probadas
- ✅ Hyprland + Waybar
- ✅ GNOME completo
- ✅ Audio PipeWire
- ✅ Bluetooth
- ✅ WiFi
- ✅ Brightness controls
- ✅ Touchpad gestures
- ✅ Sleep/suspend
- ✅ Multi-monitor (cuando disponible)

### Configuraciones Específicas de Hardware
- Brightness: brightnessctl
- Audio: pamixer + PipeWire
- Network: NetworkManager
- Bluetooth: bluez + blueman
- Input: libinput-gestures

