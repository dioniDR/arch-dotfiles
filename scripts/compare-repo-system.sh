#!/bin/bash
echo "🔍 COMPARACIÓN REPO vs SISTEMA" > out/comparisons/repo-vs-system.txt
echo "=================================" >> out/comparisons/repo-vs-system.txt

echo -e "\n📁 CONFIGURACIONES EN REPO:" >> out/comparisons/repo-vs-system.txt
find config/ -type f >> out/comparisons/repo-vs-system.txt

echo -e "\n📁 CONFIGURACIONES EN SISTEMA:" >> out/comparisons/repo-vs-system.txt
find ~/.config -maxdepth 2 -type d | head -20 >> out/comparisons/repo-vs-system.txt

echo -e "\n❌ FALTANTES EN REPO:" >> out/comparisons/repo-vs-system.txt
for dir in ~/.config/*/; do
    dirname=$(basename "$dir")
    if [[ ! -d "config/$dirname" ]]; then
        echo "config/$dirname/ ($(ls "$dir" | wc -l) archivos)" >> out/comparisons/repo-vs-system.txt
    fi
done