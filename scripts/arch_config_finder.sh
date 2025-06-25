#!/bin/bash

# Script para identificar archivos de configuración importantes en Arch + Hyprland

echo "=== ARCHIVOS DE CONFIGURACIÓN IMPORTANTES ==="
echo ""

# Función para verificar si existe un archivo/directorio
check_config() {
    local path="$1"
    local description="$2"
    
    if [[ -e "$path" ]]; then
        echo "✅ $description"
        echo "   📁 $path"
        
        # Mostrar tamaño si es archivo, cantidad de archivos si es directorio
        if [[ -f "$path" ]]; then
            size=$(stat -c%s "$path")
            echo "   📊 Tamaño: ${size} bytes"
        elif [[ -d "$path" ]]; then
            count=$(find "$path" -type f 2>/dev/null | wc -l)
            echo "   📊 Archivos: ${count}"
        fi
        echo ""
    else
        echo "❌ $description"
        echo "   📁 $path (NO EXISTE)"
        echo ""
    fi
}

echo "🖥️  CONFIGURACIONES DEL SISTEMA:"
check_config "/etc/pacman.conf" "Configuración de Pacman"
check_config "/etc/makepkg.conf" "Configuración de compilación"
check_config "/etc/hosts" "Archivo hosts personalizado"
check_config "/etc/fstab" "Tabla de sistemas de archivos"

echo "🏠 CONFIGURACIONES DE USUARIO:"
check_config "$HOME/.config/hypr" "Configuración de Hyprland"
check_config "$HOME/.config/waybar" "Configuración de Waybar"
check_config "$HOME/.config/kitty" "Configuración de Kitty terminal"
check_config "$HOME/.config/alacritty" "Configuración de Alacritty"
check_config "$HOME/.config/rofi" "Configuración de Rofi/Wofi"
check_config "$HOME/.config/wofi" "Configuración de Wofi"
check_config "$HOME/.config/dunst" "Configuración de notificaciones Dunst"
check_config "$HOME/.config/mako" "Configuración de notificaciones Mako"

echo "🐚 CONFIGURACIONES DE SHELL:"
check_config "$HOME/.bashrc" "Configuración de Bash"
check_config "$HOME/.zshrc" "Configuración de Zsh"
check_config "$HOME/.config/fish" "Configuración de Fish"
check_config "$HOME/.profile" "Profile general"
check_config "$HOME/.xinitrc" "Configuración de X11"

echo "🎨 TEMAS Y APARIENCIA:"
check_config "$HOME/.gtkrc-2.0" "Temas GTK 2.0"
check_config "$HOME/.config/gtk-3.0" "Temas GTK 3.0"
check_config "$HOME/.config/gtk-4.0" "Temas GTK 4.0"
check_config "$HOME/.icons" "Iconos personalizados"
check_config "$HOME/.themes" "Temas personalizados"

echo "⚙️  HERRAMIENTAS DE DESARROLLO:"
check_config "$HOME/.gitconfig" "Configuración de Git"
check_config "$HOME/.config/Code/User" "Configuración de VS Code"
check_config "$HOME/.vimrc" "Configuración de Vim"
check_config "$HOME/.config/nvim" "Configuración de Neovim"

echo "🔧 APLICACIONES ESPECÍFICAS:"
check_config "$HOME/.config/discord" "Configuración de Discord"
check_config "$HOME/.config/firefox" "Perfiles de Firefox"
check_config "$HOME/.ssh" "Claves SSH"
check_config "$HOME/.gnupg" "Claves GPG"

echo "📦 LISTAS DE PAQUETES:"
echo "Generando lista de paquetes instalados..."

# Crear directorio temporal para listas
mkdir -p /tmp/arch_package_lists

# Paquetes oficiales
pacman -Qe > /tmp/arch_package_lists/pacman_explicit.txt
pacman -Qm > /tmp/arch_package_lists/aur_packages.txt

echo "✅ Lista de paquetes explícitos de pacman"
echo "   📁 /tmp/arch_package_lists/pacman_explicit.txt"
echo "   📊 Paquetes: $(wc -l < /tmp/arch_package_lists/pacman_explicit.txt)"
echo ""

echo "✅ Lista de paquetes de AUR"
echo "   📁 /tmp/arch_package_lists/aur_packages.txt"  
echo "   📊 Paquetes: $(wc -l < /tmp/arch_package_lists/aur_packages.txt)"
echo ""

echo "=== RESUMEN ==="
echo "Este script te ayuda a identificar qué configuraciones tienes."
echo "Los archivos marcados con ✅ existen y deberían incluirse en tu backup."
echo "Los archivos marcados con ❌ no existen en tu sistema."
echo ""
echo "💡 Sugerencia: Ejecuta este script y revisa qué configuraciones"
echo "   son importantes para tu flujo de trabajo específico."