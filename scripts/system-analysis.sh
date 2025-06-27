#!/bin/bash
# =============================================================================
# Script de análisis completo del sistema
# Genera reportes detallados para documentar la configuración actual
# =============================================================================

echo "🔍 Iniciando análisis completo del sistema..."

# Crear directorio de análisis si no existe
mkdir -p out/analysis

# Análisis de configuraciones existentes
echo "📁 Analizando archivos de configuración..."
find ~/.config -type f -name "*.conf" -o -name "*.json" -o -name "*.css" -o -name "*.ini" > out/analysis/config-files-found.txt

# Análisis de aplicaciones instaladas
echo "📦 Analizando paquetes instalados..."
pacman -Q > out/analysis/all-packages.txt
pacman -Qe > out/analysis/explicit-packages.txt
pacman -Qm > out/analysis/aur-packages.txt

# Análisis de servicios activos
echo "⚙️ Analizando servicios del sistema..."
systemctl --user list-units --state=running > out/analysis/user-services.txt
systemctl list-units --state=running --type=service > out/analysis/system-services.txt

# Análisis de configuraciones importantes
echo "🏠 Analizando estructura de directorios..."
ls -la ~/.config/ > out/analysis/config-directories.txt
ls -la ~/ | grep "^\." > out/analysis/home-dotfiles.txt

# Hardware info
echo "💻 Recopilando información de hardware..."
lscpu > out/analysis/cpu-info.txt
lsmem > out/analysis/memory-info.txt 2>/dev/null || echo "lsmem no disponible" > out/analysis/memory-info.txt
lspci > out/analysis/hardware-pci.txt
lsusb > out/analysis/hardware-usb.txt

echo "✅ Análisis completo guardado en out/analysis/"
echo "📊 Archivos generados:"
ls -la out/analysis/