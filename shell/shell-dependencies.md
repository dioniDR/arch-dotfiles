# Shell Setup - Dependencias y Configuración

## Paquetes Instalados

### Core Shell
- **zsh** `5.9-5` - Z shell principal
- **zsh-autosuggestions** `0.7.1-1` - Sugerencias automáticas en gris
- **zsh-completions** `0.35.0-2` - Completado automático extendido
- **zsh-syntax-highlighting** `0.8.0-1` - Resaltado de sintaxis en comandos

### Herramientas de Navegación
- **fzf** `0.65.1-1` - Buscador interactivo fuzzy finder
- **zoxide** `0.9.8-2` - Navegación inteligente de directorios (z)

## Archivos de Configuración

### Ubicación Principal
- `~/.zshrc` - Configuración principal de zsh
- `/home/dioni/arch-dotfiles/shell/.zshrc` - Respaldo en dotfiles

### Configuración FZF
**Archivos del sistema:**
- `/usr/share/fzf/completion.zsh` - Completado automático
- `/usr/share/fzf/key-bindings.zsh` - Atajos de teclado

**Configuración requerida en .zshrc:**
```zsh
# Cargar fzf si está disponible
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
fi
```

**Nota:** El archivo `~/.fzf.zsh` no existe actualmente. Para configurarlo:
```bash
# Generar configuración completa de fzf
echo 'source /usr/share/fzf/completion.zsh' > ~/.fzf.zsh
echo 'source /usr/share/fzf/key-bindings.zsh' >> ~/.fzf.zsh
```

### Configuración Zoxide
**Inicialización en .zshrc:**
```zsh
# Inicializar zoxide si está instalado
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
```

**Aliases recomendados:**
```zsh
alias cd='z'    # Reemplaza cd con zoxide
alias cdi='zi'  # Modo interactivo con fzf
```

## Plugins de Sistema

### Rutas de Plugins
- **zsh-autosuggestions:** `/usr/share/zsh/plugins/zsh-autosuggestions/`
- **zsh-syntax-highlighting:** `/usr/share/zsh/plugins/zsh-syntax-highlighting/`

### Carga de Plugins en .zshrc
```zsh
# Autosugerencias (debe ir antes del syntax highlighting)
[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (SIEMPRE AL FINAL)
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

## Comandos de Instalación

### Instalar paquetes base:
```bash
sudo pacman -S zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting fzf zoxide
```

### Configurar como shell por defecto:
```bash
chsh -s $(which zsh)
```

### Generar configuración fzf:
```bash
echo 'source /usr/share/fzf/completion.zsh' > ~/.fzf.zsh
echo 'source /usr/share/fzf/key-bindings.zsh' >> ~/.fzf.zsh
```

## Funcionalidades Activas

### FZF Keybindings
- `Ctrl+R` - Búsqueda en historial
- `Ctrl+T` - Búsqueda de archivos
- `Alt+C` - Cambio de directorio

### Zoxide
- `z <directorio>` - Navegar a directorio frecuente
- `zi` - Modo interactivo con fzf
- `z -` - Directorio anterior

### ZSH Features
- Autocompletado inteligente
- Sugerencias basadas en historial
- Resaltado de sintaxis en tiempo real
- Historial compartido entre sesiones