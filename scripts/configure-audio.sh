#!/bin/bash

# Script para configurar audio correctamente
# Uso: ./configure-audio.sh

echo "Configurando sistema de audio..."

# Configurar perfil duplex para micrófono + altavoces
pactl set-card-profile alsa_card.pci-0000_63_00.6 output:analog-stereo+input:analog-stereo

# Desactivar HDMI para evitar conflictos
pactl set-card-profile alsa_card.pci-0000_63_00.1 off

# Establecer dispositivos por defecto
pactl set-default-sink alsa_output.pci-0000_63_00.6.analog-stereo
pactl set-default-source alsa_input.pci-0000_63_00.6.analog-stereo

echo "✅ Configuración de audio completada:"
echo "   🔊 Salida: Speakers internos"
echo "   🎤 Entrada: Micrófono interno (silenciado por defecto)"
echo "   ❌ HDMI desactivado (evita conflictos)"

# Silenciar micrófono por defecto (se activa solo al grabar)
pactl set-source-mute alsa_input.pci-0000_63_00.6.analog-stereo 1

# Mostrar estado actual
echo ""
echo "📊 Estado actual del audio:"
pactl list sinks short
echo "--- SOURCES ---"
pactl list sources short