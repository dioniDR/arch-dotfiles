#!/bin/bash

# ================================================================
# OLLAMA LAB LAUNCHER (F3)
# ================================================================
# Script para lanzar la interfaz web de Ollama Lab
# Ejecutado desde Hyprland con F3

OLLAMA_LAB_DIR="/home/dioni/ollama-lab"
LOGFILE="/tmp/ollama-lab-f3.log"

# Función de logging
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

log "=== F3 Ollama Lab Launcher iniciado ==="

# Verificar que el directorio existe
if [ ! -d "$OLLAMA_LAB_DIR" ]; then
    log "ERROR: Directorio $OLLAMA_LAB_DIR no encontrado"
    notify-send "Error" "Directorio ollama-lab no encontrado" -i error
    exit 1
fi

# Cambiar al directorio del proyecto
cd "$OLLAMA_LAB_DIR" || {
    log "ERROR: No se pudo acceder a $OLLAMA_LAB_DIR"
    notify-send "Error" "No se pudo acceder al directorio ollama-lab" -i error
    exit 1
}

log "Cambiado al directorio: $(pwd)"

# Verificar que Ollama está ejecutándose
if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    log "WARNING: Ollama no parece estar ejecutándose en puerto 11434"
    notify-send "Advertencia" "Ollama no está ejecutándose. Iniciando..." -i warning
    
    # Intentar iniciar Ollama en background
    ollama serve > /dev/null 2>&1 &
    sleep 3
    
    # Verificar nuevamente
    if ! curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        log "ERROR: No se pudo iniciar Ollama"
        notify-send "Error" "No se pudo conectar con Ollama" -i error
        exit 1
    fi
fi

log "Ollama está ejecutándose correctamente"

# Verificar que el entorno virtual existe
if [ ! -f "venv/bin/python" ]; then
    log "ERROR: Entorno virtual no encontrado en venv/"
    notify-send "Error" "Entorno virtual Python no encontrado" -i error
    exit 1
fi

log "Entorno virtual encontrado"

# Verificar si la aplicación ya está ejecutándose
if curl -s http://localhost:8000 > /dev/null 2>&1; then
    log "INFO: Aplicación ya está ejecutándose, abriendo navegador"
    notify-send "Ollama Lab" "La aplicación ya está ejecutándose. Abriendo navegador..." -i info
    firefox http://localhost:8000 > /dev/null 2>&1 &
    exit 0
fi

# Ejecutar la aplicación en background
log "Iniciando aplicación Ollama Lab..."
notify-send "Ollama Lab" "Iniciando aplicación..." -i info

# Ejecutar en una nueva terminal que se cierre automáticamente después
kitty --hold -e bash -c "
    cd '$OLLAMA_LAB_DIR'
    export PATH='/home/dioni/.npm-global/bin:/usr/bin:\$PATH'
    echo 'Iniciando Ollama Lab...'
    echo 'Presiona Ctrl+C para detener el servidor'
    echo 'Esta ventana se puede cerrar, el servidor seguirá ejecutándose'
    ./venv/bin/python main.py
" > /dev/null 2>&1 &

# Esperar un momento para que la aplicación inicie
sleep 3

# Verificar que la aplicación inició correctamente
if curl -s http://localhost:8000 > /dev/null 2>&1; then
    log "SUCCESS: Aplicación iniciada correctamente"
    notify-send "Ollama Lab" "Aplicación iniciada. Abriendo navegador..." -i info
    
    # Abrir navegador
    sleep 1
    firefox http://localhost:8000 > /dev/null 2>&1 &
    
    log "Navegador lanzado"
else
    log "ERROR: La aplicación no se pudo iniciar"
    notify-send "Error" "No se pudo iniciar la aplicación Ollama Lab" -i error
    exit 1
fi

log "=== F3 Ollama Lab Launcher completado ==="
