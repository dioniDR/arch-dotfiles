#!/bin/bash

# ===============================================
# ARCH DOTFILES - PACKAGE VERIFICATION SCRIPT
# ===============================================
# Verifica qué paquetes están instalados y cuáles faltan
# Basado en los JSON de dependencias del sistema

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Directorios
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSTEM_DIR="$SCRIPT_DIR/../system"

# Contadores globales
TOTAL_PACKAGES=0
INSTALLED_PACKAGES=0
MISSING_PACKAGES=0

# Función para imprimir headers
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Función para verificar si un paquete está instalado
is_package_installed() {
    local package_name="$1"
    local source="$2"
    
    # Casos especiales
    case "$package_name" in
        "yay")
            command -v yay >/dev/null 2>&1
            return $?
            ;;
        "base-devel")
            pacman -Qg base-devel >/dev/null 2>&1
            return $?
            ;;
        *)
            if [[ "$source" == "yay" ]]; then
                # Si yay no está instalado, verificar con pacman como fallback
                if command -v yay >/dev/null 2>&1; then
                    yay -Qi "$package_name" >/dev/null 2>&1
                else
                    pacman -Qi "$package_name" >/dev/null 2>&1
                fi
            else
                pacman -Qi "$package_name" >/dev/null 2>&1
            fi
            return $?
            ;;
    esac
}

# Función para verificar paquetes desde JSON
verify_packages_from_json() {
    local json_file="$1"
    local category_name="$2"
    
    if [[ ! -f "$json_file" ]]; then
        echo -e "${RED}Error: No se encuentra $json_file${NC}"
        return 1
    fi
    
    print_header "$category_name"
    
    local category_installed=0
    local category_missing=0
    local category_total=0
    
    # Extraer paquetes del JSON usando jq si está disponible
    if command -v jq >/dev/null 2>&1; then
        # Usar jq para parsear JSON
        while IFS= read -r line; do
            local name=$(echo "$line" | cut -d'|' -f1)
            local source=$(echo "$line" | cut -d'|' -f2)
            local description=$(echo "$line" | cut -d'|' -f3)
            
            ((category_total++))
            ((TOTAL_PACKAGES++))
            
            if is_package_installed "$name" "$source"; then
                echo -e "  ${GREEN}✓${NC} $name - $description"
                ((category_installed++))
                ((INSTALLED_PACKAGES++))
            else
                echo -e "  ${RED}✗${NC} $name - $description ${YELLOW}[FALTA]${NC}"
                ((category_missing++))
                ((MISSING_PACKAGES++))
            fi
        done < <(jq -r '.all_packages[]? // (.escalon_1_base.packages[]?, .escalon_2_display.packages[]?, .escalon_3_compositor.packages[]?, .escalon_4_apps.packages[]?, .escalon_5_audio.packages[]?, .escalon_6_graphics.packages[]?, .escalon_7_hyprland_ecosystem.packages[]?, .escalon_8_tools.packages[]?, .escalon_9_shell.packages[]?) | "\(.name)|\(.source)|\(.description)"' "$json_file" 2>/dev/null)
    else
        # Fallback sin jq - usar grep básico
        echo -e "${YELLOW}Advertencia: jq no encontrado, usando verificación básica${NC}"
        
        # Lista hardcodeada de paquetes críticos para verificación básica
        local basic_packages=()
        case "$category_name" in
            *"CRÍTICO"*)
                basic_packages=("git" "hyprland" "kitty" "waybar" "wofi" "thunar" "greetd")
                ;;
            *"FUNCIONAL"*)
                basic_packages=("pipewire" "firefox" "mako" "grim" "slurp" "hyprlock" "htop")
                ;;
            *"PRODUCTIVIDAD"*)
                basic_packages=("zsh" "fzf" "zoxide")
                ;;
        esac
        
        for package in "${basic_packages[@]}"; do
            ((category_total++))
            ((TOTAL_PACKAGES++))
            
            if is_package_installed "$package" "pacman"; then
                echo -e "  ${GREEN}✓${NC} $package"
                ((category_installed++))
                ((INSTALLED_PACKAGES++))
            else
                echo -e "  ${RED}✗${NC} $package ${YELLOW}[FALTA]${NC}"
                ((category_missing++))
                ((MISSING_PACKAGES++))
            fi
        done
    fi
    
    # Resumen de categoría
    echo
    echo -e "${CYAN}Resumen $category_name:${NC}"
    echo -e "  ${GREEN}Instalados: $category_installed${NC}"
    echo -e "  ${RED}Faltantes: $category_missing${NC}"
    echo -e "  ${BLUE}Total: $category_total${NC}"
    echo
}

# Función para mostrar comandos de instalación para paquetes faltantes
show_install_commands() {
    if [[ $MISSING_PACKAGES -eq 0 ]]; then
        echo -e "${GREEN}🎉 ¡Todos los paquetes están instalados!${NC}"
        return
    fi
    
    print_header "COMANDOS DE INSTALACIÓN"
    echo -e "${YELLOW}Para instalar los paquetes faltantes:${NC}"
    echo
    
    echo -e "${CYAN}Opción 1 - Instalación completa rápida:${NC}"
    echo "pacman -S git base-devel greetd greetd-tuigreet hyprland xorg-xwayland kitty waybar wofi thunar pipewire pipewire-alsa pipewire-pulse pamixer ttf-nerd-fonts-symbols-mono ttf-font-awesome brightnessctl grim slurp mako firefox hypridle hyprlock hyprpaper wl-clipboard jq playerctl polkit-gnome blueman network-manager-applet udiskie libinput-gestures xdg-desktop-portal-hyprland xdg-desktop-portal mousepad htop wlogout gnome-control-center zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting fzf zoxide"
    echo "yay -S wofi-emoji"
    echo
    
    echo -e "${CYAN}Opción 2 - Por categorías:${NC}"
    echo "# Críticos:"
    echo "pacman -S git base-devel greetd greetd-tuigreet hyprland xorg-xwayland kitty waybar wofi thunar"
    echo
    echo "# Funcionales:"
    echo "pacman -S pipewire pipewire-alsa pipewire-pulse pamixer ttf-nerd-fonts-symbols-mono ttf-font-awesome brightnessctl grim slurp mako firefox hypridle hyprlock hyprpaper wl-clipboard jq playerctl polkit-gnome blueman network-manager-applet udiskie libinput-gestures xdg-desktop-portal-hyprland xdg-desktop-portal mousepad htop wlogout gnome-control-center"
    echo "yay -S wofi-emoji"
    echo
    echo "# Productividad:"
    echo "pacman -S zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting fzf zoxide"
    echo
}

# Función principal
main() {
    clear
    print_header "VERIFICADOR DE PAQUETES ARCH DOTFILES"
    echo -e "${CYAN}Verificando instalación de paquetes del sistema...${NC}"
    echo
    
    # Verificar dependencias del script
    if ! command -v pacman >/dev/null 2>&1; then
        echo -e "${RED}Error: pacman no encontrado. ¿Estás en Arch Linux?${NC}"
        exit 1
    fi
    
    # Informar sobre herramientas opcionales
    if ! command -v jq >/dev/null 2>&1; then
        echo -e "${YELLOW}Info: jq no encontrado - usando verificación básica${NC}"
        echo -e "${YELLOW}Para verificación completa: sudo pacman -S jq${NC}"
        echo
    fi
    
    if ! command -v yay >/dev/null 2>&1; then
        echo -e "${YELLOW}Info: yay no encontrado - algunos paquetes AUR no se verificarán correctamente${NC}"
        echo -e "${YELLOW}Para instalar yay: ver README.md${NC}"
        echo
    fi
    
    # Verificar archivos JSON
    local critical_json="$SYSTEM_DIR/packages-critical.json"
    local functional_json="$SYSTEM_DIR/packages-functional.json"
    local productivity_json="$SYSTEM_DIR/packages-productivity.json"
    
    # Verificar cada categoría
    verify_packages_from_json "$critical_json" "PAQUETES CRÍTICOS"
    verify_packages_from_json "$functional_json" "PAQUETES FUNCIONALES"  
    verify_packages_from_json "$productivity_json" "PAQUETES PRODUCTIVIDAD"
    
    # Resumen final
    print_header "RESUMEN GENERAL"
    echo -e "${GREEN}Paquetes instalados: $INSTALLED_PACKAGES${NC}"
    echo -e "${RED}Paquetes faltantes: $MISSING_PACKAGES${NC}"
    echo -e "${BLUE}Total verificados: $TOTAL_PACKAGES${NC}"
    
    local percentage=$((INSTALLED_PACKAGES * 100 / TOTAL_PACKAGES))
    echo -e "${PURPLE}Completitud del sistema: ${percentage}%${NC}"
    echo
    
    # Estado del sistema
    if [[ $percentage -ge 90 ]]; then
        echo -e "${GREEN}🟢 Sistema prácticamente completo${NC}"
    elif [[ $percentage -ge 70 ]]; then
        echo -e "${YELLOW}🟡 Sistema funcional, faltan algunas utilidades${NC}"
    elif [[ $percentage -ge 50 ]]; then
        echo -e "${YELLOW}🟠 Sistema básico, faltan componentes importantes${NC}"
    else
        echo -e "${RED}🔴 Sistema incompleto, faltan componentes críticos${NC}"
    fi
    echo
    
    # Mostrar comandos de instalación si es necesario
    show_install_commands
}

# Ejecutar script
main "$@"