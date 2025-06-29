#!/bin/bash

# Waybar Safe Editor - Sistema modular seguro para personalización
# Autor: Claude Code Assistant
# Funciones: backup automático, rollback, modificaciones incrementales

WAYBAR_DIR="$HOME/arch-dotfiles/config/waybar"
BACKUP_DIR="$HOME/.waybar-backups"
CONFIG_FILE="$WAYBAR_DIR/config.jsonc"
STYLE_FILE="$WAYBAR_DIR/style.css"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Crear directorio de backups si no existe
mkdir -p "$BACKUP_DIR"

# Función para crear backup automático
create_backup() {
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_name="waybar_$timestamp"
    
    echo -e "${BLUE}🔄 Creando backup: $backup_name${NC}"
    
    mkdir -p "$BACKUP_DIR/$backup_name"
    cp "$CONFIG_FILE" "$BACKUP_DIR/$backup_name/"
    cp "$STYLE_FILE" "$BACKUP_DIR/$backup_name/"
    
    echo "$backup_name" > "$BACKUP_DIR/latest"
    echo -e "${GREEN}✅ Backup creado exitosamente${NC}"
    return 0
}

# Función para listar backups disponibles
list_backups() {
    echo -e "${BLUE}📋 Backups disponibles:${NC}"
    ls -la "$BACKUP_DIR" | grep "waybar_" | awk '{print $9}' | sort -r
}

# Función para rollback instantáneo
rollback() {
    local backup_name="$1"
    
    if [ -z "$backup_name" ]; then
        if [ -f "$BACKUP_DIR/latest" ]; then
            backup_name=$(cat "$BACKUP_DIR/latest")
            echo -e "${YELLOW}⚠️  Usando último backup: $backup_name${NC}"
        else
            echo -e "${RED}❌ No se especificó backup y no hay backup reciente${NC}"
            return 1
        fi
    fi
    
    if [ ! -d "$BACKUP_DIR/$backup_name" ]; then
        echo -e "${RED}❌ Backup '$backup_name' no encontrado${NC}"
        return 1
    fi
    
    echo -e "${BLUE}🔄 Restaurando desde backup: $backup_name${NC}"
    
    # Crear backup del estado actual antes de rollback
    create_backup
    
    # Restaurar archivos
    cp "$BACKUP_DIR/$backup_name/config.jsonc" "$CONFIG_FILE"
    cp "$BACKUP_DIR/$backup_name/style.css" "$STYLE_FILE"
    
    # Reiniciar Waybar
    restart_waybar
    
    echo -e "${GREEN}✅ Rollback completado${NC}"
    return 0
}

# Función para reiniciar Waybar
restart_waybar() {
    echo -e "${BLUE}🔄 Reiniciando Waybar...${NC}"
    pkill waybar
    sleep 1
    waybar &
    echo -e "${GREEN}✅ Waybar reiniciado${NC}"
}

# Función para aplicar cambio seguro
apply_safe_change() {
    local change_type="$1"
    local target="$2"
    local value="$3"
    
    echo -e "${BLUE}🔄 Aplicando cambio seguro...${NC}"
    echo -e "Tipo: $change_type"
    echo -e "Target: $target"
    echo -e "Valor: $value"
    
    # Crear backup antes del cambio
    create_backup
    
    case "$change_type" in
        "color")
            apply_color_change "$target" "$value"
            ;;
        "size")
            apply_size_change "$target" "$value"
            ;;
        "spacing")
            apply_spacing_change "$target" "$value"
            ;;
        *)
            echo -e "${RED}❌ Tipo de cambio no soportado: $change_type${NC}"
            return 1
            ;;
    esac
    
    # Reiniciar Waybar para aplicar cambios
    restart_waybar
    
    echo -e "${GREEN}✅ Cambio aplicado. Para revertir: $0 rollback${NC}"
}

# Función para cambios de color seguros
apply_color_change() {
    local element="$1"
    local color="$2"
    
    echo -e "${YELLOW}⚠️  Aplicando cambio de color a '$element': $color${NC}"
    
    # Usar sed para cambio seguro (evitar regex complejos)
    case "$element" in
        "clock")
            sed -i "s/background: #89b4fa;/background: $color;/" "$STYLE_FILE"
            ;;
        "battery")
            sed -i "s/background: #a6e3a1;/background: $color;/" "$STYLE_FILE"
            ;;
        *)
            echo -e "${RED}❌ Elemento no soportado para cambio de color: $element${NC}"
            return 1
            ;;
    esac
}

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}Waybar Safe Editor - Sistema modular seguro${NC}"
    echo ""
    echo "Uso: $0 [comando] [opciones]"
    echo ""
    echo "Comandos:"
    echo "  backup                 - Crear backup manual"
    echo "  list                   - Listar backups disponibles"
    echo "  rollback [backup_name] - Restaurar desde backup"
    echo "  restart                - Reiniciar Waybar"
    echo "  change [tipo] [elemento] [valor] - Aplicar cambio seguro"
    echo "  help                   - Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 backup"
    echo "  $0 rollback waybar_20241229_143022"
    echo "  $0 change color clock '#ff6b6b'"
    echo "  $0 list"
}

# Función principal
main() {
    case "$1" in
        "backup")
            create_backup
            ;;
        "list")
            list_backups
            ;;
        "rollback")
            rollback "$2"
            ;;
        "restart")
            restart_waybar
            ;;
        "change")
            apply_safe_change "$2" "$3" "$4"
            ;;
        "help"|"--help"|"-h"|"")
            show_help
            ;;
        *)
            echo -e "${RED}❌ Comando desconocido: $1${NC}"
            show_help
            exit 1
            ;;
    esac
}

# Verificar que los archivos existan
if [ ! -f "$CONFIG_FILE" ] || [ ! -f "$STYLE_FILE" ]; then
    echo -e "${RED}❌ Archivos de Waybar no encontrados en $WAYBAR_DIR${NC}"
    exit 1
fi

# Ejecutar función principal
main "$@"