# 🏠 Arch Linux + Hyprland Dotfiles
*Generado automáticamente el 03/07/2025 14:08*

## 🖥️ Hardware Detectado

- **CPU**: AMD Ryzen AI 9 365 w/ Radeon 880M (20 cores)
- **RAM**: 22Gi
- **GPU**: 
- **Kernel**: Linux 6.15.4-arch2-1
- **Uptime**: 31 minutes

## 🚀 Estado del Sistema

| Componente | Estado |
|------------|--------|
| Hyprland | ✅ Activo |
| Waybar | ✅ Activo |
| Audio | ✅ PulseAudio |
| **Completitud** | **85%** |

## 📊 Estadísticas Dinámicas

- **Paquetes oficiales**: 113
- **Paquetes AUR**: 8
- **Extensiones VS Code**: 3
- **Configuraciones**: 27 directorios en ~/.config
- **Tamaño total**: 1.6M

## 🔧 Stack Tecnológico

### Core System
- **OS**: Arch Linux
- **WM**: Hyprland (Wayland)
- **Bar**: Waybar con módulos de rendimiento
- **Launcher**: Wofi (blur + transparencias)
- **Notifications**: Mako
- **Audio**: PulseAudio

### Development Tools
- **Terminal**: Kitty + Warp Terminal
- **Editor**: VS Code con extensiones
- **AI**: Claude Code CLI
- **Git**: GitHub CLI integrado
- **Shell**: Bash optimizado

## 🚀 Instalación Rápida

```bash
git clone [tu-repo] ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh
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
# Exportar configuración actual
./scripts/export-personal.sh

# Aplicar cambios al sistema
./scripts/apply-configs.sh

# Ver estado del sistema
systemctl --user status
```

---
**Completitud: 85%** | *Sistema productivo para desarrollo diario*
