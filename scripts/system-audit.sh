#!/bin/bash

# Sistema de Auditoría Exhaustiva para Arch Linux
# Versión: 2.0
# Fecha: $(date +%Y-%m-%d)

set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Funciones de utilidad
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_section() {
    echo -e "\n${PURPLE}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════════════════${NC}"
}

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Función para obtener información del sistema
get_system_info() {
    log_section "📊 INFORMACIÓN DEL SISTEMA"
    
    echo -e "${CYAN}Hostname:${NC} $(hostname)"
    echo -e "${CYAN}Usuario:${NC} $(whoami)"
    echo -e "${CYAN}Fecha:${NC} $(date)"
    echo -e "${CYAN}Uptime:${NC} $(uptime -p)"
    echo -e "${CYAN}Kernel:${NC} $(uname -r)"
    echo -e "${CYAN}Arquitectura:${NC} $(uname -m)"
    
    if [ -f /etc/os-release ]; then
        echo -e "${CYAN}OS:${NC} $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
    fi
    
    echo -e "${CYAN}Shell:${NC} $SHELL"
    echo -e "${CYAN}Timezone:${NC} $(timedatectl show --property=Timezone --value)"
}

# Función para verificar hardware
check_hardware() {
    log_section "💻 INFORMACIÓN DE HARDWARE"
    
    # CPU
    if [ -f /proc/cpuinfo ]; then
        cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)
        cpu_cores=$(nproc)
        echo -e "${CYAN}CPU:${NC} $cpu_model"
        echo -e "${CYAN}Cores:${NC} $cpu_cores"
    fi
    
    # Memoria
    if [ -f /proc/meminfo ]; then
        total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        total_mem_gb=$((total_mem / 1024 / 1024))
        available_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        available_mem_gb=$((available_mem / 1024 / 1024))
        echo -e "${CYAN}Memoria Total:${NC} ${total_mem_gb}GB"
        echo -e "${CYAN}Memoria Disponible:${NC} ${available_mem_gb}GB"
    fi
    
    # Disco
    echo -e "${CYAN}Espacio en disco:${NC}"
    df -h / | tail -1 | awk '{print "  Root: " $3 " usado de " $2 " (" $5 " usado)"}'
    
    # GPU
    if command_exists lspci; then
        gpu_info=$(lspci | grep -i "vga\|3d\|display" | head -1)
        if [ -n "$gpu_info" ]; then
            echo -e "${CYAN}GPU:${NC} $gpu_info"
        fi
    fi
}

# Función para verificar servicios del sistema
check_services() {
    log_section "🔧 SERVICIOS DEL SISTEMA"
    
    # Servicios críticos
    critical_services=("systemd-networkd" "systemd-resolved" "dbus" "NetworkManager" "bluetooth")
    
    for service in "${critical_services[@]}"; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            log_success "$service está activo"
        else
            if systemctl list-unit-files --type=service | grep -q "^$service"; then
                log_warn "$service está instalado pero no activo"
            else
                log_info "$service no está instalado"
            fi
        fi
    done
    
    # Servicios fallidos
    failed_services=$(systemctl --failed --no-legend | wc -l)
    if [ "$failed_services" -gt 0 ]; then
        log_error "$failed_services servicios han fallado"
        systemctl --failed --no-legend | head -10
    else
        log_success "No hay servicios fallidos"
    fi
}

# Función para verificar red
check_network() {
    log_section "🌐 CONECTIVIDAD DE RED"
    
    # Interfaz de red
    if command_exists ip; then
        active_interfaces=$(ip link show | grep "state UP" | cut -d':' -f2 | xargs)
        if [ -n "$active_interfaces" ]; then
            log_success "Interfaces activas: $active_interfaces"
        else
            log_warn "No se encontraron interfaces activas"
        fi
    fi
    
    # Conectividad
    if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        log_success "Conectividad a internet funcional"
    else
        log_error "Sin conectividad a internet"
    fi
    
    # DNS
    if nslookup google.com >/dev/null 2>&1; then
        log_success "Resolución DNS funcional"
    else
        log_error "Problemas con resolución DNS"
    fi
    
    # Puertos abiertos
    if command_exists ss; then
        open_ports=$(ss -tuln | grep LISTEN | wc -l)
        log_info "$open_ports puertos en escucha"
    fi
}

# Función para verificar paquetes
check_packages() {
    log_section "📦 GESTIÓN DE PAQUETES"
    
    # Pacman
    if command_exists pacman; then
        installed_packages=$(pacman -Q | wc -l)
        log_info "$installed_packages paquetes instalados"
        
        # Paquetes huérfanos
        orphan_packages=$(pacman -Qtdq 2>/dev/null | wc -l)
        if [ "$orphan_packages" -gt 0 ]; then
            log_warn "$orphan_packages paquetes huérfanos encontrados"
        else
            log_success "No hay paquetes huérfanos"
        fi
        
        # Verificar actualizaciones
        if pacman -Qu >/dev/null 2>&1; then
            updates=$(pacman -Qu | wc -l)
            log_warn "$updates actualizaciones disponibles"
        else
            log_success "Sistema actualizado"
        fi
    fi
    
    # AUR helper
    if command_exists yay; then
        aur_packages=$(yay -Qm | wc -l)
        log_info "$aur_packages paquetes AUR instalados"
    elif command_exists paru; then
        aur_packages=$(paru -Qm | wc -l)
        log_info "$aur_packages paquetes AUR instalados"
    fi
}

# Función para verificar seguridad
check_security() {
    log_section "🔒 SEGURIDAD DEL SISTEMA"
    
    # Firewall
    if command_exists ufw; then
        ufw_status=$(ufw status | head -1)
        if echo "$ufw_status" | grep -q "active"; then
            log_success "UFW firewall activo"
        else
            log_warn "UFW firewall inactivo"
        fi
    elif command_exists iptables; then
        iptables_rules=$(iptables -L | grep -v "^Chain\|^target" | wc -l)
        if [ "$iptables_rules" -gt 0 ]; then
            log_info "Reglas iptables configuradas"
        else
            log_warn "No se encontraron reglas iptables"
        fi
    fi
    
    # SSH
    if systemctl is-active --quiet sshd; then
        log_info "SSH daemon activo"
        if [ -f /etc/ssh/sshd_config ]; then
            if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
                log_success "Login root por SSH deshabilitado"
            else
                log_warn "Login root por SSH podría estar habilitado"
            fi
        fi
    else
        log_info "SSH daemon inactivo"
    fi
    
    # Usuarios con sudo
    if [ -f /etc/sudoers ]; then
        sudo_users=$(grep -E "^%wheel|^%sudo" /etc/sudoers | wc -l)
        log_info "Grupos con privilegios sudo configurados: $sudo_users"
    fi
    
    # Verificar permisos críticos
    critical_files=("/etc/passwd" "/etc/shadow" "/etc/sudoers")
    for file in "${critical_files[@]}"; do
        if [ -f "$file" ]; then
            perms=$(stat -c "%a" "$file")
            case "$file" in
                "/etc/passwd") [ "$perms" = "644" ] && log_success "$file permisos correctos" || log_warn "$file permisos incorrectos ($perms)" ;;
                "/etc/shadow") [ "$perms" = "640" ] && log_success "$file permisos correctos" || log_warn "$file permisos incorrectos ($perms)" ;;
                "/etc/sudoers") [ "$perms" = "440" ] && log_success "$file permisos correctos" || log_warn "$file permisos incorrectos ($perms)" ;;
            esac
        fi
    done
}

# Función para verificar logs
check_logs() {
    log_section "📋 ANÁLISIS DE LOGS"
    
    # Errores recientes en journal
    if command_exists journalctl; then
        errors_today=$(journalctl --since today --priority=3 --no-pager | wc -l)
        if [ "$errors_today" -gt 0 ]; then
            log_warn "$errors_today errores encontrados hoy en el journal"
            echo "Últimos 5 errores:"
            journalctl --since today --priority=3 --no-pager | tail -5
        else
            log_success "No se encontraron errores en el journal hoy"
        fi
    fi
    
    # Verificar logs de autenticación
    if [ -f /var/log/auth.log ]; then
        failed_logins=$(grep "Failed password" /var/log/auth.log | wc -l)
        if [ "$failed_logins" -gt 0 ]; then
            log_warn "$failed_logins intentos de login fallidos"
        else
            log_success "No se encontraron intentos de login fallidos"
        fi
    fi
}

# Función para verificar performance
check_performance() {
    log_section "⚡ RENDIMIENTO DEL SISTEMA"
    
    # Load average
    load_avg=$(uptime | awk -F'load average:' '{print $2}' | xargs)
    log_info "Load average: $load_avg"
    
    # Procesos que más CPU consumen
    echo -e "${CYAN}Top 5 procesos por CPU:${NC}"
    ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "  %s: %.1f%%\n", $11, $3}'
    
    # Procesos que más memoria consumen
    echo -e "${CYAN}Top 5 procesos por memoria:${NC}"
    ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "  %s: %.1f%%\n", $11, $4}'
    
    # Swap usage
    if [ -f /proc/swaps ]; then
        swap_total=$(grep -v "^Filename" /proc/swaps | awk '{sum += $3} END {print sum}')
        swap_used=$(grep -v "^Filename" /proc/swaps | awk '{sum += $4} END {print sum}')
        if [ "$swap_total" -gt 0 ]; then
            swap_percent=$((swap_used * 100 / swap_total))
            log_info "Uso de swap: $swap_percent%"
        else
            log_info "No hay swap configurado"
        fi
    fi
}

# Función para verificar configuración específica de Arch
check_arch_specific() {
    log_section "🏛️ CONFIGURACIÓN ESPECÍFICA DE ARCH"
    
    # Verificar mirrors
    if [ -f /etc/pacman.d/mirrorlist ]; then
        active_mirrors=$(grep -v "^#" /etc/pacman.d/mirrorlist | grep "^Server" | wc -l)
        log_info "$active_mirrors mirrors activos configurados"
    fi
    
    # Verificar hooks de pacman
    if [ -d /etc/pacman.d/hooks ]; then
        hooks_count=$(ls -1 /etc/pacman.d/hooks/*.hook 2>/dev/null | wc -l)
        if [ "$hooks_count" -gt 0 ]; then
            log_info "$hooks_count hooks de pacman configurados"
        fi
    fi
    
    # Verificar configuración de makepkg
    if [ -f /etc/makepkg.conf ]; then
        if grep -q "^MAKEFLAGS=" /etc/makepkg.conf; then
            makeflags=$(grep "^MAKEFLAGS=" /etc/makepkg.conf | cut -d'=' -f2)
            log_info "MAKEFLAGS configurado: $makeflags"
        fi
    fi
}

# Función para verificar dotfiles
check_dotfiles() {
    log_section "🏠 DOTFILES Y CONFIGURACIÓN DE USUARIO"
    
    # Verificar archivos de configuración comunes
    config_files=(".bashrc" ".zshrc" ".vimrc" ".gitconfig" ".xinitrc")
    for file in "${config_files[@]}"; do
        if [ -f "$HOME/$file" ]; then
            log_success "$file encontrado"
        else
            log_info "$file no encontrado"
        fi
    done
    
    # Verificar directorio .config
    if [ -d "$HOME/.config" ]; then
        config_dirs=$(ls -1 "$HOME/.config" | wc -l)
        log_info "$config_dirs directorios en ~/.config"
    fi
    
    # Verificar si estamos en un repo git
    if [ -d ".git" ]; then
        log_success "Directorio actual es un repositorio git"
        git_status=$(git status --porcelain | wc -l)
        if [ "$git_status" -eq 0 ]; then
            log_success "Repositorio git limpio"
        else
            log_warn "$git_status archivos sin commitear"
        fi
    fi
}

# Función para generar recomendaciones
generate_recommendations() {
    log_section "💡 RECOMENDACIONES"
    
    echo -e "${YELLOW}Basado en la auditoría, considera las siguientes acciones:${NC}"
    
    # Verificar actualizaciones
    if command_exists pacman; then
        if pacman -Qu >/dev/null 2>&1; then
            echo -e "${CYAN}•${NC} Ejecutar 'sudo pacman -Syu' para actualizar el sistema"
        fi
    fi
    
    # Verificar paquetes huérfanos
    if command_exists pacman; then
        orphans=$(pacman -Qtdq 2>/dev/null | wc -l)
        if [ "$orphans" -gt 0 ]; then
            echo -e "${CYAN}•${NC} Ejecutar 'sudo pacman -Rns \$(pacman -Qtdq)' para limpiar paquetes huérfanos"
        fi
    fi
    
    # Verificar cache de pacman
    if [ -d /var/cache/pacman/pkg ]; then
        cache_size=$(du -sh /var/cache/pacman/pkg | cut -f1)
        echo -e "${CYAN}•${NC} Cache de pacman: $cache_size - considera limpiar con 'sudo pacman -Sc'"
    fi
    
    # Verificar journal logs
    if command_exists journalctl; then
        journal_size=$(journalctl --disk-usage 2>/dev/null | grep -o '[0-9.]*[A-Z]' | head -1)
        if [ -n "$journal_size" ]; then
            echo -e "${CYAN}•${NC} Tamaño del journal: $journal_size - considera limpiar con 'sudo journalctl --vacuum-time=4weeks'"
        fi
    fi
    
    echo -e "${CYAN}•${NC} Revisa los logs del sistema regularmente"
    echo -e "${CYAN}•${NC} Mantén backups de tus dotfiles en un repositorio git"
    echo -e "${CYAN}•${NC} Considera usar un firewall si no tienes uno activo"
}

# Función principal
main() {
    clear
    echo -e "${PURPLE}"
    echo "    ╔═══════════════════════════════════════════════════════════════════════════════╗"
    echo "    ║                        AUDITORÍA EXHAUSTIVA DEL SISTEMA                       ║"
    echo "    ║                              Arch Linux - v2.0                               ║"
    echo "    ╚═══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Verificar si se ejecuta como root
    if [ "$EUID" -eq 0 ]; then
        log_warn "Ejecutándose como root - algunas verificaciones pueden no ser precisas"
    fi
    
    # Ejecutar todas las verificaciones
    get_system_info
    check_hardware
    check_services
    check_network
    check_packages
    check_security
    check_logs
    check_performance
    check_arch_specific
    check_dotfiles
    generate_recommendations
    
    log_section "✅ AUDITORÍA COMPLETADA"
    echo -e "${GREEN}Auditoría del sistema completada exitosamente.${NC}"
    echo -e "${CYAN}Timestamp:${NC} $(date)"
    echo -e "${CYAN}Duración:${NC} $SECONDS segundos"
}

# Verificar dependencias básicas
check_dependencies() {
    missing_deps=()
    
    # Comandos básicos necesarios
    basic_commands=("awk" "grep" "cut" "wc" "head" "tail")
    
    for cmd in "${basic_commands[@]}"; do
        if ! command_exists "$cmd"; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Faltan dependencias básicas: ${missing_deps[*]}"
        exit 1
    fi
}

# Ejecutar verificación de dependencias y script principal
check_dependencies
main

# Guardar log si se especifica
if [ "${1:-}" = "--save-log" ]; then
    log_file="system-audit-$(date +%Y%m%d-%H%M%S).log"
    main > "$log_file" 2>&1
    echo "Log guardado en: $log_file"
fi