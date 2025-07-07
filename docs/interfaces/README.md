# 🎯 Interfaces F1/F2/F3 - Consolidadas

## Resumen
Sistema unificado de interfaces de usuario para arch-dotfiles:
- **F1**: Sistema de ayuda (HTML local)
- **F2**: Base de conocimiento (localhost:8011)
- **F3**: Ollama Lab IA (localhost:8000)

## Estructura
```
docs/interfaces/
├── f1-help/
│   ├── help.html           # Interfaz principal
│   └── launch-f1.sh        # Launcher
├── f2-knowledge/
│   ├── README.md           # Documentación
│   └── launch-f2.sh        # Launcher
├── f3-ollama/
│   ├── README.md           # Documentación
│   └── launch-f3.sh        # Launcher
└── shared/                 # Recursos compartidos
```

## Uso
1. **Instalación**: `./scripts/interfaces/install-f123.sh`
2. **Activación**: Bindings automáticos en Hyprland
3. **Uso**: Presionar F1/F2/F3 en cualquier momento

## Características
- ✅ Rutas visibles en las interfaces
- ✅ Launchers inteligentes con verificaciones
- ✅ Integración con Hyprland
- ✅ Documentación consolidada
- ✅ Instalación automática

## Mantenimiento
- Editar interfaces desde ubicaciones visibles
- Logs en ~/.local/share/xdg-desktop-portal/
- Reiniciar Hyprland: `hyprctl reload`

## Troubleshooting
- F1 no abre: verificar navegador instalado
- F2 no conecta: verificar servicio knowledge-base
- F3 no funciona: verificar ollama instalado
