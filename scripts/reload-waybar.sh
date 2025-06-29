#!/bin/bash
# =============================================================================
# SCRIPT PARA RECARGAR WAYBAR EN HYPRLAND
# Maneja la recarga segura de Waybar con verificaciones
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_step() {
    echo -e "${GREEN}[WAYBAR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que estamos en Hyprland
check_hyprland() {
    if ! pgrep Hyprland >/dev/null; then
        print_error "Hyprland no está ejecutándose"
        exit 1
    fi
    
    if [[ -z "$WAYLAND_DISPLAY" ]]; then
        print_error "No estamos en sesión Wayland"
        exit 1
    fi
    
    print_info "✅ Sistema Wayland/Hyprland detectado"
}

# Verificar configuración de Waybar
check_waybar_config() {
    if [[ ! -f ~/.config/waybar/config.jsonc ]]; then
        print_error "Configuración de Waybar no encontrada"
        exit 1
    fi
    
    # Verificar sintaxis JSON
    if ! python3 -m json.tool ~/.config/waybar/config.jsonc >/dev/null 2>&1; then
        print_warning "Verificando JSON con comentarios..."
        # Para JSONC, solo verificamos que el archivo existe y no está vacío
        if [[ ! -s ~/.config/waybar/config.jsonc ]]; then
            print_error "Archivo de configuración vacío"
            exit 1
        fi
    fi
    
    print_info "✅ Configuración verificada"
}

# Recargar Waybar
reload_waybar() {
    print_step "Terminando procesos Waybar existentes..."
    
    # Terminar Waybar de forma segura
    if pgrep waybar >/dev/null; then
        pkill waybar
        sleep 2
        
        # Forzar si aún está ejecutándose
        if pgrep waybar >/dev/null; then
            pkill -9 waybar
            sleep 1
        fi
        print_info "✅ Procesos Waybar terminados"
    else
        print_info "ℹ️  Waybar no estaba ejecutándose"
    fi
    
    print_step "Iniciando Waybar..."
    
    # Iniciar Waybar en background
    nohup waybar > ~/.config/waybar/waybar.log 2>&1 &
    
    # Verificar que se inició correctamente
    sleep 2
    if pgrep waybar >/dev/null; then
        print_info "✅ Waybar reiniciado correctamente"
    else
        print_error "❌ Error al iniciar Waybar"
        if [[ -f ~/.config/waybar/waybar.log ]]; then
            print_error "Últimas líneas del log:"
            tail -5 ~/.config/waybar/waybar.log
        fi
        exit 1
    fi
}

# Función principal
main() {
    echo -e "${BLUE}"
    echo "╭─────────────────────────────────────────────╮"
    echo "│            RECARGA DE WAYBAR                │"
    echo "│         Hyprland + Nerd Fonts               │"
    echo "╰─────────────────────────────────────────────╯"
    echo -e "${NC}"
    
    check_hyprland
    check_waybar_config
    reload_waybar
    
    echo -e "\n${GREEN}🎉 WAYBAR RECARGADO EXITOSAMENTE${NC}"
    echo -e "📊 Iconos Nerd Font aplicados"
    echo -e "🔧 Configuración: ~/.config/waybar/config.jsonc"
    
    if [[ -f ~/.config/waybar/waybar.log ]]; then
        echo -e "📋 Log: ~/.config/waybar/waybar.log"
    fi
}

main "$@"