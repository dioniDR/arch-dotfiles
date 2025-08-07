#!/bin/bash
set -e

# Ruta base del repositorio
REPO_DIR=~/arch-dotfiles/system/preinstall

# Crear estructura de directorios
mkdir -p "$REPO_DIR/network"

# Exportar archivos de configuración básicos
[[ -f /etc/locale.conf ]] && cp /etc/locale.conf "$REPO_DIR/locale.conf" || echo "⚠️ No se encontró /etc/locale.conf"
[[ -f /etc/vconsole.conf ]] && cp /etc/vconsole.conf "$REPO_DIR/vconsole.conf" || echo "⚠️ No se encontró /etc/vconsole.conf"
[[ -f /etc/hostname ]] && cp /etc/hostname "$REPO_DIR/hostname.conf" || echo "⚠️ No se encontró /etc/hostname"

# Extraer zona horaria
if [[ -L /etc/localtime ]]; then
    readlink /etc/localtime > "$REPO_DIR/timezone.conf"
else
    echo "⚠️ No se encontró /etc/localtime o no es un enlace simbólico"
fi

# Copiar conexiones de red si existen
if [[ -d /etc/NetworkManager/system-connections ]]; then
    cp -r /etc/NetworkManager/system-connections/* "$REPO_DIR/network/"
    echo "✅ Configuración de red copiada"
else
    echo "⚠️ No se encontró configuración de NetworkManager"
fi

# Extraer layout del teclado de Hyprland si existe
HCONF="$HOME/.config/hypr/hyprland.conf"
if [[ -f "$HCONF" ]]; then
    grep -i "kb_layout" "$HCONF" > "$REPO_DIR/hyprland-keyboard.conf" || true
    echo "✅ Extraído kb_layout de Hyprland"
else
    echo "⚠️ No se encontró Hyprland config"
fi

echo "🎯 Configuraciones exportadas en: $REPO_DIR"
