# 🏗️ Arch Linux + Hyprland Dotfiles

> **Configuraciones personalizadas para Arch Linux con Hyprland, Waybar y herramientas modernas**

## 📋 Descripción

Este repositorio contiene mi configuración completa de Arch Linux con Hyprland, exportada automáticamente desde mi sistema en funcionamiento. Incluye todos los dotfiles, scripts de instalación y herramientas necesarias para replicar mi setup en una nueva instalación.

## 🚀 Instalación Rápida

### Para una instalación nueva de Arch Linux:

```bash
# 1. Después de la instalación base de Arch
git clone https://github.com/dioniDR/arch-dotfiles.git
cd arch-dotfiles

# 2. Instalar dependencias básicas
./scripts/bootstrap.sh

# 3. Instalación completa automática
./scripts/install.sh
```

## 📁 Estructura del Repositorio

```
arch-dotfiles/
├── config/                 # Configuraciones de aplicaciones
│   ├── hypr/              # Hyprland WM
│   ├── waybar/            # Barra de estado
│   ├── wofi/              # Launcher
│   ├── kitty/             # Terminal
│   └── ...
├── packages/              # Listas de paquetes instalados
│   ├── pacman-packages.txt
│   ├── aur-packages.txt
│   └── package-counts.txt
├── scripts/               # Scripts de automatización
│   ├── bootstrap.sh       # Preparar dependencias
│   ├── install.sh         # Instalación completa
│   ├── export-personal.sh # Exportar configuraciones
│   └── dotfiles-manager.sh # Gestión de dotfiles
├── shell/                 # Dotfiles del home
├── system/                # Configuraciones de sistema
└── wallpapers/           # Fondos de pantalla
```

## 🔄 Flujo de Trabajo

### Para actualizar configuraciones existentes:

```bash
# 1. Modificar archivos en ~/.config/
nano ~/.config/hypr/hyprland.conf

# 2. Probar que funcionen correctamente
# Recargar Hyprland: Super + Shift + R

# 3. Sincronizar cambios al repositorio
cd ~/arch-dotfiles
./scripts/export-personal.sh

# 4. Versionar cambios
git add .
git commit -m "✨ Update Hyprland gestures configuration"
git push
```

### Para instalar nuevos paquetes:

```bash
# 1. Instalar normalmente
yay -S nuevo-paquete

# 2. Actualizar listas en el repo
cd ~/arch-dotfiles
./scripts/export-personal.sh

# 3. Versionar cambios
git add packages/
git commit -m "📦 Add nuevo-paquete"
git push
```

### Para aplicar configuraciones del repo al sistema:

```bash
# Copiar configs del repo a ~/.config/
cp -r ~/arch-dotfiles/config/* ~/.config/

# O usar el script de instalación completa
./scripts/install.sh
```

## 🛠️ Scripts Principales

### `bootstrap.sh`
Prepara las dependencias básicas necesarias después de una instalación limpia de Arch:
- Instala herramientas de compilación (base-devel, git)
- Configura NetworkManager
- Instala yay (AUR helper)
- Prepara base de Wayland

### `install.sh`
Instalación completa automatizada:
- Instala todos los paquetes listados
- Copia configuraciones a sus ubicaciones
- Configura servicios del sistema
- Aplica temas y fuentes

### `export-personal.sh`
Exporta configuraciones actuales del sistema al repositorio:
- Copia configs de ~/.config/
- Actualiza listas de paquetes instalados
- Genera estadísticas del sistema
- Mantiene el repo sincronizado

### `dotfiles-manager.sh`
Herramientas avanzadas de gestión:
- Backup y restauración
- Comparación de configuraciones
- Validación de archivos
- Gestión de symlinks (opcional)

## 🖥️ Características del Setup

- **WM**: Hyprland (Wayland compositor)
- **Bar**: Waybar con módulos personalizados
- **Launcher**: Wofi
- **Terminal**: Kitty
- **Editor**: VS Code / Neovim
- **Gestos**: Configuración avanzada de touchpad
- **Temas**: GTK3 personalizado
- **Audio**: Pipewire/Pulse

## 📦 Paquetes Incluidos

El repositorio incluye listas automáticamente actualizadas de:
- **Pacman packages**: Paquetes oficiales de Arch
- **AUR packages**: Paquetes del Arch User Repository
- **Dependencias**: Librerías y herramientas del sistema

Ver archivos en `packages/` para listas completas.

## ⚠️ Notas Importantes

### Configuraciones como Copias
Las configuraciones están almacenadas como **copias** de las originales, no como symlinks:
- `~/.config/hypr/` → Configuraciones ACTIVAS (las que usa Hyprland)
- `~/arch-dotfiles/config/hypr/` → BACKUP/REPO (sincronizado manualmente)

### Sincronización Manual
Los cambios no se reflejan automáticamente en el repo. Debes ejecutar `export-personal.sh` después de modificar configuraciones.

### Dependencias del Sistema
Algunos componentes requieren configuraciones específicas del sistema que se aplican durante la instalación con `install.sh`.

## 🔧 Personalización

Para adaptar este repo a tu sistema:

1. **Forkea** este repositorio
2. **Clona** tu fork localmente  
3. **Ejecuta** `./scripts/export-personal.sh` para capturar tus configuraciones
4. **Modifica** las configuraciones según tus preferencias
5. **Versiona** y mantén actualizado tu fork

## 📚 Documentación Adicional

- [Instalación de Arch Linux](https://wiki.archlinux.org/title/Installation_guide)
- [Hyprland Documentation](https://hyprland.org/)
- [Waybar Configuration](https://github.com/Alexays/Waybar/wiki)

## 🤝 Contribuciones

Si encuentras mejoras o fixes:
1. Abre un **Issue** para discutir cambios
2. Crea un **Pull Request** con tus mejoras
3. Asegúrate de que los scripts funcionen correctamente

## 📄 Licencia

Este repositorio está disponible bajo licencia MIT. Siéntete libre de usar, modificar y distribuir según tus necesidades.

---

**Generado automáticamente por el script `export-personal.sh`**  
*Última actualización: $(date)*
