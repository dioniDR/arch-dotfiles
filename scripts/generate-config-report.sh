#!/bin/bash
echo "📊 REPORTE DE CONFIGURACIONES" > out/reports/config-report.md
echo "=============================" >> out/reports/config-report.md
echo "Generado: $(date)" >> out/reports/config-report.md
echo "" >> out/reports/config-report.md

echo "## 🖥️ Entorno de Escritorio" >> out/reports/config-report.md
echo "- **WM**: Hyprland $(hyprctl version | head -1)" >> out/reports/config-report.md
echo "- **Bar**: Waybar" >> out/reports/config-report.md
echo "- **Launcher**: Wofi" >> out/reports/config-report.md
echo "- **Terminal**: Kitty + Warp Terminal" >> out/reports/config-report.md
echo "- **Notifications**: Mako" >> out/reports/config-report.md
echo "" >> out/reports/config-report.md

echo "## 📦 Paquetes Instalados" >> out/reports/config-report.md
echo "- **Total**: $(pacman -Q | wc -l) paquetes" >> out/reports/config-report.md
echo "- **Explícitos**: $(pacman -Qe | wc -l) paquetes" >> out/reports/config-report.md
echo "- **AUR**: $(pacman -Qm | wc -l) paquetes" >> out/reports/config-report.md
echo "" >> out/reports/config-report.md

echo "## ⚙️ Configuraciones Activas" >> out/reports/config-report.md
for config in ~/.config/*/; do
    name=$(basename "$config")
    files=$(find "$config" -type f 2>/dev/null | wc -l)
    if [[ $files -gt 0 ]]; then
        echo "- **$name**: $files archivos" >> out/reports/config-report.md
    fi
done