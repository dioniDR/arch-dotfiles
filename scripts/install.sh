#!/bin/bash
# =============================================================================
# INSTALADOR AUTOMÁTICO DE DOTFILES PARA ARCH LINUX + HYPRLAND
# Script para nueva instalación o restauración completa
# =============================================================================

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Variables
DOTFILES_REPO="https://github.com/TU_USUARIO/arch-dotfiles.git"  # Cambiar por tu repo
DOTFILES_DIR="$HOME/.dotfiles"
LOG_FILE="/tmp/dotfiles-install.log"

print_banner() {
    clear
    echo -e "${BLUE}"
    cat << 'EOF'
╭──────────────────────────────────────────────────────────────────╮
│                                                                  │
│           ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗ │
│           ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝ │
│           ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗   │
│           ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝   │
│           ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗ │
│           ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝ │
│                                                                  │
│                    ARCH LINUX + HYPRLAND SETUP                  │
│                                                                  │
╰──────────────────────────────────────────────────────────────────╯
EOF
    echo -e "${NC}"
}

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
    echo -e "${GREEN}[$(date '+%H:%M:%S')]${NC} $1"
}

error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $1" >> "$LOG_FILE"
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

warning() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - WARNING: $1" >> "$LOG_FILE"
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Verificar si es Arch Linux
check_arch() {
    if [[ ! -f /etc/arch-release ]]; then
        error "Este script está diseñado para Arch Linux"
    fi
    log "✅ Sistema Arch Linux detectado"
}

# Verificar conexión a internet
check_internet() {
    if ! ping -c 1 google.com &> /dev/null; then
        error "No hay conexión a internet"
    fi
    log "✅ Conexión a internet verificada"
}

# Actualizar sistema
update_system() {
    log "🔄 Actualizando sistema..."
    sudo pacman -Syu --noconfirm || error "Error actualizando sistema"
    log "✅ Sistema actualizado"
}

# Instalar dependencias básicas
install_base_deps() {
    log "📦 Instalando dependencias básicas..."
    
    local deps=(
        "git"
        "base-devel"
        "wget"
        "curl"
        "unzip"
        "nodejs"
        "npm"
    )
    
    for dep in "${deps[@]}"; do
        if ! pacman -Qi "$dep" &>/dev/null; then
            info "Instalando: $dep"
            sudo pacman -S --noconfirm "$dep" || warning "Error instalando $dep"
        fi
    done
    
    log "✅ Dependencias básicas instaladas"
}

# Instalar AUR helper (yay)
install_yay() {
    if command -v yay &>/dev/null; then
        log "✅ Yay ya está instalado"
        return
    fi
    
    log "🔧 Instalando yay (AUR helper)..."
    
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay
    
    log "✅ Yay instalado"
}

# Clonar repositorio de dotfiles
clone_dotfiles() {
    log "📥 Clonando repositorio de dotfiles..."
    
    if [[ -d "$DOTFILES_DIR" ]]; then
        warning "El directorio $DOTFILES_DIR ya existe, respaldando..."
        mv "$DOTFILES_DIR" "$DOTFILES_DIR.backup.$(date +%s)"
    fi
    
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" || error "Error clonando repositorio"
    cd "$DOTFILES_DIR"
    
    log "✅ Repositorio clonado en $DOTFILES_DIR"
}

# Instalar paquetes desde listas
install_packages() {
    log "📦 Instalando paquetes desde listas..."
    
    # Instalar paquetes oficiales
    if [[ -f "$DOTFILES_DIR/packages/pacman-explicit.txt" ]]; then
        info "Instalando paquetes oficiales..."
        while IFS= read -r package; do
            if [[ -n "$package" && ! "$package" =~ ^# ]]; then
                package_name=$(echo "$package" | awk '{print $1}')
                if ! pacman -Qi "$package_name" &>/dev/null; then
                    info "📦 $package_name"
                    sudo pacman -S --noconfirm "$package_name" || warning "Error con $package_name"
                fi
            fi
        done < "$DOTFILES_DIR/packages/pacman-explicit.txt"
    fi
    
    # Instalar paquetes AUR
    if [[ -f "$DOTFILES_DIR/packages/aur-packages.txt" ]]; then
        info "Instalando paquetes de AUR..."
        while IFS= read -r package; do
            if [[ -n "$package" && ! "$package" =~ ^# ]]; then
                package_name=$(echo "$package" | awk '{print $1}')
                if ! yay -Qi "$package_name" &>/dev/null; then
                    info "🔶 $package_name (AUR)"
                    yay -S --noconfirm "$package_name" || warning "Error con $package_name"
                fi
            fi
        done < "$DOTFILES_DIR/packages/aur-packages.txt"
    fi
    
    log "✅ Paquetes instalados"
}

# Aplicar configuraciones
apply_configs() {
    log "⚙️ Aplicando configuraciones..."
    
    cd "$DOTFILES_DIR"
    chmod +x scripts/dotfiles-manager.sh
    ./scripts/dotfiles-manager.sh backup
    ./scripts/dotfiles-manager.sh link
    
    log "✅ Configuraciones aplicadas"
}

# Instalar extensiones de VS Code
install_vscode_extensions() {
    if ! command -v code &>/dev/null; then
        warning "VS Code no está instalado, saltando extensiones"
        return
    fi
    
    if [[ -f "$DOTFILES_DIR/packages/vscode-extensions.txt" ]]; then
        log "🔌 Instalando extensiones de VS Code..."
        while IFS= read -r extension; do
            if [[ -n "$extension" && ! "$extension" =~ ^# ]]; then
                info "🔌 $extension"
                code --install-extension "$extension" || warning "Error con $extension"
            fi
        done < "$DOTFILES_DIR/packages/vscode-extensions.txt"
        log "✅ Extensiones de VS Code instaladas"
    fi
}

# Configurar servicios de Hyprland
setup_hyprland_services() {
    log "🖥️ Configurando servicios de Hyprland..."
    
    # Habilitar servicios necesarios
    sudo systemctl enable NetworkManager
    sudo systemctl enable bluetooth
    
    # Configurar auto-login (opcional)
    read -p "¿Configurar auto-login? (y/N): " auto_login
    if [[ "$auto_login" =~ ^[Yy]$ ]]; then
        sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
        cat << EOF | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I $TERM
EOF
        log "✅ Auto-login configurado"
    fi
}

# Configuración final
final_setup() {
    log "🎨 Configuración final..."
    
    # Crear directorios necesarios
    mkdir -p "$HOME"/{Pictures,Documents,Downloads,Projects}
    
    # Configurar permisos
    chmod 700 "$HOME/.ssh" 2>/dev/null || true
    chmod 600 "$HOME/.ssh/config" 2>/dev/null || true
    
    # Recargar configuración de shell
    if [[ -f "$HOME/.bashrc" ]]; then
        source "$HOME/.bashrc"
    fi
    
    log "✅ Configuración final completada"
}

# Función principal
main() {
    print_banner
    
    info "Iniciando instalación de dotfiles..."
    info "Log guardado en: $LOG_FILE"
    
    # Verificaciones previas
    check_arch
    check_internet
    
    # Instalación paso a paso
    update_system
    install_base_deps
    install_yay
    clone_dotfiles
    install_packages
    apply_configs
    install_vscode_extensions
    setup_hyprland_services
    final_setup
    
    echo -e "\n${GREEN}🎉 ¡INSTALACIÓN COMPLETADA! 🎉${NC}\n"
    echo -e "📍 Dotfiles instalados en: ${BLUE}$DOTFILES_DIR${NC}"
    echo -e "📋 Log de instalación: ${BLUE}$LOG_FILE${NC}"
    echo -e "\n${YELLOW}Para completar la configuración:${NC}"
    echo -e "  1. ${BLUE}logout${NC} y ${BLUE}login${NC} nuevamente"
    echo -e "  2. Selecciona Hyprland como sesión"
    echo -e "  3. Abre VS Code: ${BLUE}code $DOTFILES_DIR${NC}"
    echo -e "\n${PURPLE}¡Disfruta tu nuevo entorno!${NC} 🚀"
}

# Ejecutar si es llamado directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi