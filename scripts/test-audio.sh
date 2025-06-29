#!/bin/bash
# =============================================================================
# TEST DE CONFIGURACIÓN DE AUDIO AMD RYZEN AI 9 365
# Script para verificar la configuración optimizada de audio
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "╭─────────────────────────────────────────────╮"
    echo "│           TEST DE AUDIO AMD                 │"
    echo "│        Ryzen AI 9 365 + Radeon 880M        │"
    echo "╰─────────────────────────────────────────────╯"
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}[TEST]${NC} $1"
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

# Test 1: Verificar sistema de audio
test_audio_system() {
    print_step "Verificando sistema de audio..."
    
    # Verificar PipeWire
    if pgrep pipewire >/dev/null; then
        print_info "✅ PipeWire está ejecutándose"
    else
        print_error "❌ PipeWire no está ejecutándose"
        return 1
    fi
    
    # Verificar PulseAudio
    if pactl info >/dev/null 2>&1; then
        SERVER_INFO=$(pactl info | grep "Server Name\|Server Version")
        print_info "✅ PulseAudio disponible:"
        echo "$SERVER_INFO" | while read line; do
            print_info "   $line"
        done
    else
        print_error "❌ PulseAudio no disponible"
        return 1
    fi
}

# Test 2: Verificar dispositivos de audio
test_audio_devices() {
    print_step "Verificando dispositivos de audio..."
    
    # Sinks (salidas)
    print_info "🔊 Dispositivos de salida:"
    pactl list short sinks | while read line; do
        print_info "   $line"
    done
    
    # Sources (entradas)
    print_info "🎤 Dispositivos de entrada:"
    pactl list short sources | while read line; do
        print_info "   $line"
    done
}

# Test 3: Verificar configuración de latencia
test_latency_config() {
    print_step "Verificando configuración de latencia..."
    
    # Obtener especificación de muestra por defecto
    DEFAULT_SPEC=$(pactl stat | grep "Default Sample Specification" | cut -d: -f2 | xargs)
    if [[ "$DEFAULT_SPEC" == "float32le 2ch 48000Hz" ]]; then
        print_info "✅ Configuración óptima: $DEFAULT_SPEC"
    else
        print_warning "⚠️  Configuración actual: $DEFAULT_SPEC"
        print_info "   Recomendado: float32le 2ch 48000Hz"
    fi
    
    # Verificar fragmentos y latencia
    if [[ -f ~/.config/pulse/daemon.conf ]]; then
        FRAGMENTS=$(grep "default-fragments" ~/.config/pulse/daemon.conf | cut -d= -f2 | xargs)
        FRAGMENT_SIZE=$(grep "default-fragment-size-msec" ~/.config/pulse/daemon.conf | cut -d= -f2 | xargs)
        print_info "✅ Fragmentos configurados: $FRAGMENTS x ${FRAGMENT_SIZE}ms"
    fi
}

# Test 4: Test de reproducción
test_audio_playback() {
    print_step "Test de reproducción de audio..."
    
    # Verificar que hay dispositivos disponibles
    SINK_COUNT=$(pactl list short sinks | wc -l)
    if [[ $SINK_COUNT -gt 0 ]]; then
        print_info "✅ $SINK_COUNT dispositivo(s) de salida disponible(s)"
        
        # Test de tono (opcional, solo si speaker-test está disponible)
        if command -v speaker-test >/dev/null; then
            print_info "🔊 Ejecutando test de 2 segundos..."
            timeout 2s speaker-test -c 2 -l 1 >/dev/null 2>&1 && \
                print_info "✅ Test de audio completado" || \
                print_warning "⚠️  Test de audio falló (normal si no hay altavoces)"
        else
            print_info "ℹ️  speaker-test no disponible, saltando test de reproducción"
        fi
    else
        print_error "❌ No hay dispositivos de salida disponibles"
        return 1
    fi
}

# Test 5: Verificar configuraciones específicas AMD
test_amd_config() {
    print_step "Verificando configuraciones específicas para AMD..."
    
    # Verificar archivo daemon.conf
    if [[ -f ~/arch-dotfiles/config/pulse/daemon.conf ]]; then
        print_info "✅ daemon.conf optimizado encontrado"
        
        # Verificar configuraciones clave
        if grep -q "realtime-scheduling = yes" ~/arch-dotfiles/config/pulse/daemon.conf; then
            print_info "✅ Scheduling en tiempo real habilitado"
        fi
        
        if grep -q "float32le" ~/arch-dotfiles/config/pulse/daemon.conf; then
            print_info "✅ Formato float32le configurado"
        fi
        
        if grep -q "nice-level = -15" ~/arch-dotfiles/config/pulse/daemon.conf; then
            print_info "✅ Prioridad alta configurada"
        fi
    else
        print_warning "⚠️  daemon.conf optimizado no encontrado"
    fi
    
    # Verificar configuración PipeWire
    if [[ -f ~/arch-dotfiles/config/pipewire/pipewire.conf ]]; then
        print_info "✅ pipewire.conf optimizado encontrado"
    else
        print_warning "⚠️  pipewire.conf optimizado no encontrado"
    fi
}

# Función principal
main() {
    print_header
    
    local tests_passed=0
    local total_tests=5
    
    # Ejecutar tests
    test_audio_system && ((tests_passed++)) || true
    test_audio_devices && ((tests_passed++)) || true
    test_latency_config && ((tests_passed++)) || true
    test_audio_playbook && ((tests_passed++)) || true
    test_amd_config && ((tests_passed++)) || true
    
    echo
    echo -e "${BLUE}╭────────────────────────────────────╮${NC}"
    echo -e "${BLUE}│             RESUMEN                │${NC}"
    echo -e "${BLUE}╰────────────────────────────────────╯${NC}"
    
    if [[ $tests_passed -eq $total_tests ]]; then
        echo -e "${GREEN}🎉 TODOS LOS TESTS PASARON (${tests_passed}/${total_tests})${NC}"
        echo "✅ Audio optimizado para AMD Ryzen AI 9 365"
    elif [[ $tests_passed -gt 2 ]]; then
        echo -e "${YELLOW}⚠️  PARCIALMENTE CONFIGURADO (${tests_passed}/${total_tests})${NC}"
        echo "🔧 Algunas optimizaciones pendientes"
    else
        echo -e "${RED}❌ CONFIGURACIÓN INCOMPLETA (${tests_passed}/${total_tests})${NC}"
        echo "🚨 Revisar configuración de audio"
    fi
    
    echo
    echo -e "${BLUE}Comandos útiles:${NC}"
    echo "  pactl info                    # Info del servidor"
    echo "  pactl list short sinks        # Dispositivos de salida"
    echo "  pactl stat                    # Estadísticas"
    echo "  journalctl --user -u pipewire # Logs de PipeWire"
}

# Verificar dependencias
if ! command -v pactl >/dev/null; then
    print_error "pactl no encontrado. Instalar: sudo pacman -S pulseaudio-utils"
    exit 1
fi

main "$@"