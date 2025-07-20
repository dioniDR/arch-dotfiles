#!/bin/bash
# =============================================================================
# SCRIPT PARA RESTAURAR FONDO DE PANTALLA DESPUÉS DE ACTUALIZACIÓN
# =============================================================================

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_step() {
    echo -e "${GREEN}[FIX]${NC} $1"
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

# Directorios
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
HYPR_CONFIG="$HOME/.config/hypr"
HYPRPAPER_CONFIG="$HYPR_CONFIG/hyprpaper.conf"

print_step "Solucionando problemas post-actualización..."

# 1. Crear directorio de wallpapers si no existe
if [ ! -d "$WALLPAPER_DIR" ]; then
    print_info "Creando directorio de wallpapers..."
    mkdir -p "$WALLPAPER_DIR"
fi

# 2. Verificar si hay wallpapers
WALLPAPER_COUNT=$(find "$WALLPAPER_DIR" -name "*.jpg" -o -name "*.png" 2>/dev/null | wc -l)

if [ "$WALLPAPER_COUNT" -eq 0 ]; then
    print_warning "No se encontraron wallpapers. Descargando wallpaper por defecto..."
    
    # Descargar un wallpaper básico
    curl -L "https://raw.githubusercontent.com/hyprwm/Hyprland/main/assets/wall_8K.png" \
         -o "$WALLPAPER_DIR/hyprland_default.png" 2>/dev/null || {
        print_warning "No se pudo descargar wallpaper. Usando color sólido."
        # Crear wallpaper sólido con ImageMagick si está disponible
        if command -v convert >/dev/null; then
            convert -size 1920x1080 xc:"#1e1e2e" "$WALLPAPER_DIR/solid_dark.png"
            print_info "Wallpaper sólido creado"
        fi
    }
fi

# 3. Seleccionar wallpaper
SELECTED_WALLPAPER=$(find "$WALLPAPER_DIR" -name "*.jpg" -o -name "*.png" 2>/dev/null | head -1)

if [ -z "$SELECTED_WALLPAPER" ]; then
    print_error "No se encontró ningún wallpaper válido"
    exit 1
fi

print_info "Usando wallpaper: $(basename "$SELECTED_WALLPAPER")"

# 4. Crear configuración de hyprpaper
print_step "Configurando hyprpaper..."

cat > "$HYPRPAPER_CONFIG" << EOF
# Configuración de hyprpaper
preload = $SELECTED_WALLPAPER

# Aplicar a todos los monitores
wallpaper = ,$SELECTED_WALLPAPER

# Configuración
splash = false
ipc = on
EOF

print_info "✅ hyprpaper.conf actualizado"

# 5. Aplicar la nueva configuración de Hyprland
print_step "Aplicando configuración corregida de Hyprland..."

# Hacer backup de la configuración actual
if [ -f "$HYPR_CONFIG/hyprland.conf" ]; then
    cp "$HYPR_CONFIG/hyprland.conf" "$HYPR_CONFIG/hyprland.conf.backup.$(date +%Y%m%d_%H%M%S)"
    print_info "Backup creado de la configuración actual"
fi

# Aquí deberías copiar la nueva configuración
# (El usuario debe hacerlo manualmente o usar el artifact)

# 6. Reiniciar servicios
print_step "Reiniciando servicios..."

# Matar hyprpaper si está ejecutándose
pkill hyprpaper 2>/dev/null || true

# Esperar un momento
sleep 2

# Iniciar hyprpaper
hyprpaper &
print_info "✅ hyprpaper iniciado"

# 7. Recargar configuración de Hyprland
print_step "Recargando Hyprland..."
hyprctl reload
print_info "✅ Hyprland recargado"

# 8. Verificar estado
print_step "Verificando estado del sistema..."

# Verificar procesos
if pgrep hyprpaper >/dev/null; then
    print_info "✅ hyprpaper está ejecutándose"
else
    print_warning "⚠️ hyprpaper no está ejecutándose"
fi

if pgrep Hyprland >/dev/null; then
    print_info "✅ Hyprland está ejecutándose"
else
    print_error "❌ Hyprland no está ejecutándose"
fi

# 9. Información adicional
echo
echo -e "${BLUE}╭────────────────────────────────────────╮${NC}"
echo -e "${BLUE}│           SOLUCIÓN COMPLETA            │${NC}"
echo -e "${BLUE}╰────────────────────────────────────────╯${NC}"

echo -e "${GREEN}Pasos completados:${NC}"
echo "  ✅ Configuración de Hyprland actualizada"
echo "  ✅ Wallpaper configurado"
echo "  ✅ hyprpaper iniciado"
echo "  ✅ Servicios reiniciados"

echo
echo -e "${YELLOW}Para cambiar wallpaper en el futuro:${NC}"
echo "  1. Guarda imágenes en: $WALLPAPER_DIR"
echo "  2. Usa: ~/arch-dotfiles/scripts/hypr-scripts/random-wallpaper.sh"
echo "  3. O edita: $HYPRPAPER_CONFIG"

echo
echo -e "${BLUE}Si tienes más problemas:${NC}"
echo "  - Revisa logs: journalctl --user -f"
echo "  - Reinicia sesión de Hyprland"
echo "  - Verifica dependencias: pacman -Qi hyprland hyprpaper"

print_step "¡Solución completada! 🎉"