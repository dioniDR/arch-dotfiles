#!/bin/bash
# =============================================================================
# SCRIPT MAESTRO DE GESTIÓN DE DOTFILES PARA ARCH + HYPRLAND
# =============================================================================

set -e  # Salir si hay error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directorio del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

print_header() {
    echo -e "${BLUE}"
    echo "╭─────────────────────────────────────────────────────────────╮"
    echo "│                    ARCH DOTFILES MANAGER                   │"
    echo "│                   Hyprland + VS Code                       │"
    echo "╰─────────────────────────────────────────────────────────────╯"
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}[STEP]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# =============================================================================
# FUNCIÓN: BACKUP DE CONFIGURACIONES ACTUALES
# =============================================================================
backup_configs() {
    print_step "Creando backup de configuraciones actuales..."
    
    BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Lista de archivos a respaldar
    declare -a configs=(
        "$HOME/.config/hypr"
        "$HOME/.config/waybar"
        "$HOME/.config/kitty"
        "$HOME/.config/alacritty"
        "$HOME/.config/rofi"
        "$HOME/.config/wofi"
        "$HOME/.config/dunst"
        "$HOME/.config/mako"
        "$HOME/.bashrc"
        "$HOME/.zshrc"
        "$HOME/.profile"
        "$HOME/.gitconfig"
        "$HOME/.config/Code/User"
    )
    
    for config in "${configs[@]}"; do
        if [[ -e "$config" ]]; then
            print_info "Respaldando: $config"
            cp -r "$config" "$BACKUP_DIR/" 2>/dev/null || true
        fi
    done
    
    print_info "Backup creado en: $BACKUP_DIR"
}

# =============================================================================
# FUNCIÓN: CREAR ENLACES SIMBÓLICOS
# =============================================================================
create_symlinks() {
    print_step "Creando enlaces simbólicos..."
    
    # Crear directorios necesarios
    mkdir -p "$HOME/.config"
    
    # Enlaces para configuraciones
    declare -A symlinks=(
        ["$DOTFILES_DIR/config/hypr"]="$HOME/.config/hypr"
        ["$DOTFILES_DIR/config/waybar"]="$HOME/.config/waybar"
        ["$DOTFILES_DIR/config/kitty"]="$HOME/.config/kitty"
        ["$DOTFILES_DIR/config/rofi"]="$HOME/.config/rofi"
        ["$DOTFILES_DIR/config/dunst"]="$HOME/.config/dunst"
        ["$DOTFILES_DIR/shell/.bashrc"]="$HOME/.bashrc"
        ["$DOTFILES_DIR/shell/.zshrc"]="$HOME/.zshrc"
        ["$DOTFILES_DIR/shell/.profile"]="$HOME/.profile"
    )
    
    for source in "${!symlinks[@]}"; do
        target="${symlinks[$source]}"
        
        if [[ -e "$source" ]]; then
            # Remover archivo/directorio existente
            if [[ -e "$target" && ! -L "$target" ]]; then
                print_info "Moviendo $target existente al backup"
                mv "$target" "$target.backup.$(date +%s)" 2>/dev/null || true
            elif [[ -L "$target" ]]; then
                rm "$target"
            fi
            
            # Crear enlace simbólico
            ln -sf "$source" "$target"
            print_info "Enlace creado: $target -> $source"
        else
            print_error "Archivo fuente no encontrado: $source"
        fi
    done
}

# =============================================================================
# FUNCIÓN: INSTALAR PAQUETES
# =============================================================================
install_packages() {
    print_step "Instalando paquetes necesarios..."
    
    # Verificar si los archivos de paquetes existen
    PACMAN_LIST="$DOTFILES_DIR/packages/pacman-explicit.txt"
    AUR_LIST="$DOTFILES_DIR/packages/aur-packages.txt"
    
    if [[ -f "$PACMAN_LIST" ]]; then
        print_info "Instalando paquetes de repositorios oficiales..."
        while IFS= read -r package; do
            if [[ -n "$package" && ! "$package" =~ ^# ]]; then
                package_name=$(echo "$package" | awk '{print $1}')
                if ! pacman -Qi "$package_name" &>/dev/null; then
                    print_info "Instalando: $package_name"
                    sudo pacman -S --noconfirm "$package_name" || print_error "Error instalando $package_name"
                fi
            fi
        done < "$PACMAN_LIST"
    fi
    
    if [[ -f "$AUR_LIST" ]] && command -v yay &>/dev/null; then
        print_info "Instalando paquetes de AUR..."
        while IFS= read -r package; do
            if [[ -n "$package" && ! "$package" =~ ^# ]]; then
                package_name=$(echo "$package" | awk '{print $1}')
                if ! yay -Qi "$package_name" &>/dev/null; then
                    print_info "Instalando desde AUR: $package_name"
                    yay -S --noconfirm "$package_name" || print_error "Error instalando $package_name"
                fi
            fi
        done < "$AUR_LIST"
    fi
}

# =============================================================================
# FUNCIÓN: EXPORTAR CONFIGURACIONES ACTUALES
# =============================================================================
export_current_configs() {
    print_step "Exportando configuraciones actuales al repositorio..."
    
    # Crear directorios en el repo
    mkdir -p "$DOTFILES_DIR"/{config,shell,system,packages,scripts,wallpapers,fonts}
    
    # Copiar configuraciones importantes
    declare -A exports=(
        ["$HOME/.config/hypr"]="$DOTFILES_DIR/config/hypr"
        ["$HOME/.config/waybar"]="$DOTFILES_DIR/config/waybar"
        ["$HOME/.config/kitty"]="$DOTFILES_DIR/config/kitty"
        ["$HOME/.config/rofi"]="$DOTFILES_DIR/config/rofi"
        ["$HOME/.config/dunst"]="$DOTFILES_DIR/config/dunst"
        ["$HOME/.bashrc"]="$DOTFILES_DIR/shell/.bashrc"
        ["$HOME/.zshrc"]="$DOTFILES_DIR/shell/.zshrc"
        ["$HOME/.profile"]="$DOTFILES_DIR/shell/.profile"
    )
    
    for source in "${!exports[@]}"; do
        target="${exports[$source]}"
        
        if [[ -e "$source" ]]; then
            print_info "Exportando: $source -> $target"
            if [[ -d "$source" ]]; then
                cp -r "$source" "$target"
            else
                cp "$source" "$target"
            fi
        fi
    done
    
    # Exportar listas de paquetes
    print_info "Exportando listas de paquetes..."
    pacman -Qe > "$DOTFILES_DIR/packages/pacman-explicit.txt"
    pacman -Qm > "$DOTFILES_DIR/packages/aur-packages.txt"
    
    # Exportar extensiones de VS Code si está instalado
    if command -v code &>/dev/null; then
        code --list-extensions > "$DOTFILES_DIR/packages/vscode-extensions.txt"
    fi
    
    print_info "Exportación completada"
}

# =============================================================================
# FUNCIÓN: CONFIGURAR VS CODE PARA DOTFILES
# =============================================================================
setup_vscode() {
    print_step "Configurando VS Code para desarrollo de dotfiles..."
    
    VSCODE_DIR="$DOTFILES_DIR/.vscode"
    mkdir -p "$VSCODE_DIR"
    
    # Configuración del workspace
    cat > "$VSCODE_DIR/settings.json" << 'EOF'
{
    "files.exclude": {
        "**/.git": true,
        "**/.DS_Store": true,
        "**/node_modules": true,
        "**/*.backup.*": true
    },
    "files.associations": {
        "*.conf": "ini",
        "*.rasi": "css",
        "hyprland.conf": "ini",
        "waybar/config": "json",
        "dunstrc": "ini"
    },
    "git.defaultCloneDirectory": "~/Projects",
    "terminal.integrated.defaultProfile.linux": "bash",
    "workbench.colorTheme": "Dark+",
    "editor.formatOnSave": true,
    "files.trimTrailingWhitespace": true
}
EOF

    # Extensiones recomendadas
    cat > "$VSCODE_DIR/extensions.json" << 'EOF'
{
    "recommendations": [
        "ms-vscode.vscode-json",
        "redhat.vscode-yaml",
        "foxundermoon.shell-format",
        "timonwong.shellcheck",
        "ms-python.python",
        "bradlc.vscode-tailwindcss",
        "streetsidesoftware.code-spell-checker"
    ]
}
EOF

    # Tareas automatizadas
    cat > "$VSCODE_DIR/tasks.json" << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Export Current Configs",
            "type": "shell",
            "command": "${workspaceFolder}/scripts/dotfiles-manager.sh",
            "args": ["export"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        },
        {
            "label": "Create Symlinks",
            "type": "shell",
            "command": "${workspaceFolder}/scripts/dotfiles-manager.sh",
            "args": ["link"],
            "group": "build"
        },
        {
            "label": "Backup Current Configs",
            "type": "shell",
            "command": "${workspaceFolder}/scripts/dotfiles-manager.sh",
            "args": ["backup"],
            "group": "build"
        }
    ]
}
EOF

    print_info "VS Code configurado para dotfiles"
}

# =============================================================================
# FUNCIÓN PRINCIPAL
# =============================================================================
main() {
    print_header
    
    case "${1:-help}" in
        "backup")
            backup_configs
            ;;
        "export")
            export_current_configs
            ;;
        "link")
            create_symlinks
            ;;
        "install")
            install_packages
            ;;
        "setup")
            backup_configs
            export_current_configs
            create_symlinks
            setup_vscode
            print_step "¡Configuración completa!"
            print_info "Ahora puedes abrir VS Code en: $DOTFILES_DIR"
            ;;
        "vscode")
            setup_vscode
            ;;
        *)
            echo "Uso: $0 {backup|export|link|install|setup|vscode}"
            echo ""
            echo "  backup  - Respaldar configuraciones actuales"
            echo "  export  - Exportar configuraciones al repositorio"
            echo "  link    - Crear enlaces simbólicos desde el repo"
            echo "  install - Instalar paquetes desde listas"
            echo "  setup   - Configuración completa (backup + export + link + vscode)"
            echo "  vscode  - Configurar VS Code para dotfiles"
            ;;
    esac
}

main "$@"