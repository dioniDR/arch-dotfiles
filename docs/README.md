# 🏠 Arch Linux + Hyprland Dotfiles
*Generado automáticamente el 20/07/2025 07:52*

## 🖥️ Hardware Detectado

- **CPU**: AMD Ryzen AI 9 365 w/ Radeon 880M (20 cores)
- **RAM**: 22Gi
- **GPU**: 
- **Kernel**: Linux 6.15.7-arch1-1
- **Uptime**: 11 minutes

## 🚀 Estado del Sistema

| Componente | Estado |
|------------|--------|
| Hyprland | ✅ Activo |
| Waybar | ✅ Activo |
| Audio | ✅ PulseAudio |
| **Completitud** | **85%** |

## 📊 Estadísticas Dinámicas

- **Paquetes oficiales**: 118
- **Paquetes AUR**: 7
- **Extensiones VS Code**: 3
- **Configuraciones**: 28 directorios en ~/.config
- **Tamaño total**: 58M

## 🔧 Stack Tecnológico

### Core System
- **OS**: Arch Linux
- **WM**: Hyprland (Wayland)
- **Bar**: Waybar con módulos de rendimiento + grabación de voz
- **Launcher**: Wofi (blur + transparencias)
- **Notifications**: Mako
- **Audio**: PipeWire + GStreamer (grabación integrada)

### Development Tools
- **Terminal**: Kitty
- **Editor**: VS Code con extensiones + mousepad
- **AI**: Claude Code CLI
- **Git**: GitHub CLI integrado
- **Shell**: ZSH optimizado con plugins
- **System Monitor**: htop, wlogout
- **Fuzzy Finder**: fzf + zoxide

## 🚀 Instalación desde Arch Linux Limpio

### Paso 1: Preparar sistema base
```bash
# Actualizar sistema
sudo pacman -Syu

# Instalar herramientas esenciales
sudo pacman -S git base-devel jq

# Instalar yay (AUR helper)
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si && cd .. && rm -rf yay
```

### Paso 2: Instalar dotfiles
```bash
# Clonar repositorio
git clone https://github.com/dioniDR/arch-dotfiles.git
cd arch-dotfiles

# Verificar estado actual del sistema
./scripts/verify-packages.sh

# Instalación completa automática (46 paquetes)
sudo pacman -S greetd greetd-tuigreet hyprland xorg-xwayland kitty waybar wofi thunar pipewire pipewire-alsa pipewire-pulse pamixer ttf-nerd-fonts-symbols-mono ttf-font-awesome brightnessctl grim slurp mako firefox hypridle hyprlock hyprpaper wl-clipboard jq playerctl polkit-gnome blueman network-manager-applet udiskie libinput-gestures xdg-desktop-portal-hyprland xdg-desktop-portal mousepad htop wlogout gnome-control-center zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting fzf zoxide

yay -S wofi-emoji

# Aplicar configuraciones
cp -r config/hypr ~/.config/
cp shell/.zshrc ~/
mkdir -p ~/.config/waybar && cp -r config/waybar/* ~/.config/waybar/

# Habilitar servicios
sudo systemctl enable greetd

# Cambiar shell a zsh
chsh -s $(which zsh)
```

### Paso 3: Verificar instalación
```bash
# Ver estado completo del sistema
./scripts/verify-packages.sh

# Debería mostrar ~100% completitud
```

## 📁 Estructura del Proyecto

```
arch-dotfiles/
├── config/
│   ├── hypr/           # Hyprland + scripts
│   ├── waybar/         # Barra con CPU/RAM/Disco
│   ├── wofi/           # Launcher moderno
│   ├── warp-terminal/  # Configuración Warp
│   └── [otros]/        # Mako, Kitty, VS Code...
├── packages/           # Listas de paquetes
├── scripts/            # Automatización
├── .help-system/       # Sistema F1
└── shell/              # Dotfiles bash
```

## ⚡ Características Avanzadas

### Sistema de Ayuda F1
- Presiona **F1** en cualquier momento
- Ayuda HTML dinámica en navegador
- Contexto específico por aplicación

### Navegación Inteligente
```bash
./nav.sh ?           # Orientación del proyecto
./nav.sh config      # Ir a configuraciones
./nav.sh scripts     # Ver scripts disponibles
```

### Micro-Prompts Claude
- Archivo `.claude-prompts.md` con comandos copy-paste
- Optimizado para desarrollo con IA
- Contexto completo del proyecto

## 🔧 Hardware Optimizado Para

✅ **AMD Ryzen AI 9 365** (20 cores)  
✅ **Radeon 880M** integrada  
✅ **23GB RAM** disponible  
✅ **Wayland nativo** (sin X11)  

## 📋 Comandos Útiles

```bash
# Verificar paquetes instalados vs requeridos
./scripts/verify-packages.sh

# Ver documentación completa de evolución
cat docs/system-evolution-complete.md

# Ver paquetes por categoría
jq '.all_packages[] | select(.category=="critical")' system/packages-complete.json

# Recargar configuración Hyprland
hyprctl reload
```

## 📊 Sistema Completo

- **48 paquetes** desde Arch base hasta sistema completo
- **9 escalones** de evolución documentados
- **3 categorías**: Críticos (11) + Funcionales (30) + Productividad (6)
- **Tiempo de setup**: ~45 minutos
- **Verificación automática** con scripts incluidos

### 🎙️ Funcionalidad de Grabación
- **Botón integrado en waybar** con controles contextuales
- **GStreamer backend** para grabación de alta calidad
- **Gestión de archivos** automática con timestamps
- **Dependencies críticas**: `gstreamer`, `gst-plugins-good`, `pavucontrol`, `thunar`

---
**Sistema completo de desarrollo Hyprland** | *48 paquetes documentados + grabación integrada*
