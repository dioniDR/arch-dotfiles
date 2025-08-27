# Dependencias Críticas para Hyprland

Este documento lista todas las dependencias necesarias para que la configuración de Hyprland funcione correctamente.

## 🔧 Sistema Base
- **hyprland** - Compositor Wayland principal
- **hyprpaper** - Gestor de wallpapers
- **hyprlock** - Screen locker ⚠️ **FALTANTE**
- **hypridle** - Gestor de inactividad ⚠️ **FALTANTE**

## 📱 Aplicaciones Principales
- **kitty** - Terminal emulator ✅
- **thunar** - File manager ✅
- **wofi** - Application launcher ✅
- **firefox** - Web browser ✅

## 🖼️ Captura de Pantalla
- **grim** - Screenshot utility ✅
- **slurp** - Region selector ✅
- **wl-copy** - Clipboard utility ✅
- **jq** - JSON processor (para ventana activa) ✅

## 🎵 Audio y Media
- **pipewire** - Audio server ✅
- **pipewire-pulse** - PulseAudio compatibility ✅ (recién instalado)
- **wireplumber** - Session manager ✅
- **pamixer** - Volume control ✅
- **playerctl** - Media player control ✅

## 💡 Hardware Control
- **brightnessctl** - Brightness control ✅

## 🎨 Interface y Notificaciones
- **waybar** - Status bar ✅
- **mako** - Notification daemon ✅

## 🌐 Conectividad
- **nm-applet** - Network manager applet ✅
- **blueman-applet** - Bluetooth applet ✅

## 📁 Sistema de Archivos
- **udiskie** - Automount utility ✅

## 🔒 Seguridad y Sesión
- **polkit-gnome** - Authentication agent ✅
- **dbus** - Message bus system ✅

## 🖱️ Gestos
- **libinput-gestures** - Touchpad gestures ✅

## 🖥️ Portales XDG
- **xdg-desktop-portal-hyprland** - Hyprland portal ✅
- **xdg-desktop-portal** - Base portal ✅

## ⚠️ PROGRAMAS FALTANTES

### Críticos
1. **hyprlock** - Screen locker
   ```bash
   sudo pacman -S hyprlock
   ```

2. **hypridle** - Idle manager  
   ```bash
   sudo pacman -S hypridle
   ```

### Scripts Personalizados
3. **F1 Help System** - Script faltante
   - Ruta: `~/arch-dotfiles/.help-system/launch-help.sh`
   - Estado: ❌ No existe

4. **Knowledge Base Service** - Servicio faltante
   - Servicio: `knowledge-base.service`
   - Estado: ❌ No configurado

## 📋 Comandos de Instalación

```bash
# Instalar programas faltantes críticos
sudo pacman -S hyprlock hypridle

# Habilitar servicios de usuario
systemctl --user enable --now pipewire-pulse.service
```

## 🔧 Configuraciones que Requieren estos Programas

### Teclas de Función
- **F2/F3**: Control de volumen → Requiere `pamixer` y `pipewire-pulse`
- **F4**: LEDs teclado → Funciona
- **F5/F6**: Brillo pantalla → Requiere `brightnessctl`

### Autostart
- **hypridle**: Gestión de inactividad
- **waybar**: Barra de estado
- **mako**: Notificaciones
- **hyprpaper**: Wallpaper

### Keybindings
- **Super+T**: Terminal → `kitty`
- **Super+E**: File manager → `thunar`
- **Super+R**: App launcher → `wofi`
- **Super+L**: Lock screen → `hyprlock`
- **Print**: Screenshots → `grim`, `slurp`, `wl-copy`

## ✅ Estado Actual
- **Funcionando**: Audio/volumen (tras instalar pipewire-pulse)
- **Funcionando**: Captura de pantalla
- **Funcionando**: Brillo y LEDs
- **Pendiente**: Screen locker y idle management
- **Pendiente**: Scripts personalizados F1 y Knowledge Base

---
*Generado automáticamente analizando la configuración de Hyprland*