#!/bin/bash

echo "🔄 Recargando configuración de Hyprland..."

# Recargar configuración de Hyprland
hyprctl reload

echo "✅ Configuración recargada!"
echo ""
echo "📝 Cambios aplicados:"
echo "   • Diálogos de 'Open Files' (Claude): 800x600px, centrados"
echo "   • Diálogos de 'File Upload' (Firefox): 700x500px, centrados"
echo "   • Diálogos genéricos de archivos: 750x550px, centrados"
echo "   • Configuración de xdg-desktop-portal creada"
echo ""
echo "🧪 Para probar:"
echo "   1. Abre Claude Desktop y presiona el botón +"
echo "   2. Abre Firefox y sube un archivo"
echo "   3. Los diálogos deberían aparecer centrados y más pequeños"
echo ""
echo "🔍 Si necesitas ajustar los tamaños, edita:"
echo "   ~/.config/hypr/hyprland.conf (al final del archivo)"
