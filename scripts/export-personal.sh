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
    
    # Pulse Audio
    if [[ -d "$HOME/.config/pulse" ]]; then
        cp "$HOME/.config/pulse/default.pa" "$DOTFILES_DIR/config/pulse/" 2>/dev/null || true
        print_info "✅ PulseAudio exportado"
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

# Crear README personalizado
create_readme() {
    print_step "Creando documentación..."
    
    cat > "$DOTFILES_DIR/README.md" << EOF
# 🏠 Arch Linux + Hyprland Dotfiles

## 🖥️ Mi Setup

- **OS**: Arch Linux (Kernel 6.15.3-arch1-1)
- **WM**: Hyprland
- **Bar**: Waybar
- **Terminal**: Kitty + Warp Terminal
- **Launcher**: Wofi
- **Notifications**: Mako
- **Shell**: Bash
- **Editor**: VS Code

## 📊 Estadísticas

- **Paquetes oficiales**: $(wc -l < "$DOTFILES_DIR/packages/pacman-explicit.txt" 2>/dev/null || echo "?")
- **Paquetes AUR**: $(wc -l < "$DOTFILES_DIR/packages/aur-packages.txt" 2>/dev/null || echo "?")
- **Configuraciones**: Hyprland, Waybar, Wofi, Mako, VS Code

## 🚀 Instalación Rápida

\`\`\`bash
git clone [tu-repo] ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh
\`\`\`

## 📁 Estructura

- \`config/hypr/\` - Configuración principal de Hyprland + scripts
- \`config/waybar/\` - Barra de estado personalizada
- \`shell/\` - Configuración de Bash + atajos
- \`packages/\` - Listas de paquetes para reinstalación
- \`scripts/\` - Scripts de automatización

## 🔧 Configuraciones Importantes

### Hyprland
- Configuración principal en \`config/hypr/hyprland.conf\`
- Scripts personalizados en \`scripts/hypr-scripts/\`
- Configuración de idle, lock y wallpapers

### Waybar
- Config JSON en \`config/waybar/config.jsonc\`
- Estilos CSS en \`config/waybar/style.css\`

### Aplicaciones Clave
- **Claude Code**: CLI de IA para desarrollo
- **Warp Terminal**: Terminal moderna
- **VS Code**: Editor principal con extensiones

---
*Generado automáticamente desde mi setup actual*
EOF

    print_info "✅ README creado"
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