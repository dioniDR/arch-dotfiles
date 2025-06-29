#!/bin/bash
# Sistema de navegación para arch-dotfiles

detect_status() {
    WAYBAR_STATUS=$(pgrep waybar &>/dev/null && echo "🟢" || echo "🔴")
    HYPRLAND_STATUS=$(pgrep Hyprland &>/dev/null && echo "🟢" || echo "🔴")
    CONFIG_COUNT=$(find config/ -type f 2>/dev/null | wc -l)
    GIT_MODIFIED=$(git status --porcelain 2>/dev/null | wc -l)
    COMPLETION=75
}

case "${1:-?}" in
    "?"|"help")
        detect_status
        echo "🧭 ARCH DOTFILES PROJECT"
        echo "========================"
        echo "📍 Directorio: $(pwd)"
        echo "📊 Estado: ${COMPLETION}% completo"
        echo "⚙️ Servicios: Waybar $WAYBAR_STATUS | Hyprland $HYPRLAND_STATUS"
        echo "📁 Configuraciones: $CONFIG_COUNT archivos"
        echo "📝 Git: $GIT_MODIFIED archivos modificados"
        echo ""
        echo "🎯 PRÓXIMOS PASOS:"
        echo "1. Optimizar configuración de audio"
        echo "2. Documentar configuraciones avanzadas"
        echo "3. Crear sistema de backup automático"
        echo ""
        echo "💡 COMANDOS RÁPIDOS:"
        echo "  ./scripts/export-personal.sh    # Actualizar README"
        echo "  killall waybar && waybar &      # Recargar Waybar"
        echo "  ./nav.sh status                 # Estado detallado"
        echo "  code .                          # Abrir en VS Code"
        ;;
    "status")
        detect_status
        echo "📊 ESTADO DETALLADO DEL PROYECTO"
        echo "================================"
        echo "🖥️ Hardware: AMD Ryzen AI 9 365 (20 cores), 23GB RAM"
        echo "⚙️ Servicios:"
        echo "  - Waybar: $WAYBAR_STATUS"
        echo "  - Hyprland: $HYPRLAND_STATUS"
        echo "  - GitHub CLI: $(gh auth status &>/dev/null && echo "✅" || echo "❌")"
        echo ""
        echo "📁 Configuraciones en repo: $CONFIG_COUNT archivos"
        echo "🔧 Configuraciones implementadas:"
        echo "  - Hyprland: ✅ Window manager con animaciones"
        echo "  - Waybar: ✅ Barra con módulos de rendimiento"
        echo "  - Wofi: ✅ Launcher con transparencias"
        echo "  - Warp Terminal: ✅ Configurado"
        echo "  - GitHub CLI: ✅ Autenticado"
        echo ""
        echo "📝 Git status: $GIT_MODIFIED archivos modificados"
        [[ $GIT_MODIFIED -gt 0 ]] && echo "   💡 Ejecuta: git add . && git commit"
        ;;
    "quick")
        echo "⚡ COMANDOS MÁS FRECUENTES:"
        echo "=========================="
        echo "📝 ./scripts/export-personal.sh    # Actualizar README"
        echo "🔄 killall waybar && waybar &      # Recargar desktop"
        echo "📦 git add . && git commit          # Versionar cambios"
        echo "🚀 code .                          # Abrir VS Code"
        echo "🆘 F1                              # Sistema de ayuda"
        ;;
    *)
        echo "📋 NAVEGACIÓN ARCH DOTFILES"
        echo "=========================="
        echo "Uso: ./nav.sh [opción]"
        echo ""
        echo "Opciones:"
        echo "  ?        Estado general y próximos pasos"
        echo "  status   Estado detallado completo"
        echo "  quick    Comandos más frecuentes"
        echo "  help     Esta ayuda"
        ;;
esac