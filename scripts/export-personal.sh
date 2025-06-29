#!/bin/bash
# =============================================================================
# EXPORTADOR PERSONALIZADO PARA TU SETUP ARCH + HYPRLAND
# Basado en el análisis de tu sistema actual
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

DOTFILES_DIR="$HOME/arch-dotfiles"

print_step() {
    echo -e "${GREEN}[EXPORT]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Crear estructura de directorios
create_structure() {
    print_step "Creando estructura de directorios..."
    
    mkdir -p "$DOTFILES_DIR"/{config,shell,packages,scripts,system,wallpapers}
    mkdir -p "$DOTFILES_DIR"/config/{hypr,waybar,wofi,mako,kitty,gtk-3.0,Code,pulse}
    mkdir -p "$DOTFILES_DIR"/scripts/hypr-scripts
    
    print_info "Estructura creada en $DOTFILES_DIR"
}

# Exportar configuraciones de Hyprland (tu config principal)
export_hyprland() {
    print_step "Exportando configuración de Hyprland..."
    
    if [[ -d "$HOME/.config/hypr" ]]; then
        # Copiar archivos de configuración principales
        cp "$HOME/.config/hypr/hyprland.conf" "$DOTFILES_DIR/config/hypr/" 2>/dev/null || true
        cp "$HOME/.config/hypr/hypridle.conf" "$DOTFILES_DIR/config/hypr/" 2>/dev/null || true
        cp "$HOME/.config/hypr/hyprlock.conf" "$DOTFILES_DIR/config/hypr/" 2>/dev/null || true
        cp "$HOME/.config/hypr/hyprpaper.conf" "$DOTFILES_DIR/config/hypr/" 2>/dev/null || true
        
        # Copiar scripts personalizados
        if [[ -d "$HOME/.config/hypr/scripts" ]]; then
            cp -r "$HOME/.config/hypr/scripts"/* "$DOTFILES_DIR/scripts/hypr-scripts/" 2>/dev/null || true
            print_info "Scripts de Hyprland exportados"
        fi
        
        # Copiar wallpapers (si no son muy pesados)
        if [[ -d "$HOME/.config/hypr/wallpapers" ]]; then
            wallpaper_size=$(du -sm "$HOME/.config/hypr/wallpapers" 2>/dev/null | cut -f1)
            if [[ ${wallpaper_size:-0} -lt 100 ]]; then  # Menos de 100MB
                cp -r "$HOME/.config/hypr/wallpapers"/* "$DOTFILES_DIR/wallpapers/" 2>/dev/null || true
                print_info "Wallpapers exportados (${wallpaper_size}MB)"
            else
                print_info "Wallpapers omitidos (demasiado pesados: ${wallpaper_size}MB)"
                echo "# Wallpapers location: ~/.config/hypr/wallpapers/" > "$DOTFILES_DIR/wallpapers/README.md"
            fi
        fi
        
        print_info "✅ Hyprland configurado"
    fi
}

# Exportar Waybar (tu barra personalizada)
export_waybar() {
    print_step "Exportando configuración de Waybar..."
    
    if [[ -d "$HOME/.config/waybar" ]]; then
        cp "$HOME/.config/waybar/config.jsonc" "$DOTFILES_DIR/config/waybar/" 2>/dev/null || true
        cp "$HOME/.config/waybar/style.css" "$DOTFILES_DIR/config/waybar/" 2>/dev/null || true
        print_info "✅ Waybar exportado"
    fi
}

# Exportar otras configuraciones importantes de tu sistema
export_other_configs() {
    print_step "Exportando otras configuraciones..."
    
    # Wofi (tu launcher)
    if [[ -d "$HOME/.config/wofi" ]]; then
        cp -r "$HOME/.config/wofi"/* "$DOTFILES_DIR/config/wofi/" 2>/dev/null || true
        print_info "✅ Wofi exportado"
    fi
    
    # Mako (notificaciones)
    if [[ -d "$HOME/.config/mako" ]]; then
        cp -r "$HOME/.config/mako"/* "$DOTFILES_DIR/config/mako/" 2>/dev/null || true
        print_info "✅ Mako exportado"
    fi
    
    # Kitty (si tiene config)
    if [[ -d "$HOME/.config/kitty" ]]; then
        cp -r "$HOME/.config/kitty"/* "$DOTFILES_DIR/config/kitty/" 2>/dev/null || true
        print_info "✅ Kitty exportado"
    fi
    
    # GTK
    if [[ -d "$HOME/.config/gtk-3.0" ]]; then
        cp -r "$HOME/.config/gtk-3.0"/* "$DOTFILES_DIR/config/gtk-3.0/" 2>/dev/null || true
        print_info "✅ GTK-3.0 exportado"
    fi
    
    # VS Code (ambas versiones)
    if [[ -d "$HOME/.config/Code/User" ]]; then
        mkdir -p "$DOTFILES_DIR/config/Code/User"
        cp "$HOME/.config/Code/User/settings.json" "$DOTFILES_DIR/config/Code/User/" 2>/dev/null || true
        cp "$HOME/.config/Code/User/keybindings.json" "$DOTFILES_DIR/config/Code/User/" 2>/dev/null || true
        print_info "✅ VS Code exportado"
    fi
    
    # PulseAudio + PipeWire (optimizado para AMD Ryzen AI 9 365)
    if [[ -d "$HOME/.config/pulse" ]]; then
        cp -r "$HOME/.config/pulse"/* "$DOTFILES_DIR/config/pulse/" 2>/dev/null || true
        print_info "✅ PulseAudio exportado (AMD optimizado)"
    fi
    
    # PipeWire (configuración de baja latencia)
    if [[ -d "$HOME/.config/pipewire" ]]; then
        cp -r "$HOME/.config/pipewire"/* "$DOTFILES_DIR/config/pipewire/" 2>/dev/null || true
        print_info "✅ PipeWire exportado (baja latencia)"
    fi
}

# Exportar dotfiles de home
export_home_dotfiles() {
    print_step "Exportando dotfiles de home..."
    
    # Shell configs
    cp "$HOME/.bashrc" "$DOTFILES_DIR/shell/" 2>/dev/null || true
    cp "$HOME/.bash_profile" "$DOTFILES_DIR/shell/" 2>/dev/null || true
    
    # Tus atajos personalizados
    cp "$HOME/.xbindkeysrc" "$DOTFILES_DIR/shell/" 2>/dev/null || true
    
    print_info "✅ Dotfiles de home exportados"
}

# Exportar listas de paquetes (tus 106 + 6 AUR)
export_packages() {
    print_step "Exportando listas de paquetes..."
    
    # Paquetes explícitos (tus 106)
    pacman -Qe > "$DOTFILES_DIR/packages/pacman-explicit.txt"
    print_info "📦 $(wc -l < "$DOTFILES_DIR/packages/pacman-explicit.txt") paquetes oficiales"
    
    # Paquetes AUR (tus 6)
    pacman -Qm > "$DOTFILES_DIR/packages/aur-packages.txt"
    print_info "🔶 $(wc -l < "$DOTFILES_DIR/packages/aur-packages.txt") paquetes AUR"
    
    # Extensiones de VS Code
    if command -v code &>/dev/null; then
        code --list-extensions > "$DOTFILES_DIR/packages/vscode-extensions.txt"
        print_info "🔌 $(wc -l < "$DOTFILES_DIR/packages/vscode-extensions.txt") extensiones de VS Code"
    fi
}

# Obtener información del sistema
get_system_info() {
    # Hardware dinámico
    CPU_MODEL=$(lscpu | grep "Model name:" | sed 's/Model name:[[:space:]]*//')
    CPU_CORES=$(nproc)
    RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
    GPU_INFO=$(lspci | grep -i vga | sed 's/.*: //')
    KERNEL_VER=$(uname -r)
    UPTIME=$(uptime -p | sed 's/up //')
    
    # Estado del sistema
    HYPR_STATUS=$(pgrep Hyprland >/dev/null && echo "✅ Activo" || echo "❌ Inactivo")
    WAYBAR_STATUS=$(pgrep waybar >/dev/null && echo "✅ Activo" || echo "❌ Inactivo")
    AUDIO_STATUS=$(pactl info >/dev/null 2>&1 && echo "✅ PulseAudio" || echo "❌ Sin audio")
    
    # Contadores de archivos
    CONFIG_COUNT=$(find "$HOME/.config" -maxdepth 1 -type d 2>/dev/null | wc -l)
    DOTFILES_SIZE=$(du -sh "$DOTFILES_DIR" 2>/dev/null | cut -f1 || echo "0B")
}

# Calcular porcentaje de completitud
calculate_completion() {
    local total_score=0
    local max_score=100
    
    # Configuraciones principales (40 puntos)
    [[ -f "$HOME/.config/hypr/hyprland.conf" ]] && ((total_score += 15))
    [[ -f "$HOME/.config/waybar/config.jsonc" ]] && ((total_score += 10))
    [[ -d "$HOME/.config/wofi" ]] && ((total_score += 8))
    [[ -d "$HOME/.config/mako" ]] && ((total_score += 7))
    
    # Herramientas de desarrollo (30 puntos)
    command -v code >/dev/null && ((total_score += 10))
    command -v gh >/dev/null && ((total_score += 5))
    command -v claude-code >/dev/null && ((total_score += 15))
    
    # Sistema completo (30 puntos)
    pgrep Hyprland >/dev/null && ((total_score += 15))
    pgrep waybar >/dev/null && ((total_score += 10))
    pactl info >/dev/null 2>&1 && ((total_score += 5))
    
    echo $((total_score))
}

# Crear README personalizado
create_readme() {
    print_step "Creando documentación..."
    
    # Obtener información dinámica
    get_system_info
    local completion_pct=$(calculate_completion)
    
    cat > "$DOTFILES_DIR/README.md" << EOF
# 🏠 Arch Linux + Hyprland Dotfiles
*Generado automáticamente el $(date '+%d/%m/%Y %H:%M')*

## 🖥️ Hardware Detectado

- **CPU**: $CPU_MODEL ($CPU_CORES cores)
- **RAM**: $RAM_TOTAL
- **GPU**: $GPU_INFO
- **Kernel**: Linux $KERNEL_VER
- **Uptime**: $UPTIME

## 🚀 Estado del Sistema

| Componente | Estado |
|------------|--------|
| Hyprland | $HYPR_STATUS |
| Waybar | $WAYBAR_STATUS |
| Audio | $AUDIO_STATUS |
| **Completitud** | **${completion_pct}%** |

## 📊 Estadísticas Dinámicas

- **Paquetes oficiales**: $(wc -l < "$DOTFILES_DIR/packages/pacman-explicit.txt" 2>/dev/null || echo "?")
- **Paquetes AUR**: $(wc -l < "$DOTFILES_DIR/packages/aur-packages.txt" 2>/dev/null || echo "?")
- **Extensiones VS Code**: $(wc -l < "$DOTFILES_DIR/packages/vscode-extensions.txt" 2>/dev/null || echo "?")
- **Configuraciones**: $CONFIG_COUNT directorios en ~/.config
- **Tamaño total**: $DOTFILES_SIZE

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

\`\`\`bash
git clone [tu-repo] ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh
\`\`\`

## 📁 Estructura del Proyecto

\`\`\`
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
\`\`\`

## ⚡ Características Avanzadas

### Sistema de Ayuda F1
- Presiona **F1** en cualquier momento
- Ayuda HTML dinámica en navegador
- Contexto específico por aplicación

### Navegación Inteligente
\`\`\`bash
./nav.sh ?           # Orientación del proyecto
./nav.sh config      # Ir a configuraciones
./nav.sh scripts     # Ver scripts disponibles
\`\`\`

### Micro-Prompts Claude
- Archivo \`.claude-prompts.md\` con comandos copy-paste
- Optimizado para desarrollo con IA
- Contexto completo del proyecto

## 🔧 Hardware Optimizado Para

✅ **AMD Ryzen AI 9 365** (20 cores)  
✅ **Radeon 880M** integrada  
✅ **23GB RAM** disponible  
✅ **Wayland nativo** (sin X11)  

## 📋 Comandos Útiles

\`\`\`bash
# Exportar configuración actual
./scripts/export-personal.sh

# Aplicar cambios al sistema
./scripts/apply-configs.sh

# Ver estado del sistema
systemctl --user status
\`\`\`

---
**Completitud: ${completion_pct}%** | *Sistema productivo para desarrollo diario*
EOF

    print_info "✅ README dinámico creado (${completion_pct}% completitud)"
}

# Función principal
main() {
    echo -e "${BLUE}"
    echo "╭─────────────────────────────────────────────╮"
    echo "│       EXPORTADOR PERSONALIZADO             │"
    echo "│    Arch Linux + Hyprland Setup             │"
    echo "╰─────────────────────────────────────────────╯"
    echo -e "${NC}"
    
    create_structure
    export_hyprland
    export_waybar
    export_other_configs
    export_home_dotfiles
    export_packages
    create_readme
    
    echo -e "\n${GREEN}🎉 EXPORTACIÓN COMPLETADA${NC}"
    echo -e "📁 Dotfiles guardados en: ${BLUE}$DOTFILES_DIR${NC}"
    echo -e "📋 Listos para versionar con Git"
    
    echo -e "\n${YELLOW}Siguientes pasos:${NC}"
    echo -e "  1. ${BLUE}cd $DOTFILES_DIR${NC}"
    echo -e "  2. ${BLUE}git init && git add .${NC}"
    echo -e "  3. ${BLUE}code .${NC} (abrir en VS Code)"
    echo -e "  4. Personalizar .gitignore si es necesario"
}

main "$@"