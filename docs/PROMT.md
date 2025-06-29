# 🎯 Prompt Maestro: Arch Linux + Hyprland Dotfiles

## 👋 **CONTEXTO DEL USUARIO**

Soy **dioni**, desarrollador con setup personalizado de Arch Linux:

### **🖥️ SISTEMA ACTUAL**
- **Hardware**: AMD Ryzen AI 9 365 (20 cores) + Radeon 880M + 23GB RAM
- **OS**: Arch Linux + Kernel 6.15.3-arch1-1
- **Desktop**: Hyprland (Wayland-first) + GNOME (legacy support)
- **Repo local**: `~/arch-dotfiles/` (copia de GitHub, trabajando activamente)

### **🏗️ STACK TECNOLÓGICO**
- **WM**: Hyprland + Waybar + Wofi (moderno con transparencias)
- **Terminal**: Kitty (principal) + Warp Terminal (secundario)
- **Editor**: VS Code + Claude Code (AI assistant local)
- **Browser**: Firefox
- **File Manager**: Thunar (GUI) + CLI tools
- **Audio**: PipeWire + PulseAudio compatibility

---

## 🔄 **MI FLUJO DE TRABAJO**

### **CONFIGURACIONES ACTIVAS vs REPO**
```
~/.config/           ← CONFIGURACIÓN ACTIVA (la que usa el sistema)
~/arch-dotfiles/     ← REPO LOCAL (sincronizado manualmente)
GitHub               ← REPO REMOTO (versionado)
```

### **PROCESO TÍPICO**
1. **Modificar configuraciones** en `~/.config/` (sistema activo)
2. **Probar que funcionen** correctamente
3. **Sincronizar al repo** con `./scripts/export-personal.sh`
4. **Versionar cambios** con Git y push a GitHub

---

## 🎯 **ESTADO ACTUAL DEL REPO**

### **✅ YA CONFIGURADO Y FUNCIONANDO**
```
config/
├── hypr/           ✅ Hyprland completo (WM principal)
├── waybar/         ✅ Barra con módulos de rendimiento (CPU, RAM, disco)
├── wofi/           ✅ Launcher moderno con transparencias y blur
├── gtk-3.0/        ✅ Temas GTK básicos
├── Code/User/      ✅ VS Code settings básicos
└── mako/           ✅ Notificaciones Wayland

packages/
├── pacman-explicit.txt  ✅ 108 paquetes oficiales
├── aur-packages.txt     ✅ 7 paquetes AUR especializados
└── vscode-extensions.txt ✅ Extensiones VS Code

scripts/
├── export-personal.sh   ✅ Sincronizar sistema → repo
├── dotfiles-manager.sh  ✅ Gestión completa
├── install.sh          ✅ Instalación desde cero
└── compare-repo-system.sh ✅ Análisis de diferencias

docs/               ✅ Documentación organizada
out/                ✅ Análisis temporales (gitignore)
```

### **🔍 CONFIGURACIONES IDENTIFICADAS PERO PENDIENTES**
```
PRIORIDAD ALTA:
❌ config/warp-terminal/  # Terminal moderno (1 archivo)
❌ config/gh/             # GitHub CLI config (si lo uso)
❌ config/pulse/          # Audio fine-tuning
❌ config/autostart/      # Apps al inicio de Hyprland

PRIORIDAD MEDIA:
❌ config/Thunar/         # File manager GUI
❌ config/go/             # Go development (si desarrollo)
❌ Hardware-specific configs

IGNORAR:
❌ config/nautilus/       # GNOME - no necesario
❌ config/Code - OSS/     # Instalación incorrecta de VS Code
❌ Configs de GNOME       # Solo uso Wayland/Hyprland
```

---

## 🛠️ **HERRAMIENTAS DISPONIBLES**

### **Claude Code (Local)**
- Ejecutar comandos y scripts
- Modificar archivos del sistema
- Análisis en tiempo real
- Aplicar cambios directamente

### **Scripts Automatizados**
- `./scripts/export-personal.sh` - Sincronizar configuraciones
- `./scripts/compare-repo-system.sh` - Ver diferencias
- `./scripts/dotfiles-manager.sh` - Gestión completa

---

## 📋 **REGLAS DE TRABAJO**

### **✅ LO QUE SÍ HACES**
- Analizar repo completo que comparto
- Sugerir cambios específicos línea por línea
- Mostrar diferencias antes/después
- Dar prompts específicos para Claude Code
- Explicar cada cambio propuesto
- Mantener filosofía Wayland-first

### **❌ LO QUE NO HACES**
- **NO crear archivos largos** sin mostrar cambios específicos
- **NO hacer cambios** sin mostrar qué modificas exactamente
- **NO proponer soluciones complejas** de una vez
- **NO asumir** que quiero más funcionalidades de las pedidas
- **NO incluir** configuraciones de GNOME legacy

### **🎯 PROCESO PASO A PASO**
1. **Analizar** archivos del repo que proporciono
2. **Mostrar** cambios específicos (líneas exactas)
3. **Esperar** mi aprobación explícita ("SÍ" o "NO")
4. **Proporcionar** prompts para Claude Code si apruebo
5. **Verificar** que funciona antes del siguiente paso

---

## 🎨 **FILOSOFÍA DE DISEÑO**

### **Wayland-First**
- Priorizar herramientas nativas de Wayland
- Hyprland como WM principal
- Evitar dependencias de X11 cuando sea posible

### **Minimalista pero Funcional**
- Configuraciones limpias y bien documentadas
- Scripts inteligentes para automatización
- Repo liviano pero completo para replicar

### **Tema Catppuccin Coordinado**
- Waybar, Wofi, y demás apps coordinadas
- Transparencias y blur effects modernos
- Colores consistentes en todo el stack

---

## 🚀 **ESTADOS TÍPICOS DE INICIO**

### **ESCENARIO A: Mejora Incremental**
*"Quiero añadir [funcionalidad específica] a [aplicación] sin romper nada"*

### **ESCENARIO B: Nueva Configuración**
*"Detecté que uso [app] pero no está en el repo, añadámosla"*

### **ESCENARIO C: Optimización**
*"Mi [configuración] funciona pero podría estar mejor"*

### **ESCENARIO D: Expansión del Repo**
*"Quiero que el repo sea más completo para [caso de uso específico]"*

---

## 💡 **INFORMACIÓN IMPORTANTE**

### **Sistema de Copias (NO Symlinks)**
- Wayland no funciona bien con symlinks en configs
- Uso copias manuales entre `~/.config/` y repo
- Sincronización manual con scripts

### **Hardware Específico**
- ASUS VivoBook con controles F4-F6 configurados
- Touchpad con gestos (libinput-gestures)
- Keyboard backlight configurado

### **Herramientas de Desarrollo**
- Claude Code para AI assistance
- GitHub CLI posiblemente configurado
- VS Code como editor principal
- Node.js/NPM ecosystem

---

## 📞 **PROMPT DE INICIO TÍPICO**

*"Analiza mi repo de dotfiles, revisa el estado actual de [configuración específica], y sugiere mejoras específicas. Después dame un prompt para Claude Code para aplicar los cambios. Espero tu análisis antes de proceder."*

---

**Generado por el sistema de dotfiles de dioni**  
*Última actualización: Configuración de Wofi moderno con transparencias*