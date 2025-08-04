#!/bin/bash
# =============================================================================
# BACKUP DE EMERGENCIA ANTES DE CAMBIOS DELICADOS AL SISTEMA
# Crea snapshot completo del estado actual para recovery rápido
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
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/.emergency-backups"
CURRENT_BACKUP="$BACKUP_DIR/emergency-$TIMESTAMP"
DOTFILES_DIR="$HOME/arch-dotfiles"

print_header() {
    clear
    echo -e "${PURPLE}"
    echo "╭────────────────────────────────────────────────────────────╮"
    echo "│                  BACKUP DE EMERGENCIA                      │"
    echo "│          Antes de cambios críticos al sistema             │"
    echo "╰────────────────────────────────────────────────────────────╯"
    echo -e "${NC}"
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Crear estructura de backup
create_backup_structure() {
    log_info "Creando estructura de backup..."
    mkdir -p "$CURRENT_BACKUP"/{configs,packages,system,docs,scripts}
    log_success "Estructura creada en: $CURRENT_BACKUP"
}

# Backup de configuraciones críticas DEL SISTEMA ACTIVO
backup_live_configs() {
    log_info "Backing up configuraciones ACTIVAS del sistema..."
    
    # Configuraciones de Hyprland (las que están funcionando AHORA)
    if [[ -d ~/.config/hypr ]]; then
        cp -r ~/.config/hypr "$CURRENT_BACKUP/configs/"
        log_success "✅ Hyprland config (sistema activo)"
    fi
    
    # Waybar activo
    if [[ -d ~/.config/waybar ]]; then
        cp -r ~/.config/waybar "$CURRENT_BACKUP/configs/"
        log_success "✅ Waybar config (sistema activo)"
    fi
    
    # Otras configs críticas activas
    local active_configs=(
        "wofi" "kitty" "Code" "mako" "gtk-3.0" "pulse" "pipewire"
    )
    
    for config in "${active_configs[@]}"; do
        if [[ -d ~/.config/$config ]]; then
            cp -r ~/.config/$config "$CURRENT_BACKUP/configs/"
            log_success "✅ $config config"
        fi
    done
    
    # Shell configs activos
    for file in .bashrc .bash_profile .profile .xbindkeysrc; do
        if [[ -f ~/$file ]]; then
            cp ~/$file "$CURRENT_BACKUP/configs/"
            log_success "✅ $file"
        fi
    done
}

# Backup del repositorio dotfiles
backup_dotfiles_repo() {
    log_info "Backing up repositorio arch-dotfiles..."
    
    if [[ -d "$DOTFILES_DIR" ]]; then
        # Crear backup completo del repo
        cp -r "$DOTFILES_DIR" "$CURRENT_BACKUP/arch-dotfiles-repo"
        
        # Estado git actual
        cd "$DOTFILES_DIR"
        git status > "$CURRENT_BACKUP/git-status.txt"
        git log -10 --oneline > "$CURRENT_BACKUP/git-recent-commits.txt"
        
        log_success "✅ Repositorio arch-dotfiles completo"
    fi
}

# Generar listas actualizadas de paquetes
generate_package_lists() {
    log_info "Generando listas actualizadas de paquetes..."
    
    # Paquetes oficiales instalados explícitamente
    pacman -Qe > "$CURRENT_BACKUP/packages/pacman-explicit-CURRENT.txt"
    local explicit_count=$(wc -l < "$CURRENT_BACKUP/packages/pacman-explicit-CURRENT.txt")
    log_success "✅ $explicit_count paquetes oficiales"
    
    # Paquetes AUR
    pacman -Qm > "$CURRENT_BACKUP/packages/aur-packages-CURRENT.txt"
    local aur_count=$(wc -l < "$CURRENT_BACKUP/packages/aur-packages-CURRENT.txt")
    log_success "✅ $aur_count paquetes AUR"
    
    # TODOS los paquetes (para reference completa)
    pacman -Q > "$CURRENT_BACKUP/packages/all-packages-CURRENT.txt"
    local total_count=$(wc -l < "$CURRENT_BACKUP/packages/all-packages-CURRENT.txt")
    log_success "✅ $total_count paquetes totales"
    
    # Extensiones VS Code
    if command -v code &>/dev/null; then
        code --list-extensions > "$CURRENT_BACKUP/packages/vscode-extensions-CURRENT.txt"
        local vscode_count=$(wc -l < "$CURRENT_BACKUP/packages/vscode-extensions-CURRENT.txt")
        log_success "✅ $vscode_count extensiones VS Code"
    fi
}

# Backup información del sistema
backup_system_info() {
    log_info "Capturando información del sistema..."
    
    # Hardware info
    lscpu > "$CURRENT_BACKUP/system/cpu-info.txt"
    lsmem > "$CURRENT_BACKUP/system/memory-info.txt" 2>/dev/null || echo "lsmem no disponible" > "$CURRENT_BACKUP/system/memory-info.txt"
    lspci > "$CURRENT_BACKUP/system/pci-devices.txt"
    lsusb > "$CURRENT_BACKUP/system/usb-devices.txt"
    
    # Sistema
    uname -a > "$CURRENT_BACKUP/system/kernel-info.txt"
    hostnamectl > "$CURRENT_BACKUP/system/system-info.txt"
    
    # Servicios activos
    systemctl list-unit-files --state=enabled > "$CURRENT_BACKUP/system/enabled-services.txt"
    systemctl --user list-unit-files --state=enabled > "$CURRENT_BACKUP/system/user-enabled-services.txt"
    
    # Información de red
    ip addr show > "$CURRENT_BACKUP/system/network-interfaces.txt"
    
    log_success "✅ Información del sistema capturada"
}

# Crear script de recovery automático
create_recovery_script() {
    log_info "Creando script de recovery automático..."
    
    cat > "$CURRENT_BACKUP/RECOVERY-INSTRUCTIONS.sh" << 'EOF'
#!/bin/bash
# =============================================================================
# RECOVERY AUTOMÁTICO DESDE BACKUP DE EMERGENCIA
# Ejecutar este script para restaurar el sistema al estado del backup
# =============================================================================

echo "🚨 RECOVERY DESDE BACKUP DE EMERGENCIA"
echo "======================================"

BACKUP_DIR="$(dirname "$0")"
echo "Restaurando desde: $BACKUP_DIR"

# Restaurar configuraciones
echo "📁 Restaurando configuraciones..."
cp -r "$BACKUP_DIR/configs/"* ~/.config/

# Restaurar dotfiles de home
echo "🏠 Restaurando dotfiles..."
for file in "$BACKUP_DIR/configs/".{bashrc,bash_profile,profile,xbindkeysrc}; do
    if [[ -f "$file" ]]; then
        cp "$file" ~/
    fi
done

# Reinstalar paquetes desde listas
echo "📦 Listas de paquetes disponibles para reinstalar:"
echo "   - $BACKUP_DIR/packages/pacman-explicit-CURRENT.txt"
echo "   - $BACKUP_DIR/packages/aur-packages-CURRENT.txt"
echo "   - $BACKUP_DIR/packages/vscode-extensions-CURRENT.txt"

echo ""
echo "🔄 Para completar recovery:"
echo "1. Reinstalar paquetes: sudo pacman -S \$(cat $BACKUP_DIR/packages/pacman-explicit-CURRENT.txt | awk '{print \$1}')"
echo "2. Reinstalar AUR: yay -S \$(cat $BACKUP_DIR/packages/aur-packages-CURRENT.txt | awk '{print \$1}')"
echo "3. Reiniciar servicios: killall waybar && waybar &"
echo "4. Recargar Hyprland: hyprctl reload"

echo "✅ Recovery de configuraciones completado!"
EOF
    
    chmod +x "$CURRENT_BACKUP/RECOVERY-INSTRUCTIONS.sh"
    log_success "✅ Script de recovery creado"
}

# Generar reporte del backup
generate_backup_report() {
    log_info "Generando reporte del backup..."
    
    cat > "$CURRENT_BACKUP/BACKUP-REPORT.txt" << EOF
BACKUP DE EMERGENCIA - REPORTE
==============================
Fecha: $(date)
Sistema: $(hostnamectl --static)
Usuario: $(whoami)
Kernel: $(uname -r)

CONTENIDO DEL BACKUP:
--------------------
$(du -sh "$CURRENT_BACKUP"/* | sort -hr)

PAQUETES RESPALDADOS:
--------------------
- Oficiales: $(wc -l < "$CURRENT_BACKUP/packages/pacman-explicit-CURRENT.txt") paquetes
- AUR: $(wc -l < "$CURRENT_BACKUP/packages/aur-packages-CURRENT.txt") paquetes
- VS Code: $(wc -l < "$CURRENT_BACKUP/packages/vscode-extensions-CURRENT.txt" 2>/dev/null || echo "0") extensiones

CONFIGURACIONES RESPALDADAS:
---------------------------
$(ls -la "$CURRENT_BACKUP/configs/")

PARA RECOVERY:
--------------
1. Ejecutar: $CURRENT_BACKUP/RECOVERY-INSTRUCTIONS.sh
2. Seguir instrucciones en pantalla
3. Reiniciar servicios según sea necesario

UBICACIÓN BACKUP: $CURRENT_BACKUP
EOF
    
    log_success "✅ Reporte generado"
}

# Función principal
main() {
    print_header
    
    echo -e "${YELLOW}⚠️  CREANDO BACKUP DE EMERGENCIA ANTES DE CAMBIOS CRÍTICOS${NC}"
    echo -e "${BLUE}Timestamp: $TIMESTAMP${NC}"
    echo ""
    
    create_backup_structure
    backup_live_configs
    backup_dotfiles_repo
    generate_package_lists
    backup_system_info
    create_recovery_script
    generate_backup_report
    
    echo ""
    echo -e "${GREEN}🎉 BACKUP DE EMERGENCIA COMPLETADO${NC}"
    echo -e "${BLUE}Ubicación: $CURRENT_BACKUP${NC}"
    echo -e "${BLUE}Tamaño: $(du -sh "$CURRENT_BACKUP" | cut -f1)${NC}"
    echo ""
    echo -e "${YELLOW}📋 PARA RECOVERY:${NC}"
    echo -e "   1. ${BLUE}$CURRENT_BACKUP/RECOVERY-INSTRUCTIONS.sh${NC}"
    echo -e "   2. Seguir instrucciones del script"
    echo ""
    echo -e "${GREEN}✅ AHORA PUEDES HACER CAMBIOS DELICADOS CON SEGURIDAD${NC}"
}

main "$@"