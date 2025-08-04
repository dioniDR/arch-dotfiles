#!/bin/bash

echo "🔍 INFORMACIÓN DE VENTANAS ACTIVAS"
echo "=================================="
echo ""

echo "📋 Todas las ventanas abiertas:"
hyprctl clients | grep -E "(class|title|floating)" | head -20

echo ""
echo "🎯 Ventana activa actual:"
hyprctl activewindow

echo ""
echo "💡 Para identificar la clase exacta:"
echo "   1. Abre el diálogo de archivos"
echo "   2. Ejecuta: hyprctl activewindow"
echo "   3. Busca 'class:' y 'title:' en la salida"
echo ""
echo "🛠️ Si necesitas reglas específicas, usa esa información"
echo "   en ~/.config/hypr/hyprland.conf"
