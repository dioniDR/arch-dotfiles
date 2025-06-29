# 💻 Comandos Frecuentes

## Gestión del Proyecto Dotfiles

### Sincronización
```bash
# Aplicar cambios del proyecto al sistema
cp ~/arch-dotfiles/config/[app]/* ~/.config/[app]/

# Exportar configuración del sistema al proyecto
cp -r ~/.config/[app] ~/arch-dotfiles/config/

# Usar script de exportación automática
~/arch-dotfiles/scripts/export-personal.sh
```

### Git del Proyecto
```bash
# Estado del proyecto
cd ~/arch-dotfiles && git status

# Agregar cambios
git add .

# Commit con mensaje descriptivo
git commit -m "✨ Add new feature or 🐛 Fix bug"

# Ver historial
git log --oneline -10
```

## Hyprland

### Control de Ventanas
```bash
# Listar ventanas abiertas
hyprctl clients

# Información de la ventana activa
hyprctl activewindow

# Cerrar ventana por ID
hyprctl dispatch killactive

# Recargar configuración
hyprctl reload
```

### Workspaces
```bash
# Listar workspaces activos
hyprctl workspaces

# Cambiar a workspace
hyprctl dispatch workspace 1

# Información del monitor
hyprctl monitors
```

## Waybar

### Control del Proceso
```bash
# Reiniciar Waybar
killall waybar && waybar &

# Ver errores en tiempo real
waybar

# Verificar configuración
waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css
```

### Depuración
```bash
# Test de configuración JSON
jq . ~/.config/waybar/config

# Ver logs del sistema
journalctl -f | grep waybar
```

## Audio (PipeWire)

### Estado y Control
```bash
# Estado de PipeWire
systemctl --user status pipewire

# Reiniciar audio
systemctl --user restart pipewire pipewire-pulse

# Listar dispositivos de audio
pactl list sinks short
pactl list sources short

# Controlar volumen
pactl set-sink-volume @DEFAULT_SINK@ +5%
pactl set-sink-volume @DEFAULT_SINK@ -5%
pactl set-sink-mute @DEFAULT_SINK@ toggle
```

### Información Detallada
```bash
# Información completa de audio
inxi -A

# Procesos usando audio
lsof /dev/snd/*
```

## Sistema y Recursos

### Monitoreo
```bash
# Información del sistema
neofetch

# Procesos y recursos
htop
btop  # versión moderna

# Uso de disco
df -h
ncdu  # navegador de uso de disco

# Información de red
ip addr show
nmcli device status
```

### Servicios del Sistema
```bash
# Estado de servicios críticos
systemctl status NetworkManager
systemctl status bluetooth
systemctl --user status pipewire

# Logs del sistema
journalctl -f  # en tiempo real
journalctl -b  # desde el último boot
journalctl -u NetworkManager  # servicio específico
```

## Paquetes (Pacman/AUR)

### Búsqueda e Instalación
```bash
# Buscar paquete
pacman -Ss package_name
yay -Ss package_name  # incluye AUR

# Instalar paquete
sudo pacman -S package_name
yay -S package_name  # desde AUR

# Información de paquete
pacman -Qi package_name
pacman -Ql package_name  # archivos del paquete
```

### Mantenimiento
```bash
# Actualizar sistema
sudo pacman -Syu
yay -Syu  # incluye AUR

# Limpiar caché
sudo pacman -Sc
yay -Sc

# Paquetes huérfanos
pacman -Qtdq
sudo pacman -Rns $(pacman -Qtdq)  # remover huérfanos
```

## Desarrollo

### VS Code
```bash
# Abrir proyecto
code ~/arch-dotfiles/

# Instalar extensión
code --install-extension ms-vscode.vscode-json

# Ver extensiones instaladas
code --list-extensions
```

### Git Global
```bash
# Configuración rápida
git config --global user.name "dioni"
git config --global user.email "your@email.com"

# Ver configuración
git config --list

# Estados rápidos
git status -s  # formato corto
git log --oneline -5
git diff --stat
```

## Red y Conectividad

### NetworkManager
```bash
# Conectar WiFi
nmcli device wifi list
nmcli device wifi connect "SSID" password "password"

# Estado de conexiones
nmcli connection show
nmcli device status

# Información de IP
ip addr show
curl ifconfig.me  # IP pública
```

### Bluetooth
```bash
# Control básico
bluetoothctl

# Dentro de bluetoothctl:
# scan on
# pair XX:XX:XX:XX:XX:XX
# connect XX:XX:XX:XX:XX:XX
```

## Utilidades de Archivos

### Navegación Rápida
```bash
# Buscar archivos
find ~ -name "*.conf" -type f
fd "*.conf"  # versión moderna

# Buscar contenido
grep -r "search_term" ~/arch-dotfiles/
rg "search_term" ~/arch-dotfiles/  # ripgrep (más rápido)

# Árbol de directorios
tree ~/arch-dotfiles/ -L 2
```

### Operaciones Comunes
```bash
# Copiar manteniendo permisos
cp -a source/ destination/

# Mover múltiples archivos
mv *.txt ~/Documents/

# Crear backup con timestamp
cp important_file{,.bak.$(date +%Y%m%d)}
```