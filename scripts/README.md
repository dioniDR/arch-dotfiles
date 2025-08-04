# 🚀 Scripts de Recuperación Rápida

Colección de scripts para recovery instantáneo del sistema.

## 📋 Scripts Disponibles

### **emergency-backup.sh**
- **Propósito**: Backup completo antes de cambios críticos
- **Tiempo**: 2-3 minutos
- **Output**: ~/.emergency-backups/emergency-[timestamp]/

### **quick-recovery.sh** (Próximo)
- **Propósito**: Recovery configs en < 30 segundos
- **Restaura**: Hyprland, Waybar, shell configs

### **package-recovery.sh** (Próximo)  
- **Propósito**: Reinstalación rápida paquetes críticos
- **Tiempo**: 10-15 minutos

## 🔧 Uso Típico

```bash
# Antes de cambios delicados
./scripts/emergency-backup.sh

# Si algo falla
~/.emergency-backups/emergency-[timestamp]/RECOVERY-INSTRUCTIONS.sh
```

## 🎯 Recovery por Componente

- **Hyprland**: `hyprctl reload`
- **Waybar**: `killall waybar && waybar &`
- **Audio**: `systemctl --user restart pipewire`
- **Servicios**: `systemctl --user daemon-reload`