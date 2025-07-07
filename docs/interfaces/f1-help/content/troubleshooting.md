# 🔧 Soluciones Rápidas

## Problemas Comunes de Hyprland

### Hyprland no inicia
```bash
# Ver errores de Hyprland
cat ~/.local/share/hyprland/hyprland.log

# Reiniciar desde TTY
sudo systemctl restart display-manager

# Configuración mínima de emergencia
cp ~/arch-dotfiles/config/hypr/hyprland.conf.backup ~/.config/hypr/hyprland.conf
```

### Ventanas no responden
```bash
# Forzar cierre de ventana
hyprctl dispatch killactive

# Listar y cerrar proceso específico
ps aux | grep [app_name]
kill -9 [PID]

# Reiniciar Hyprland sin cerrar sesión
hyprctl dispatch exit
```

## Problemas de Waybar

### Waybar no aparece
```bash
# Verificar que no esté ejecutándose
killall waybar

# Iniciar con debug
waybar -l debug

# Verificar configuración JSON
jq . ~/.config/waybar/config
```

### Módulos no funcionan
```bash
# Probar configuración básica
waybar -c ~/arch-dotfiles/.help-system/assets/waybar-minimal.json

# Ver permisos de scripts
ls -la ~/.config/waybar/scripts/
chmod +x ~/.config/waybar/scripts/*
```

## Audio (PipeWire)

### No hay sonido
```bash
# Reiniciar servicios de audio
systemctl --user restart pipewire pipewire-pulse wireplumber

# Verificar tarjeta de audio
lspci | grep -i audio
aplay -l

# Configurar tarjeta por defecto
pactl set-default-sink [sink_name]
```

### Audio distorsionado
```bash
# Verificar sample rate
pactl info | grep "Default Sample"

# Ajustar buffer
echo "default-sample-rate = 44100" >> ~/.config/pulse/daemon.conf
systemctl --user restart pipewire-pulse
```

### Micrófono no funciona
```bash
# Listar fuentes de audio
pactl list sources short

# Configurar ganancia del micrófono
pactl set-source-volume [source_name] 80%

# Test de micrófono
arecord -f cd -t wav -d 5 test.wav && aplay test.wav
```

## Red y Conectividad

### WiFi no conecta
```bash
# Reiniciar NetworkManager
sudo systemctl restart NetworkManager

# Verificar tarjeta WiFi
lspci | grep -i wireless
ip link show

# Reconectar manualmente
nmcli device wifi rescan
nmcli device wifi connect "SSID" password "password"
```

### Internet lento
```bash
# Test de velocidad
speedtest-cli

# Verificar DNS
nslookup google.com
ping -c 4 8.8.8.8

# Cambiar DNS
nmcli connection modify [connection_name] ipv4.dns "8.8.8.8,8.8.4.4"
```

## Bluetooth

### Dispositivo no se conecta
```bash
# Reiniciar Bluetooth
sudo systemctl restart bluetooth

# Reset del stack Bluetooth
sudo rmmod btusb && sudo modprobe btusb

# Limpiar cache de emparejamientos
sudo rm -rf /var/lib/bluetooth/*/
sudo systemctl restart bluetooth
```

## Rendimiento

### Sistema lento
```bash
# Verificar uso de CPU/RAM
htop
iotop  # uso de disco

# Procesos que más consumen
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10

# Limpiar cache del sistema
sudo sync && sudo sysctl vm.drop_caches=3
```

### Espacio en disco
```bash
# Verificar espacio
df -h

# Encontrar archivos grandes
find ~ -type f -size +100M
ncdu ~

# Limpiar cache de pacman
sudo pacman -Sc
```

## VS Code

### Extensiones no cargan
```bash
# Reinstalar extensiones problemáticas
code --uninstall-extension [extension-id]
code --install-extension [extension-id]

# Reset de configuración
mv ~/.config/Code/User/settings.json{,.backup}
```

### Claude Code no funciona
```bash
# Verificar autenticación
claude auth status

# Re-autenticar
claude auth login

# Verificar conexión
curl -I https://api.anthropic.com
```

## Terminal (Kitty)

### Fuentes no se ven bien
```bash
# Listar fuentes disponibles
fc-list | grep -i mono

# Regenerar cache de fuentes
fc-cache -fv

# Test de fuentes
kitty +kitten choose-fonts
```

## Emergencias

### Sistema no bootea
```bash
# Desde USB live de Arch:
# Montar particiones
mount /dev/sdaX /mnt
arch-chroot /mnt

# Regenerar GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Verificar fstab
cat /etc/fstab
```

### Pantalla negra
```bash
# Cambiar a TTY
Ctrl + Alt + F2

# Verificar driver gráfico
lspci -k | grep -A 2 -i vga

# Reiniciar servicio gráfico
sudo systemctl restart display-manager
```

### Recuperar configuración
```bash
# Restaurar desde backup
cp ~/arch-dotfiles/config/hypr/* ~/.config/hypr/
cp ~/arch-dotfiles/config/waybar/* ~/.config/waybar/

# O usar script de restauración
~/arch-dotfiles/scripts/restore-config.sh
```

## Comandos de Emergencia

### Reset rápido de servicios
```bash
# Script de emergencia
#!/bin/bash
killall waybar
killall wofi
systemctl --user restart pipewire
hyprctl reload
waybar &
```

### Información del sistema
```bash
# Diagnóstico completo
inxi -Fxxxz

# Logs críticos
journalctl -p err -b
dmesg | grep -i error
```

### Backup rápido
```bash
# Backup de configuraciones críticas
tar -czf ~/config-backup-$(date +%Y%m%d).tar.gz ~/.config/{hypr,waybar,kitty}

# Restore
tar -xzf ~/config-backup-*.tar.gz -C ~/
```