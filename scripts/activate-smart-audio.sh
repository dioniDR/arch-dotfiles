#!/bin/bash
# =============================================================================
# ACTIVADOR DEL MÓDULO DE AUDIO INTELIGENTE
# Script para activar/desactivar el módulo de audio inteligente en Waybar
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_step() {
    echo -e "${GREEN}[AUDIO]${NC} $1"
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

# Función para mostrar el estado actual
show_status() {
    echo -e "${BLUE}"
    echo "╭─────────────────────────────────────────────╮"
    echo "│        MÓDULO DE AUDIO INTELIGENTE          │"
    echo "│           Estado del Sistema                │"
    echo "╰─────────────────────────────────────────────╯"
    echo -e "${NC}"
    
    # Verificar si el script existe
    if [[ -f ~/.config/waybar/scripts/audio-detector.sh ]]; then
        print_info "✅ Script de detección instalado"
    else
        print_error "❌ Script de detección no encontrado"
        return 1
    fi
    
    # Verificar configuración de Waybar
    if grep -q "custom/audio" ~/.config/waybar/config.jsonc 2>/dev/null; then
        print_info "✅ Módulo configurado en Waybar"
    else
        print_warning "⚠️  Módulo no configurado en Waybar"
    fi
    
    # Verificar estilos CSS
    if grep -q "custom-audio" ~/.config/waybar/style.css 2>/dev/null; then
        print_info "✅ Estilos CSS aplicados"
    else
        print_warning "⚠️  Estilos CSS no encontrados"
    fi
    
    # Probar el script
    print_step "Probando detector de audio..."
    if ~/.config/waybar/scripts/audio-detector.sh >/dev/null 2>&1; then
        print_info "✅ Script funciona correctamente"
        echo
        print_info "🎵 Estado actual del audio:"
        ~/.config/waybar/scripts/audio-detector.sh | jq -r '.tooltip'
    else
        print_error "❌ Error en el script de detección"
        return 1
    fi
}

# Función para reinstalar el módulo
reinstall_module() {
    print_step "Reinstalando módulo de audio inteligente..."
    
    # Crear directorio de scripts si no existe
    mkdir -p ~/.config/waybar/scripts
    
    # Copiar script desde el repositorio
    if [[ -f ~/arch-dotfiles/scripts/audio-detector.sh ]]; then
        cp ~/arch-dotfiles/scripts/audio-detector.sh ~/.config/waybar/scripts/
        chmod +x ~/.config/waybar/scripts/audio-detector.sh
        print_info "✅ Script copiado desde el repositorio"
    else
        print_error "❌ Script no encontrado en el repositorio"
        return 1
    fi
    
    print_info "✅ Módulo reinstalado correctamente"
}

# Función para activar Waybar con el módulo
activate_waybar() {
    print_step "Activando Waybar con módulo de audio..."
    
    # Terminar Waybar actual
    pkill waybar 2>/dev/null || true
    sleep 1
    
    # Verificar que estamos en Hyprland
    if ! pgrep Hyprland >/dev/null; then
        print_error "Hyprland no está ejecutándose"
        return 1
    fi
    
    # Iniciar Waybar
    if command -v hyprctl >/dev/null; then
        hyprctl dispatch exec waybar
        print_info "✅ Waybar iniciado con hyprctl"
    else
        waybar &
        print_info "✅ Waybar iniciado directamente"
    fi
    
    # Esperar y verificar
    sleep 3
    if pgrep waybar >/dev/null; then
        print_info "✅ Waybar funcionando correctamente"
    else
        print_warning "⚠️  Waybar puede no estar visible (normal en algunos casos)"
    fi
}

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}USO:${NC}"
    echo "  $0 [status|install|activate|help]"
    echo
    echo -e "${BLUE}COMANDOS:${NC}"
    echo "  status    - Mostrar estado del módulo"
    echo "  install   - Reinstalar el módulo"
    echo "  activate  - Activar Waybar con el módulo"
    echo "  help      - Mostrar esta ayuda"
    echo
    echo -e "${BLUE}ESTADOS DEL MÓDULO DE AUDIO:${NC}"
    echo "  🟢 Verde pulsante - Audio reproduciéndose"
    echo "  🔴 Rojo - Audio silenciado"
    echo "  🟡 Amarillo pulsante - Audio silenciado pero con streams activos"
    echo "  ⚪ Gris - Audio listo pero sin reproducir"
    echo
    echo -e "${BLUE}CONTROLES:${NC}"
    echo "  Click izquierdo  - Abrir pavucontrol"
    echo "  Click derecho    - Toggle mute"
    echo "  Scroll arriba    - Subir volumen"
    echo "  Scroll abajo     - Bajar volumen"
}

# Función principal
main() {
    case "${1:-status}" in
        "status")
            show_status
            ;;
        "install")
            reinstall_module
            ;;
        "activate")
            activate_waybar
            ;;
        "help")
            show_help
            ;;
        *)
            print_error "Comando desconocido: $1"
            show_help
            exit 1
            ;;
    esac
}

# Verificar dependencias
if ! command -v pactl >/dev/null; then
    print_error "pactl no encontrado. Instalar: sudo pacman -S pulseaudio-utils"
    exit 1
fi

if ! command -v jq >/dev/null; then
    print_warning "jq no encontrado (opcional para formateo JSON)"
fi

main "$@"