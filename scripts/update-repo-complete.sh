#!/bin/bash
# =============================================================================
# ACTUALIZADOR COMPLETO DEL REPOSITORIO ARCH-DOTFILES
# Sincroniza configuraciones actuales del sistema con el repo
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

DOTFILES_DIR="$HOME/arch-dotfiles"

print_header() {
    clear
    echo -e "${PURPLE}"
    echo "╭────────────────────────────────────────────────────────────╮"
    echo "│              ACTUALIZACIÓN COMPLETA REPO                  │"
    echo "│           Sincronización Sistema → Repo                   │"
    echo "╰────────────────────────────────────────────────────────────╯"
    echo -e "${NC}"
}

log_info() {
    echo -e "${BLUE}[SYNC]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Sincronizar configuraciones activas
sync_active_configs() {
    log_info "Sincronizando configuraciones ACTIVAS del sistema..."
    
    # Hyprland (configuración que funciona AHORA)
    if [[ -d ~/.config/hypr ]]; then
        cp -r ~/.config/hypr/* "$DOTFILES_DIR/config/hypr/"
        log_success "✅ Hyprland config sincronizada"
    fi
    
    # Waybar activa
    if [[ -d ~/.config/waybar ]]; then
        cp -r ~/.config/waybar/* "$DOTFILES_DIR/config/waybar/"
        log_success "✅ Waybar config sincronizada"
    fi
    
    # Otras configuraciones críticas
    local configs=("wofi" "kitty" "Code" "mako" "gtk-3.0" "warp-terminal")
    for config in "${configs[@]}"; do
        if [[ -d ~/.config/$config ]]; then
            mkdir -p "$DOTFILES_DIR/config/$config"
            cp -r ~/.config/$config/* "$DOTFILES_DIR/config/$config/" 2>/dev/null || true
            log_success "✅ $config sincronizado"
        fi
    done
    
    # Shell configs
    for file in .bashrc .bash_profile .profile .xbindkeysrc; do
        if [[ -f ~/$file ]]; then
            cp ~/$file "$DOTFILES_DIR/shell/"
            log_success "✅ $file sincronizado"
        fi
    done
}

# Actualizar listas de paquetes
update_package_lists() {
    log_info "Actualizando listas de paquetes..."
    
    # Paquetes oficiales
    pacman -Qe > "$DOTFILES_DIR/packages/pacman-explicit.txt"
    local official_count=$(wc -l < "$DOTFILES_DIR/packages/pacman-explicit.txt")
    log_success "✅ $official_count paquetes oficiales"
    
    # Paquetes AUR
    pacman -Qm > "$DOTFILES_DIR/packages/aur-packages.txt"
    local aur_count=$(wc -l < "$DOTFILES_DIR/packages/aur-packages.txt")
    log_success "✅ $aur_count paquetes AUR"
    
    # Extensiones VS Code
    if command -v code &>/dev/null; then
        code --list-extensions > "$DOTFILES_DIR/packages/vscode-extensions.txt"
        local vscode_count=$(wc -l < "$DOTFILES_DIR/packages/vscode-extensions.txt")
        log_success "✅ $vscode_count extensiones VS Code"
    fi
}

# Generar README dinámico
generate_dynamic_readme() {
    log_info "Generando README dinámico..."
    
    # Obtener información actual del sistema
    local cpu_model=$(lscpu | grep "Model name:" | cut -d: -f2 | xargs)
    local ram_total=$(free -h | awk '/^Mem:/ {print $2}')
    local kernel_ver=$(uname -r)
    local uptime=$(uptime -p | sed 's/up //')
    
    # Estado de servicios
    local hyprland_status=$(pgrep Hyprland >/dev/null && echo "✅ Activo" || echo "❌ Inactivo")
    local waybar_status=$(pgrep waybar >/dev/null && echo "✅ Activo" || echo "❌ Inactivo")
    local audio_status=$(pactl info >/dev/null 2>&1 && echo "✅ PulseAudio" || echo "❌ Sin audio")
    
    # Contadores
    local official_packages=$(wc -l < "$DOTFILES_DIR/packages/pacman-explicit.txt")
    local aur_packages=$(wc -l < "$DOTFILES_DIR/packages/aur-packages.txt")
    local vscode_extensions=$(wc -l < "$DOTFILES_DIR/packages/vscode-extensions.txt" 2>/dev/null || echo "0")
    local config_dirs=$(find ~/.config -maxdepth 1 -type d | wc -l)
    local repo_size=$(du -sh "$DOTFILES_DIR" | cut -f1)
    
    cat > "$DOTFILES_DIR/README.md" << EOF
# 🏠 Arch Linux + Hyprland Dotfiles
*Generado automáticamente el $(date '+%d/%m/%Y %H:%M')*

## 🖥️ Hardware Detectado

- **CPU**: $cpu_model
- **RAM**: $ram_total
- **GPU**: $(lspci | grep -i vga | sed 's/.*: //' | head -1)
- **Kernel**: Linux $kernel_ver
- **Uptime**: $uptime

## 🚀 Estado del Sistema

| Componente | Estado |
|------------|--------|
| Hyprland | $hyprland_status |
| Waybar | $waybar_status |
| Audio | $audio_status |
| **Completitud** | **85%** |

## 📊 Estadísticas Dinámicas

- **Paquetes oficiales**: $official_packages
- **Paquetes AUR**: $aur_packages
- **Extensiones VS Code**: $vscode_extensions
- **Configuraciones**: $config_dirs directorios en ~/.config
- **Tamaño total**: $repo_size

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
**Completitud: 85%** | *Sistema productivo para desarrollo diario*
EOF
    
    log_success "✅ README dinámico generado"
}

# Crear commit automático con información del sistema
create_auto_commit() {
    log_info "Creando commit automático..."
    
    cd "$DOTFILES_DIR"
    
    # Agregar todos los cambios
    git add .
    
    # Información del sistema para el commit
    local hostname=$(hostname)
    local kernel=$(uname -r)
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    
    # Commit con información detallada
    git commit -m "🔄 AUTO-SYNC: $hostname - Kernel $kernel - $timestamp

Sistema actualizado:
- Configuraciones sincronizadas desde sistema activo
- Listas de paquetes actualizadas
- README generado dinámicamente
- Hardware: $(lscpu | grep 'Model name' | cut -d: -f2 | xargs)
- Uptime: $(uptime -p | sed 's/up //')

Cambios incluidos:
$(git diff --cached --name-only | head -10)
$([ $(git diff --cached --name-only | wc -l) -gt 10 ] && echo "... y $(( $(git diff --cached --name-only | wc -l) - 10 )) más")"
    
    log_success "✅ Commit automático creado"
}

# Función principal
main() {
    print_header
    
    echo -e "${YELLOW}📋 ACTUALIZANDO REPOSITORIO CON ESTADO ACTUAL DEL SISTEMA${NC}"
    echo -e "${BLUE}Timestamp: $(date)${NC}"
    echo ""
    
    sync_active_configs
    update_package_lists
    generate_dynamic_readme
    create_auto_commit
    
    echo ""
    echo -e "${GREEN}🎉 REPOSITORIO ACTUALIZADO COMPLETAMENTE${NC}"
    echo -e "${BLUE}Estado: Sincronizado con sistema activo${NC}"
    echo -e "${BLUE}Próximo paso: git push origin main${NC}"
    echo ""
    echo -e "${YELLOW}📋 CAMBIOS DETECTADOS:${NC}"
    cd "$DOTFILES_DIR"
    git show --stat HEAD
}

main "$@"