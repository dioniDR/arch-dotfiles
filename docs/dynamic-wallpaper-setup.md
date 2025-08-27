# Sistema de Wallpapers Dinámicos para Hyprland

**Fecha:** 18 de Agosto, 2025  
**Objetivo:** Configurar wallpapers dinámicos que cambien automáticamente según la hora del día  
**Integración:** Hyprland + hyprpaper + dynamic-wallpaper  

## 📋 Resumen de Cambios

Se implementó un sistema completo de wallpapers dinámicos que:
- Cambia automáticamente cada hora según el tiempo del día
- Incluye 25+ colecciones de wallpapers de alta calidad
- Se integra perfectamente con Hyprland y hyprpaper
- Permite cambiar estilos fácilmente con un comando

## 🚀 Proceso de Implementación

### 1. Problema Inicial
- No había imagen de fondo en el sistema
- hyprpaper.conf apuntaba a un archivo inexistente: `/home/dioni/Pictures/Wallpapers/nature_02.jpg`
- `force_default_wallpaper = 0` deshabilitaba wallpapers por defecto

### 2. Solución Temporal
```properties
# En hyprland.conf
force_default_wallpaper = -1  # Habilitar wallpaper por defecto temporalmente
```

### 3. Implementación del Sistema Dynamic Wallpaper

#### 3.1 Clonación del Repositorio
```bash
cd /home/dioni/Pictures
gh repo clone adi1090x/dynamic-wallpaper
```

#### 3.2 Instalación del Sistema
```bash
cd /home/dioni/Pictures/dynamic-wallpaper
chmod +x install.sh
./install.sh
```

#### 3.3 Configuración de hyprpaper.conf
```properties
# Configuración de hyprpaper - Dynamic Wallpapers
preload = /home/dioni/Pictures/dynamic-wallpaper/images/firewatch/0.png

# Aplicar a todos los monitores
wallpaper = ,/home/dioni/Pictures/dynamic-wallpaper/images/firewatch/0.png

# Configuración
splash = false
ipc = on
```

#### 3.4 Actualización de hyprland.conf
```properties
# Misc settings
misc {
    force_default_wallpaper = 0          # Usa hyprpaper personalizado
    # ... otras configuraciones
}

# Autostart
exec-once = hyprpaper
exec-once = /home/dioni/.local/bin/dwall-hypr firewatch
```

## 📝 Scripts Creados

### 1. Script Principal: `/home/dioni/.local/bin/dwall-hypr`
```bash
#!/bin/bash
# Script personalizado para Dynamic Wallpaper con Hyprland
# Integración con hyprpaper

STYLE="${1:-firewatch}"
WALLPAPER_DIR="/usr/share/dynamic-wallpaper/images/$STYLE"

# Función para obtener el wallpaper según la hora
get_wallpaper_by_time() {
    local hour=$(date +%H)
    
    # Mapeo de horas a números de wallpaper (0-23)
    case $hour in
        06|07|08) echo "0.png" ;;     # Amanecer
        09|10|11) echo "1.png" ;;     # Mañana temprana  
        12|13|14) echo "2.png" ;;     # Mediodía
        15|16|17) echo "3.png" ;;     # Tarde
        18|19) echo "4.png" ;;        # Atardecer
        20|21) echo "5.png" ;;        # Anochecer
        22|23|00) echo "6.png" ;;     # Noche temprana
        01|02|03|04|05) echo "7.png" ;; # Noche tardía/Madrugada
        *) echo "0.png" ;;            # Default
    esac
}

# Lógica de aplicación del wallpaper...
```

### 2. Script de Cambio de Estilo: `/home/dioni/.local/bin/change-wallpaper-style`
```bash
#!/bin/bash
# Script para cambiar estilo de wallpaper dinámico

AVAILABLE_STYLES="aurora beach bitday chihuahuan cliffs colony desert earth exodus factory firewatch forest gradient home island lake lakeside market mojave moon mountains room sahara street tokyo"

# Lógica de validación y cambio de estilo...
```

## ⚙️ Servicios Systemd

### 1. Servicio: `/home/dioni/.config/systemd/user/dynamic-wallpaper.service`
```ini
[Unit]
Description=Dynamic Wallpaper Service
After=graphical-session.target

[Service]
Type=oneshot
ExecStart=/home/dioni/.local/bin/dwall-hypr firewatch
User=dioni
Environment=DISPLAY=:0
Environment=WAYLAND_DISPLAY=wayland-0
```

### 2. Timer: `/home/dioni/.config/systemd/user/dynamic-wallpaper.timer`
```ini
[Unit]
Description=Run Dynamic Wallpaper every hour
Requires=dynamic-wallpaper.service

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
```

### 3. Habilitación del Timer
```bash
systemctl --user daemon-reload
systemctl --user enable dynamic-wallpaper.timer
systemctl --user start dynamic-wallpaper.timer
```

## 🎨 Estilos Disponibles

**25 colecciones de wallpapers:**
- `aurora` - Paisajes de aurora boreal
- `beach` - Escenas de playa
- `bitday` - Estilo pixel art
- `chihuahuan` - Desierto de Chihuahua
- `cliffs` - Paisajes de acantilados
- `colony` - Escenas futuristas
- `desert` - Paisajes desérticos
- `earth` - Vistas terrestres
- `exodus` - Temática espacial
- `factory` - Escenas industriales
- `firewatch` - Torres de vigilancia
- `forest` - Paisajes forestales
- `gradient` - Gradientes abstractos
- `home` - Escenas hogareñas
- `island` - Paisajes de islas
- `lake` - Paisajes lacustres
- `lakeside` - Orillas de lago
- `market` - Escenas de mercado
- `mojave` - Desierto de Mojave
- `moon` - Paisajes lunares
- `mountains` - Paisajes montañosos
- `room` - Interiores
- `sahara` - Desierto del Sahara
- `street` - Escenas urbanas
- `tokyo` - Paisajes de Tokyo

## 🕐 Programación Horaria

**Mapeo de wallpapers según la hora:**
- **06:00-08:59:** Amanecer (0.png)
- **09:00-11:59:** Mañana temprana (1.png)
- **12:00-14:59:** Mediodía (2.png)
- **15:00-17:59:** Tarde (3.png)
- **18:00-19:59:** Atardecer (4.png)
- **20:00-21:59:** Anochecer (5.png)
- **22:00-00:59:** Noche temprana (6.png)
- **01:00-05:59:** Noche tardía/Madrugada (7.png)

## 🎯 Comandos de Usuario

### Cambiar Estilo de Wallpaper
```bash
# Cambiar a estilo específico
change-wallpaper-style sahara
change-wallpaper-style tokyo
change-wallpaper-style beach

# Ver estilos disponibles
change-wallpaper-style
```

### Aplicar Wallpaper Manualmente
```bash
# Aplicar wallpaper del estilo actual
/home/dioni/.local/bin/dwall-hypr firewatch
```

### Gestión del Timer
```bash
# Ver estado del timer
systemctl --user status dynamic-wallpaper.timer

# Detener timer
systemctl --user stop dynamic-wallpaper.timer

# Reiniciar timer
systemctl --user restart dynamic-wallpaper.timer
```

## 🔧 Archivos Modificados

### 1. `/home/dioni/.config/hypr/hyprland.conf`
```diff
# Misc settings - ACTUALIZADAS
misc {
-    force_default_wallpaper = -1         # Temporal
+    force_default_wallpaper = 0          # Usa hyprpaper personalizado
    # ... otras configuraciones
}

# Autostart applications
exec-once = hyprpaper
+exec-once = /home/dioni/.local/bin/dwall-hypr firewatch
```

### 2. `/home/dioni/.config/hypr/hyprpaper.conf`
```diff
-# Configuración de hyprpaper
-preload = /home/dioni/Pictures/Wallpapers/nature_02.jpg
-wallpaper = ,/home/dioni/Pictures/Wallpapers/nature_02.jpg

+# Configuración de hyprpaper - Dynamic Wallpapers (firewatch)
+preload = /usr/share/dynamic-wallpaper/images/firewatch/0.png
+wallpaper = ,/usr/share/dynamic-wallpaper/images/firewatch/0.png
```

## ✅ Funcionalidades Implementadas

1. **✅ Wallpapers dinámicos** - Cambian automáticamente cada hora
2. **✅ 25+ estilos** - Amplia variedad de temas disponibles
3. **✅ Integración Hyprland** - Funciona perfectamente con hyprpaper
4. **✅ Cambio fácil de estilos** - Un comando para cambiar tema completo
5. **✅ Autostart** - Se inicia automáticamente con el sistema
6. **✅ Timer persistente** - Continúa funcionando entre reinicios
7. **✅ Mapeo temporal** - Wallpapers apropiados para cada hora del día

## 🐛 Problemas Resueltos

1. **Falta de wallpaper inicial** - Se configuró wallpaper por defecto temporal
2. **Archivo inexistente** - Se actualizó ruta a wallpapers reales
3. **No hay crontab** - Se usó systemd timer como alternativa moderna
4. **Integración con Hyprland** - Se creó script personalizado para hyprpaper
5. **Persistencia** - Timer systemd asegura continuidad entre sesiones

## 📚 Referencias

- **Repositorio:** [adi1090x/dynamic-wallpaper](https://github.com/adi1090x/dynamic-wallpaper)
- **Documentación Hyprland:** [hyprland.org](https://hyprland.org/)
- **Documentación hyprpaper:** [wiki.hyprland.org/hyprpaper](https://wiki.hyprland.org/Useful-Utilities/Hyprpaper/)

---

**Estado:** ✅ Completamente funcional  
**Mantenimiento:** Automático via systemd  
**Próximas mejoras:** Integración con pywal para esquemas de colores dinámicos
