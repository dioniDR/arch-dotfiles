# 📋 Checklist de Instalación Arch + Hyprland

## 🎯 **FASE 1: Instalación Base de Arch**

### ✅ **Sistema Base**
- [ ] Arrancar desde USB live de Arch
- [ ] Configurar particiones (EFI + Root + Home)
- [ ] Instalar sistema base: `pacstrap /mnt base linux linux-firmware`
- [ ] Configurar fstab: `genfstab -U /mnt >> /mnt/etc/fstab`
- [ ] Chroot al sistema: `arch-chroot /mnt`

### ✅ **Configuración Sistema**
- [ ] Configurar timezone: `ln -sf /usr/share/zoneinfo/Region/City /etc/localtime`
- [ ] Generar hwclock: `hwclock --systohc`
- [ ] **Configurar locale (CRÍTICO)**:
  ```bash
  # Editar /etc/locale.gen y descomentar:
  en_US.UTF-8 UTF-8
  # Generar locales
  locale-gen
  # Configurar sistema
  echo 'LANG=en_US.UTF-8' > /etc/locale.conf
  ```
- [ ] **Configurar teclado (CRÍTICO)**:
  ```bash
  echo 'KEYMAP=us' > /etc/vconsole.conf
  ```
- [ ] Configurar hostname: `echo 'nombre-host' > /etc/hostname`
- [ ] Configurar usuarios y contraseñas
- [ ] Instalar bootloader (GRUB/systemd-boot)

---

## 🎯 **FASE 2: Post-Instalación (Primer Boot)**

### ✅ **Conectividad y Servicios Base**
- [ ] Habilitar NetworkManager: `systemctl enable NetworkManager`
- [ ] Conectar a internet
- [ ] Actualizar sistema: `pacman -Syu`

### ✅ **Usuario y Permisos**
- [ ] Crear usuario principal: `useradd -m -G wheel,audio,video,optical,storage,input usuario`
- [ ] Configurar sudo: `visudo` (descomentar %wheel)
- [ ] **Verificar grupo input**: `groups usuario | grep input`

### ✅ **Paquetes Esenciales**
```bash
# Instalar paquetes críticos
pacman -S git yay base-devel
```

---

## 🎯 **FASE 3: Entorno Gráfico Wayland (Solo lo necesario)**

### ✅ **Display Manager**
- [ ] Instalar greetd: `pacman -S greetd greetd-tuigreet`
- [ ] Configurar greetd:
  ```bash
  cat > /etc/greetd/config.toml << 'EOF'
  [terminal]
  vt = 1
  [default_session]
  command = "tuigreet --cmd Hyprland --time --asterisks --user-menu"
  user = "usuario"
  EOF
  ```
- [ ] Habilitar greetd: `systemctl enable greetd`
- [ ] Configurar target: `systemctl set-default graphical.target`

### ✅ **Hyprland y Dependencias Mínimas**
- [ ] Instalar Hyprland: `pacman -S hyprland`
- [ ] **Solo xwayland para compatibilidad**: `pacman -S xorg-xwayland`
- [ ] **⚠️ NO INSTALAR**: Evitar grupos gnome, kde, xorg-server, gdm, sddm

### ✅ **Aplicaciones Esenciales (Instalación Mínima)**
- [ ] Terminal: `pacman -S kitty`
- [ ] Barra de estado: `pacman -S waybar`  
- [ ] Launcher: `pacman -S wofi`
- [ ] Gestor de archivos: `pacman -S thunar`
- [ ] Audio base: `pacman -S pipewire pipewire-alsa pipewire-pulse pamixer`

### ✅ **Dependencias Críticas (OBLIGATORIAS)**
- [ ] **Fuentes para iconos**: 
  ```bash
  pacman -S ttf-nerd-fonts-symbols-mono ttf-font-awesome
  ```
- [ ] **Control de brillo**: `pacman -S brightnessctl`
- [ ] **Screenshots**: `pacman -S grim slurp`
- [ ] **Notificaciones**: `pacman -S mako`

### ✅ **⚠️ EVITAR EN INSTALACIÓN LIMPIA**
```bash
# NO instalar estos paquetes (fueron problemáticos):
# - gnome (grupo completo)
# - gdm, sddm, lightdm (otros display managers)
# - xorg-server, xorg-server-common (servidor X11 completo)
# - xf86-input-libinput (driver X11)
# - xorg-fonts-encodings (fuentes X11)
```

---

## 🎯 **FASE 4: Configuraciones Personalizadas**

### ✅ **Clonar Dotfiles**
- [ ] Clonar repositorio: `git clone https://github.com/usuario/arch-dotfiles.git`
- [ ] Mover a ubicación correcta: `mv arch-dotfiles /home/usuario/`
- [ ] Cambiar ownership: `chown -R usuario:usuario /home/usuario/arch-dotfiles`

### ✅ **Aplicar Configuraciones**
- [ ] Crear directorios: `mkdir -p ~/.config/{hypr,waybar,wofi,kitty}`
- [ ] **Verificar symlinks existentes**:
  ```bash
  ls -la ~/.config/hypr
  ls -la ~/.config/waybar
  ```
- [ ] Si no hay symlinks, copiar configs:
  ```bash
  cp -r arch-dotfiles/config/* ~/.config/
  ```

### ✅ **Script de Audio Waybar**
- [ ] Crear directorio: `mkdir -p ~/.config/waybar/scripts/`
- [ ] Crear script de audio:
  ```bash
  cat > ~/.config/waybar/scripts/audio-detector.sh << 'EOF'
  #!/bin/bash
  VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
  MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o 'yes')
  if [ "$MUTED" = "yes" ]; then
      echo '{"text":"󰸈 Muted","tooltip":"Audio muted","class":"muted"}'
  else
      if [ "$VOLUME" -ge 70 ]; then ICON="󰕾"
      elif [ "$VOLUME" -ge 30 ]; then ICON="󰖀"
      else ICON="󰕿"; fi
      echo "{\"text\":\"$ICON $VOLUME%\",\"tooltip\":\"Volume: $VOLUME%\",\"class\":\"normal\"}"
  fi
  EOF
  chmod +x ~/.config/waybar/scripts/audio-detector.sh
  ```

---

## 🎯 **FASE 5: Verificación y Testing**

### ✅ **Verificación del Sistema**
- [ ] Reiniciar sistema
- [ ] **Login funciona** con usuario y contraseña
- [ ] **Hyprland inicia** correctamente
- [ ] **Waybar muestra iconos** (fuentes cargadas)
- [ ] **Wofi funciona**: `Super + R`
- [ ] **Control de brillo**: `F5/F6` o `Fn + F5/F6`

### ✅ **Testing de Funcionalidades**
- [ ] **Gestos touchpad**:
  - [ ] Scroll 2 dedos: ✅
  - [ ] 3 dedos izq/der: Cambio workspace ✅
  - [ ] Tap para click: ✅
- [ ] **Atajos de teclado**:
  - [ ] `Super + T`: Terminal
  - [ ] `Super + Q`: Cerrar ventana
  - [ ] `Super + R`: Wofi
  - [ ] `Super + F`: Fullscreen
- [ ] **Audio**: Subir/bajar volumen

### ✅ **Troubleshooting Común**
- [ ] **Si iconos no aparecen**: Reinstalar fuentes y recargar waybar
- [ ] **Si login falla**: Verificar teclado US y contraseñas
- [ ] **Si brillo no funciona**: Verificar brightnessctl instalado
- [ ] **Si touchpad no responde**: Verificar usuario en grupo input

---

## 🎯 **FASE 6: Verificación Final (Instalación Limpia)**

### ✅ **Verificación del Sistema Puro**
- [ ] **Solo Wayland funcionando**: `echo $XDG_SESSION_TYPE` (debe mostrar "wayland")
- [ ] **Solo greetd habilitado**: `systemctl is-enabled greetd` (debe mostrar "enabled")
- [ ] **No hay otros DM**: `systemctl is-enabled gdm sddm lightdm 2>/dev/null || echo "✅ Solo greetd"`
- [ ] **Mínimo X11**: `pacman -Qs xorg | wc -l` (debería ser ≤ 2 paquetes: xwayland + dependencias)

### ✅ **Testing de Funcionalidades**
- [ ] **Gestos touchpad**:
  - [ ] Scroll 2 dedos: ✅
  - [ ] 3 dedos izq/der: Cambio workspace ✅
  - [ ] Tap para click: ✅
- [ ] **Atajos de teclado**:
  - [ ] `Super + T`: Terminal
  - [ ] `Super + Q`: Cerrar ventana
  - [ ] `Super + R`: Wofi
  - [ ] `Super + F`: Fullscreen
- [ ] **Audio**: Subir/bajar volumen
- [ ] **Waybar muestra iconos** correctamente

### ✅ **Verificación de Integridad**
- [ ] `pacman -Dk` (sin errores de base de datos)
- [ ] Sistema arranca directo a Hyprland
- [ ] No hay conflictos entre display managers

---

## 🎯 **DIFERENCIAS: Instalación Limpia vs Troubleshooting**

### 🟢 **Instalación Limpia (Esta Guía)**
```bash
# Solo instalar lo necesario desde el inicio:
pacman -S greetd greetd-tuigreet hyprland xorg-xwayland
pacman -S kitty waybar wofi thunar 
pacman -S ttf-nerd-fonts-symbols-mono ttf-font-awesome brightnessctl
# ✅ Sistema limpio desde el inicio
```

### 🔴 **Troubleshooting (Lo que tuvimos que limpiar)**
```bash
# Problemas que evitamos en instalación limpia:
# ❌ gnome (grupo completo instalado)
# ❌ gdm (display manager conflictivo)  
# ❌ xorg-server (servidor X11 completo)
# ❌ usuarios innecesarios (greeter, build)
# ❌ keymap incorrecto (la-latin1)
# ❌ fuentes faltantes (iconos rotos)
```

---

## ⚠️ **ERRORES COMUNES Y SOLUCIONES**

### 🔧 **Login falla después de cambiar contraseña**
**Causa**: Keymap incorrecto (la-latin1 vs us)
**Solución**: 
```bash
echo 'KEYMAP=us' > /etc/vconsole.conf
loadkeys us
passwd usuario  # Cambiar con teclado US
```

### 🔧 **Iconos no aparecen en Waybar**
**Causa**: Fuentes Nerd Fonts faltantes
**Solución**:
```bash
pacman -S ttf-nerd-fonts-symbols-mono ttf-font-awesome
killall waybar && waybar &
```

### 🔧 **Script de audio en Waybar falla**
**Causa**: Archivo audio-detector.sh faltante
**Solución**: Crear script (ver FASE 4)

### 🔧 **Brillo F5/F6 no funciona**
**Causa**: brightnessctl no instalado
**Solución**: `pacman -S brightnessctl`

---

## 📋 **LISTA DE PAQUETES PARA INSTALACIÓN LIMPIA**

### **🔧 Sistema Base**
```bash
pacstrap /mnt base linux linux-firmware grub efibootmgr networkmanager base-devel git
```

### **🎨 Entorno Wayland Mínimo**
```bash
pacman -S hyprland xorg-xwayland greetd greetd-tuigreet
```

### **📱 Aplicaciones Principales**
```bash
pacman -S kitty waybar wofi thunar
```

### **🎵 Audio y Hardware**
```bash
pacman -S pipewire pipewire-alsa pipewire-pulse pamixer brightnessctl
```

### **🔤 Fuentes y Utilidades**
```bash
pacman -S ttf-nerd-fonts-symbols-mono ttf-font-awesome grim slurp mako
```

### **⛔ NO INSTALAR EN INSTALACIÓN LIMPIA**
```bash
# Evitar estos grupos/paquetes:
# ❌ gnome (todo el grupo)
# ❌ kde-plasma (todo el grupo)  
# ❌ xfce4 (todo el grupo)
# ❌ gdm, sddm, lightdm (otros display managers)
# ❌ xorg-server, xorg-server-common (servidor X11)
# ❌ xf86-input-* (drivers X11)
```

---

**✅ RESULTADO: Sistema Wayland puro con Hyprland desde el inicio, sin necesidad de limpieza posterior**