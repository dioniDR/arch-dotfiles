# 🎨 Iconos de Waybar - Nerd Fonts

## 📊 Iconos Implementados

### Módulos del Sistema

| Módulo | Icono | Descripción |
|--------|--------|-------------|
| **CPU** |  | Procesador AMD Ryzen AI 9 365 |
| **Memory** |  | Memoria RAM (23GB) |
| **Disk** |  | Almacenamiento SSD |
| **Clock** |  | Reloj y calendario |
| **Power** |  | Menú de energía |

### Conectividad

| Módulo | Icono | Estados |
|--------|--------|---------|
| **WiFi** |  | Conectado con señal |
| **Ethernet** |  | Conexión cableada |
| **Disconnected** |  | Sin conexión |
| **Bluetooth On** |  | Bluetooth activo |
| **Bluetooth Off** |  | Bluetooth inactivo |
| **Bluetooth Connected** |  | Dispositivo conectado |

### Audio

| Estado | Icono | Descripción |
|--------|--------|-------------|
| **Volume Low** |  | Volumen bajo |
| **Volume Medium** |  | Volumen medio |
| **Volume High** |  | Volumen alto |
| **Muted** |  | Audio silenciado |
| **Headphones** |  | Auriculares conectados |

### Batería

| Nivel | Icono | Estado |
|-------|--------|--------|
| **0-20%** |  | Batería crítica |
| **20-40%** |  | Batería baja |
| **40-60%** |  | Batería media |
| **60-80%** |  | Batería buena |
| **80-100%** |  | Batería completa |
| **Charging** |  | Cargando |
| **Plugged** |  | Conectado a corriente |

### Espacios de Trabajo

| Workspace | Icono | Uso Típico |
|-----------|--------|------------|
| **1** | 󰈹 | Navegador web |
| **2** |  | Terminal/Desarrollo |
| **3** |  | Editor de código |
| **4** | 󰎄 | Media/Entretenimiento |
| **5** | 󰋩 | Comunicaciones |
| **Default** |  | Otros espacios |

## 🛠️ Configuración Técnica

### Fuentes Requeridas
```bash
# Verificar fuentes instaladas
fc-list | grep -i "nerd\|symbol"

# Paquetes necesarios
sudo pacman -S ttf-nerd-fonts-symbols-common
sudo pacman -S ttf-nerd-fonts-symbols-mono
```

### Archivos de Configuración
- **Config**: `~/.config/waybar/config.jsonc`
- **Styles**: `~/.config/waybar/style.css`
- **Backup**: `~/arch-dotfiles/config/waybar/`

### Scripts Útiles
```bash
# Recargar Waybar
~/arch-dotfiles/scripts/reload-waybar.sh

# Verificar configuración
python3 -m json.tool ~/.config/waybar/config.jsonc

# Ver proceso Waybar
pgrep waybar && echo "Waybar running" || echo "Waybar stopped"
```

## 🎯 Personalización

### Cambiar Iconos
1. Editar `~/.config/waybar/config.jsonc`
2. Buscar la sección del módulo deseado
3. Cambiar el valor en `"format": " nuevo_icono"`
4. Ejecutar `./scripts/reload-waybar.sh`

### Recursos de Iconos
- **Nerd Fonts Cheat Sheet**: https://www.nerdfonts.com/cheat-sheet
- **Unicode Reference**: https://unicode-table.com/
- **Font Awesome**: Incluido en Nerd Fonts

### Troubleshooting

#### Iconos no se muestran
```bash
# Verificar fuentes
fc-cache -fv
fc-list | grep Symbols

# Reinstalar fuentes si es necesario
sudo pacman -S ttf-nerd-fonts-symbols-common
```

#### Waybar no inicia
```bash
# Ver errores
waybar -l debug

# Verificar configuración JSON
python3 -m json.tool ~/.config/waybar/config.jsonc
```

#### Iconos aparecen como cuadrados
- Falta la fuente Nerd Font
- Terminal no soporta Unicode
- Configuración de fuentes incorrecta

---
*Configuración optimizada para AMD Ryzen AI 9 365 + Hyprland*