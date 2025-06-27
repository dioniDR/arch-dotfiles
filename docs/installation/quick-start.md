# ⚡ Guía de Instalación Rápida

## Prerequisitos
- Arch Linux instalado y funcionando
- Conexión a internet
- Usuario con sudo

## Instalación de Una Línea
```bash
curl -sSL https://raw.githubusercontent.com/dioniDR/arch-dotfiles/main/scripts/quick-install.sh  < /dev/null |  bash
```

## Instalación Manual
```bash
# 1. Clonar repositorio
git clone https://github.com/dioniDR/arch-dotfiles.git ~/arch-dotfiles
cd ~/arch-dotfiles

# 2. Dar permisos
chmod +x scripts/*.sh

# 3. Instalación completa
./scripts/install.sh
```

## Post-Instalación
1. Logout y login nuevamente
2. Seleccionar Hyprland en el display manager
3. Verificar que Waybar aparece correctamente
4. Probar aplicaciones principales

## Verificación
```bash
# Verificar servicios
systemctl --user status waybar
pgrep hyprland

# Probar aplicaciones
code --version
firefox --version
```
