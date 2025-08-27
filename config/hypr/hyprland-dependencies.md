# Hyprland - Dependencias y Configuración

## Paquetes Base Instalados ✅

### Core Hyprland
- **hyprland** `0.50.1-1` - Compositor principal
- **hypridle** `0.1.6-6` - Daemon de inactividad  
- **waybar** `0.14.0-1` - Barra de estado
- **mako** `1.10.0-1` - Sistema de notificaciones

### Herramientas de Sistema
- **grim** `1.5.0-2` - Capturas de pantalla
- **slurp** `1.5.0-1` - Selector de área de pantalla
- **wl-clipboard** `2.2.1-3` - Portapapeles Wayland
- **jq** `1.8.1-1` - Procesador JSON (para screenshots)
- **brightnessctl** `0.5.1-3` - Control de brillo
- **playerctl** `2.4.1-4` - Control multimedia

### Aplicaciones
- **kitty** `0.42.2-1` - Terminal
- **thunar** `4.20.4-1` - Gestor de archivos
- **wofi** `1.5.1-1` - Lanzador de aplicaciones
- **firefox** `141.0.3-1` - Navegador
- **mousepad** - Editor de texto ligero
- **htop** `3.4.1-1` - Monitor del sistema
- **wlogout** - Menú de logout/apagado
- **gnome-control-center** - Centro de control del sistema
- **wofi-emoji** - Selector de emojis

### Servicios
- **network-manager-applet** `1.36.0-1` - Applet de red
- **udiskie** `2.5.7-1` - Montaje automático USB
- **libinput-gestures** `2.80-1` - Gestos touchpad
- **xdg-desktop-portal-hyprland** `1.3.10-1` - Portal Hyprland
- **xdg-desktop-portal** `1.20.3-1` - Portal base

## Dependencias Adicionales ✅

### Audio y Sistema
- **pamixer** - Control de audio PulseAudio ✅
- **polkit-gnome** - Autenticación gráfica ✅
- **blueman** - Gestor Bluetooth ✅
- **hyprlock** - Bloqueador de pantalla ✅
- **hyprpaper** - Gestor de wallpapers ✅

### Comandos de Instalación (Si falta alguno)

```bash
# Instalar herramientas adicionales
sudo pacman -S mousepad htop wlogout gnome-control-center
yay -S wofi-emoji

# Instalar dependencias base si faltan
sudo pacman -S pamixer polkit-gnome blueman hyprlock hyprpaper
```

## Archivos de Configuración

### Configuraciones Principales
- `~/.config/hypr/hyprland.conf` - Configuración principal
- `~/.config/hypr/hypridle.conf` - Configuración de inactividad
- `~/.config/hypr/hyprlock.conf` - Configuración de bloqueo
- `~/.config/hypr/hyprpaper.conf` - Configuración de wallpapers

### Scripts Personalizados
- `~/arch-dotfiles/.help-system/launch-help.sh` - Sistema de ayuda (F1)
- `~/arch-dotfiles/docs/interfaces/f3-ollama/launch-f3.sh` - Ollama lab (F3)

## Keybindings que Requieren Dependencias

### Audio (Requiere pamixer)
- `XF86AudioRaiseVolume` → `pamixer -i 5`
- `XF86AudioLowerVolume` → `pamixer -d 5`
- `XF86AudioMute` → `pamixer -t`

### Multimedia (Requiere playerctl)
- `XF86AudioPlay/Pause` → `playerctl play-pause`
- `XF86AudioNext/Prev` → `playerctl next/previous`

### Screenshots (Requiere grim + slurp + jq)
- `Print` → Captura completa
- `Shift+Print` → Captura de área
- `Alt+Print` → Captura de ventana activa
- `Ctrl+*` → Variantes al portapapeles

### Bloqueo (Requiere hyprlock)
- `Super+L` → `hyprlock`

### Brillo (Requiere brightnessctl)
- `XF86BrightnessUp/Down` → `brightnessctl set 10%±`

### Nuevos Keybinds Sistema/Windows
- `Alt+Tab` → Cambio de ventanas
- `Ctrl+Shift+Esc` → `htop` (Task manager)
- `Ctrl+Alt+Del` → `wlogout` (Menú logout)
- `Super+D` → Mostrar escritorio
- `Super+I` → `gnome-control-center`
- `Super+.` → `wofi-emoji`
- `Super+Shift+N` → `mousepad` (Editor flotante)
- `Super+Shift+arrows` → Mover ventanas

## Servicios Auto-iniciados

### Servicios del Sistema
- `dbus-update-activation-environment` ✅
- `systemctl --user import-environment` ✅
- `/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1` ✅
- `/usr/lib/xdg-desktop-portal-hyprland` ✅
- `/usr/lib/xdg-desktop-portal` ✅

### Aplicaciones
- `hypridle` ✅ - Daemon de inactividad
- `waybar` ✅ - Barra de estado
- `mako` ✅ - Notificaciones
- `nm-applet --indicator` ✅ - Red
- `blueman-applet` ✅ - Bluetooth
- `udiskie --tray --no-notify` ✅ - USB automount
- `libinput-gestures-setup start` ✅ - Gestos
- `hyprpaper` ✅ - Wallpapers
- `/home/dioni/.local/bin/dwall-hypr firewatch` ✅ - Dynamic wallpapers

### Servicios Personalizados
- `systemctl --user start knowledge-base.service` - Sistema de conocimiento

## Estado Actual

**✅ Completamente Funcionando:** 
- Hyprland compositor y configuración base
- Control de audio (pamixer) 
- Autenticación gráfica (polkit-gnome)
- Bluetooth (blueman)
- Bloqueo de pantalla (hyprlock)
- Wallpapers dinámicos (hyprpaper + dwall-hypr)
- Sistema completo de screenshots
- Keybinds estilo Linux/Windows
- Task manager y control del sistema
- Navegación, terminal, gestor archivos, gestos

## Instalación Completa Recomendada

```bash
# 1. Instalar paquetes base
sudo pacman -S hyprland hypridle waybar mako grim slurp wl-clipboard jq \
               kitty thunar wofi firefox brightnessctl playerctl \
               network-manager-applet udiskie libinput-gestures \
               xdg-desktop-portal-hyprland xdg-desktop-portal

# 2. Instalar dependencias adicionales
sudo pacman -S pamixer polkit-gnome blueman hyprlock hyprpaper \
               mousepad htop wlogout gnome-control-center
yay -S wofi-emoji

# 3. Configurar gestos
sudo usermod -a -G input $USER
libinput-gestures-setup autostart
libinput-gestures-setup start

# 4. Crear directorio para wallpapers
mkdir -p ~/Pictures/Wallpapers

# 5. Configurar servicios de usuario si es necesario
systemctl --user enable knowledge-base.service
```