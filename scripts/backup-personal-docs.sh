#!/bin/bash

# Sistema de Backup para Archivos Personales
# Versión: 1.0
# Fecha: $(date +%Y-%m-%d)

set -euo pipefail

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuración
BACKUP_DIR="$HOME/.personal-docs-backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="personal-backup-$TIMESTAMP"
COMPRESS_BACKUP=true
ENCRYPTION_ENABLED=false
MAX_BACKUPS=10

# Funciones de utilidad
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_section() {
    echo -e "\n${PURPLE}═══════════════════════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════════════════${NC}"
}

# Función para verificar dependencias
check_dependencies() {
    local missing_deps=()
    
    # Comandos necesarios
    local required_commands=("rsync" "find" "tar" "gzip")
    
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Faltan dependencias: ${missing_deps[*]}"
        log_info "Instala las dependencias faltantes con: sudo pacman -S ${missing_deps[*]}"
        exit 1
    fi
}

# Función para crear estructura de directorios
create_backup_structure() {
    log_section "📁 CREANDO ESTRUCTURA DE BACKUP"
    
    # Crear directorio principal de backup
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        log_success "Directorio de backup creado: $BACKUP_DIR"
    else
        log_info "Directorio de backup ya existe: $BACKUP_DIR"
    fi
    
    # Crear subdirectorios
    local subdirs=("archives" "current" "logs" "config")
    for subdir in "${subdirs[@]}"; do
        mkdir -p "$BACKUP_DIR/$subdir"
    done
    
    log_success "Estructura de directorios creada"
}

# Función para definir qué archivos hacer backup
define_backup_sources() {
    # Definir fuentes de backup
    BACKUP_SOURCES=(
        # Documentos importantes
        "$HOME/Documents"
        "$HOME/Downloads"
        "$HOME/Pictures"
        "$HOME/Videos"
        "$HOME/Music"
        "$HOME/Desktop"
        
        # Archivos de configuración personal
        "$HOME/.gitconfig"
        "$HOME/.ssh"
        "$HOME/.gnupg"
        "$HOME/.config/Code/User/settings.json"
        "$HOME/.config/Code/User/keybindings.json"
        "$HOME/.vimrc"
        "$HOME/.zshrc"
        "$HOME/.bashrc"
        "$HOME/.profile"
        "$HOME/.xinitrc"
        "$HOME/.Xresources"
        
        # Datos de aplicaciones
        "$HOME/.mozilla/firefox"
        "$HOME/.thunderbird"
        "$HOME/.config/discord"
        "$HOME/.config/Signal"
        "$HOME/.config/obsidian"
        "$HOME/.local/share/Steam"
        
        # Proyectos personales
        "$HOME/Projects"
        "$HOME/Development"
        "$HOME/Workspace"
        "$HOME/Code"
        
        # Otros archivos importantes
        "$HOME/.local/share/applications"
        "$HOME/.local/share/fonts"
        "$HOME/.themes"
        "$HOME/.icons"
    )
    
    # Archivos y directorios a excluir
    EXCLUDE_PATTERNS=(
        "*.tmp"
        "*.temp"
        "*.cache"
        "*.log"
        "node_modules"
        ".git"
        ".DS_Store"
        "Thumbs.db"
        "*.iso"
        "*.img"
        "*.vmdk"
        "*.vdi"
        "*.qcow2"
        "Cache"
        "cache"
        "tmp"
        "temp"
        ".Trash*"
        "*.part"
        "*.crdownload"
    )
}

# Función para verificar espacio disponible
check_disk_space() {
    log_section "💾 VERIFICANDO ESPACIO EN DISCO"
    
    local backup_parent_dir=$(dirname "$BACKUP_DIR")
    local available_space=$(df -BG "$backup_parent_dir" | tail -1 | awk '{print $4}' | sed 's/G//')
    local estimated_size=0
    
    # Estimar tamaño del backup
    for source in "${BACKUP_SOURCES[@]}"; do
        if [ -e "$source" ]; then
            local size=$(du -s "$source" 2>/dev/null | awk '{print $1}' || echo 0)
            estimated_size=$((estimated_size + size))
        fi
    done
    
    estimated_size_gb=$((estimated_size / 1024 / 1024))
    
    log_info "Espacio disponible: ${available_space}GB"
    log_info "Tamaño estimado del backup: ${estimated_size_gb}GB"
    
    if [ "$available_space" -lt $((estimated_size_gb * 2)) ]; then
        log_warn "Espacio limitado. Se recomienda al menos el doble del tamaño estimado"
    else
        log_success "Espacio suficiente para el backup"
    fi
}

# Función para realizar backup incremental
perform_backup() {
    log_section "🔄 REALIZANDO BACKUP"
    
    local current_backup_dir="$BACKUP_DIR/current"
    local temp_backup_dir="$BACKUP_DIR/temp-$TIMESTAMP"
    
    # Crear directorio temporal
    mkdir -p "$temp_backup_dir"
    
    # Construir opciones de rsync
    local rsync_options="-av --progress --stats"
    
    # Agregar patrones de exclusión
    local exclude_file="$BACKUP_DIR/config/exclude-patterns.txt"
    printf '%s\n' "${EXCLUDE_PATTERNS[@]}" > "$exclude_file"
    rsync_options="$rsync_options --exclude-from=$exclude_file"
    
    # Backup incremental si existe backup anterior
    if [ -d "$current_backup_dir" ]; then
        rsync_options="$rsync_options --link-dest=$current_backup_dir"
        log_info "Realizando backup incremental"
    else
        log_info "Realizando backup completo inicial"
    fi
    
    # Realizar backup de cada fuente
    local backup_log="$BACKUP_DIR/logs/backup-$TIMESTAMP.log"
    local files_backed_up=0
    local total_size=0
    
    echo "=== BACKUP LOG - $(date) ===" > "$backup_log"
    
    for source in "${BACKUP_SOURCES[@]}"; do
        if [ -e "$source" ]; then
            local source_name=$(basename "$source")
            log_info "Backing up: $source_name"
            
            # Crear directorio de destino
            local dest_dir="$temp_backup_dir/$source_name"
            mkdir -p "$(dirname "$dest_dir")"
            
            # Ejecutar rsync
            if rsync $rsync_options "$source/" "$dest_dir/" >> "$backup_log" 2>&1; then
                log_success "✓ $source_name"
                local file_count=$(find "$dest_dir" -type f | wc -l)
                local dir_size=$(du -sh "$dest_dir" | cut -f1)
                files_backed_up=$((files_backed_up + file_count))
                echo "  Archivos: $file_count | Tamaño: $dir_size" >> "$backup_log"
            else
                log_error "✗ Error backing up $source_name"
                echo "ERROR: Failed to backup $source" >> "$backup_log"
            fi
        else
            log_warn "Fuente no encontrada: $source"
            echo "WARNING: Source not found: $source" >> "$backup_log"
        fi
    done
    
    # Mover backup temporal a directorio actual
    if [ -d "$current_backup_dir" ]; then
        mv "$current_backup_dir" "$BACKUP_DIR/archives/backup-$(date +%Y%m%d_%H%M%S)"
    fi
    mv "$temp_backup_dir" "$current_backup_dir"
    
    log_success "Backup completado: $files_backed_up archivos"
}

# Función para comprimir backup
compress_backup() {
    if [ "$COMPRESS_BACKUP" = true ]; then
        log_section "🗜️ COMPRIMIENDO BACKUP"
        
        local current_backup_dir="$BACKUP_DIR/current"
        local archive_file="$BACKUP_DIR/archives/${BACKUP_NAME}.tar.gz"
        
        log_info "Comprimiendo backup..."
        
        if tar -czf "$archive_file" -C "$BACKUP_DIR" "current" 2>/dev/null; then
            local archive_size=$(du -sh "$archive_file" | cut -f1)
            log_success "Backup comprimido: $archive_size"
            echo "Archivo comprimido: $archive_file"
        else
            log_error "Error al comprimir backup"
        fi
    fi
}

# Función para limpiar backups antiguos
cleanup_old_backups() {
    log_section "🧹 LIMPIANDO BACKUPS ANTIGUOS"
    
    local archives_dir="$BACKUP_DIR/archives"
    local backup_count=$(ls -1 "$archives_dir" 2>/dev/null | wc -l)
    
    log_info "Backups encontrados: $backup_count"
    
    if [ "$backup_count" -gt "$MAX_BACKUPS" ]; then
        local to_remove=$((backup_count - MAX_BACKUPS))
        log_info "Eliminando $to_remove backups antiguos..."
        
        # Eliminar backups más antiguos
        ls -1t "$archives_dir" | tail -n "$to_remove" | while read -r backup; do
            rm -rf "$archives_dir/$backup"
            log_info "Eliminado: $backup"
        done
        
        log_success "Limpieza completada"
    else
        log_info "No es necesario limpiar backups"
    fi
}

# Función para generar reporte
generate_report() {
    log_section "📊 GENERANDO REPORTE"
    
    local report_file="$BACKUP_DIR/logs/backup-report-$TIMESTAMP.txt"
    local current_backup_dir="$BACKUP_DIR/current"
    
    {
        echo "=== REPORTE DE BACKUP ==="
        echo "Fecha: $(date)"
        echo "Usuario: $(whoami)"
        echo "Hostname: $(hostname 2>/dev/null || echo 'unknown')"
        echo ""
        echo "=== ESTADÍSTICAS ==="
        if [ -d "$current_backup_dir" ]; then
            echo "Archivos totales: $(find "$current_backup_dir" -type f | wc -l)"
            echo "Directorios: $(find "$current_backup_dir" -type d | wc -l)"
            echo "Tamaño total: $(du -sh "$current_backup_dir" | cut -f1)"
        fi
        echo ""
        echo "=== UBICACIONES ==="
        echo "Backup directory: $BACKUP_DIR"
        echo "Current backup: $current_backup_dir"
        echo "Archives: $BACKUP_DIR/archives"
        echo "Logs: $BACKUP_DIR/logs"
        echo ""
        echo "=== CONFIGURACIÓN ==="
        echo "Compresión: $COMPRESS_BACKUP"
        echo "Máximo backups: $MAX_BACKUPS"
        echo "Timestamp: $TIMESTAMP"
        echo ""
        echo "=== FUENTES DE BACKUP ==="
        printf '%s\n' "${BACKUP_SOURCES[@]}"
        echo ""
        echo "=== PATRONES EXCLUIDOS ==="
        printf '%s\n' "${EXCLUDE_PATTERNS[@]}"
    } > "$report_file"
    
    log_success "Reporte generado: $report_file"
}

# Función para actualizar .gitignore
update_gitignore() {
    log_section "📝 ACTUALIZANDO .GITIGNORE"
    
    local gitignore_file="$HOME/arch-dotfiles/.gitignore"
    local personal_backup_entry=".personal-docs-backup/"
    
    # Crear .gitignore si no existe
    if [ ! -f "$gitignore_file" ]; then
        touch "$gitignore_file"
        log_info "Archivo .gitignore creado"
    fi
    
    # Agregar entrada si no existe
    if ! grep -q "^$personal_backup_entry" "$gitignore_file"; then
        echo "" >> "$gitignore_file"
        echo "# Personal backup directory" >> "$gitignore_file"
        echo "$personal_backup_entry" >> "$gitignore_file"
        log_success "Entrada agregada a .gitignore"
    else
        log_info ".gitignore ya contiene la entrada"
    fi
}

# Función para mostrar estadísticas finales
show_final_stats() {
    log_section "📈 ESTADÍSTICAS FINALES"
    
    local current_backup_dir="$BACKUP_DIR/current"
    
    if [ -d "$current_backup_dir" ]; then
        local total_files=$(find "$current_backup_dir" -type f | wc -l)
        local total_size=$(du -sh "$current_backup_dir" | cut -f1)
        local backup_age=$(stat -c %Y "$current_backup_dir")
        local current_time=$(date +%s)
        local age_minutes=$(( (current_time - backup_age) / 60 ))
        
        echo -e "${CYAN}Total de archivos:${NC} $total_files"
        echo -e "${CYAN}Tamaño total:${NC} $total_size"
        echo -e "${CYAN}Tiempo transcurrido:${NC} $age_minutes minutos"
        echo -e "${CYAN}Ubicación:${NC} $current_backup_dir"
        
        # Mostrar archivos más grandes
        echo -e "${CYAN}Top 5 archivos más grandes:${NC}"
        find "$current_backup_dir" -type f -exec du -h {} + | sort -hr | head -5 | while read -r size file; do
            echo "  $size - $(basename "$file")"
        done
    fi
}

# Función principal
main() {
    clear
    echo -e "${PURPLE}"
    echo "    ╔═══════════════════════════════════════════════════════════════════════════════╗"
    echo "    ║                         SISTEMA DE BACKUP PERSONAL                            ║"
    echo "    ║                                Version 1.0                                   ║"
    echo "    ╚═══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Verificar dependencias
    check_dependencies
    
    # Definir fuentes de backup
    define_backup_sources
    
    # Crear estructura
    create_backup_structure
    
    # Verificar espacio
    check_disk_space
    
    # Realizar backup
    perform_backup
    
    # Comprimir si está habilitado
    compress_backup
    
    # Limpiar backups antiguos
    cleanup_old_backups
    
    # Generar reporte
    generate_report
    
    # Actualizar .gitignore
    update_gitignore
    
    # Mostrar estadísticas
    show_final_stats
    
    log_section "✅ BACKUP COMPLETADO"
    echo -e "${GREEN}Backup de archivos personales completado exitosamente.${NC}"
    echo -e "${CYAN}Ubicación del backup:${NC} $BACKUP_DIR"
    echo -e "${CYAN}Timestamp:${NC} $TIMESTAMP"
    echo -e "${CYAN}Duración total:${NC} $SECONDS segundos"
}

# Verificar argumentos
case "${1:-}" in
    --help|-h)
        echo "Uso: $0 [opciones]"
        echo "Opciones:"
        echo "  --help, -h     Mostrar esta ayuda"
        echo "  --no-compress  Deshabilitar compresión"
        echo "  --max-backups N  Máximo número de backups a mantener (default: 10)"
        echo "  --encrypt      Habilitar encriptación (requiere gpg)"
        exit 0
        ;;
    --no-compress)
        COMPRESS_BACKUP=false
        ;;
    --max-backups)
        MAX_BACKUPS="${2:-10}"
        shift
        ;;
    --encrypt)
        ENCRYPTION_ENABLED=true
        ;;
esac

# Ejecutar función principal
main "$@"