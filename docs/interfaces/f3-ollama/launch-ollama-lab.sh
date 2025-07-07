#!/bin/bash

# =============================================================================
# launch-ollama-lab.sh - Launch Ollama-lab application
# =============================================================================
# Script executed by F3 binding to launch Ollama-lab and open browser
# Handles service management, environment setup, and error recovery
# =============================================================================

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
OLLAMA_LAB_DIR="$HOME/arch-dotfiles/apps/ollama-lab"
OLLAMA_LAB_URL="http://localhost:8000"
OLLAMA_API_URL="http://localhost:11434"
SERVICE_NAME="ollama-lab"
LOG_FILE="/tmp/ollama-lab-launch.log"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

send_notification() {
    if command -v notify-send &> /dev/null; then
        notify-send "Ollama-lab" "$1" --icon=applications-science
    fi
}

check_ollama_service() {
    log_info "Checking Ollama service..."
    
    if ! systemctl is-active --quiet ollama; then
        log_warning "Ollama service not running, starting..."
        sudo systemctl start ollama
        sleep 2
        
        if ! systemctl is-active --quiet ollama; then
            log_error "Failed to start Ollama service"
            send_notification "Failed to start Ollama service"
            return 1
        fi
    fi
    
    # Test Ollama API
    if ! curl -s "$OLLAMA_API_URL/api/version" > /dev/null; then
        log_error "Ollama API not responding"
        send_notification "Ollama API not responding"
        return 1
    fi
    
    log_success "Ollama service ready"
    return 0
}

check_ollama_lab_service() {
    log_info "Checking Ollama-lab service..."
    
    # Check if service is running
    if systemctl is-active --quiet "$SERVICE_NAME" 2>/dev/null; then
        log_success "Ollama-lab service is running"
        return 0
    fi
    
    # Check if service exists but not running
    if systemctl list-unit-files | grep -q "$SERVICE_NAME"; then
        log_info "Starting Ollama-lab service..."
        sudo systemctl start "$SERVICE_NAME"
        sleep 3
        
        if systemctl is-active --quiet "$SERVICE_NAME"; then
            log_success "Ollama-lab service started"
            return 0
        else
            log_warning "Service failed to start, will run manually"
            return 1
        fi
    fi
    
    log_warning "Ollama-lab service not found, will run manually"
    return 1
}

launch_manual() {
    log_info "Launching Ollama-lab manually..."
    
    if [ ! -d "$OLLAMA_LAB_DIR" ]; then
        log_error "Ollama-lab directory not found: $OLLAMA_LAB_DIR"
        send_notification "Ollama-lab not found - run setup script first"
        return 1
    fi
    
    cd "$OLLAMA_LAB_DIR"
    
    # Check virtual environment
    if [ ! -d "venv" ]; then
        log_error "Python virtual environment not found"
        send_notification "Python environment missing - run setup script"
        return 1
    fi
    
    # Kill existing process if running
    pkill -f "python.*main.py" 2>/dev/null || true
    
    # Launch in background
    source venv/bin/activate
    nohup python main.py > /tmp/ollama-lab.log 2>&1 &
    
    # Store PID for later cleanup
    echo $! > /tmp/ollama-lab.pid
    
    log_info "Ollama-lab launched manually (PID: $!)"
    return 0
}

wait_for_service() {
    log_info "Waiting for Ollama-lab to be ready..."
    
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s "$OLLAMA_LAB_URL" > /dev/null 2>&1; then
            log_success "Ollama-lab is ready"
            return 0
        fi
        
        sleep 1
        ((attempt++))
    done
    
    log_error "Ollama-lab failed to start within 30 seconds"
    return 1
}

open_browser() {
    log_info "Opening browser..."
    
    # Try different browsers in order of preference
    local browsers=("firefox" "chromium" "google-chrome" "brave" "epiphany")
    
    for browser in "${browsers[@]}"; do
        if command -v "$browser" &> /dev/null; then
            log_info "Opening $browser..."
            nohup "$browser" "$OLLAMA_LAB_URL" > /dev/null 2>&1 &
            log_success "Browser opened"
            return 0
        fi
    done
    
    # Fallback to xdg-open
    if command -v xdg-open &> /dev/null; then
        log_info "Opening with xdg-open..."
        nohup xdg-open "$OLLAMA_LAB_URL" > /dev/null 2>&1 &
        log_success "Browser opened"
        return 0
    fi
    
    log_warning "No browser found, manual access required"
    send_notification "Open browser manually: $OLLAMA_LAB_URL"
    return 1
}

show_status() {
    echo ""
    echo -e "${GREEN}=== OLLAMA-LAB STATUS ===${NC}"
    echo -e "${BLUE}• URL: $OLLAMA_LAB_URL${NC}"
    echo -e "${BLUE}• Ollama API: $OLLAMA_API_URL${NC}"
    echo -e "${BLUE}• Service: $(systemctl is-active $SERVICE_NAME 2>/dev/null || echo 'manual')${NC}"
    echo -e "${BLUE}• Log: $LOG_FILE${NC}"
    echo ""
    
    # Show quick help
    echo -e "${YELLOW}Quick commands:${NC}"
    echo -e "${BLUE}• Stop service: sudo systemctl stop $SERVICE_NAME${NC}"
    echo -e "${BLUE}• View logs: journalctl -u $SERVICE_NAME -f${NC}"
    echo -e "${BLUE}• Manual stop: pkill -f 'python.*main.py'${NC}"
    echo ""
}

cleanup_on_exit() {
    # Clean up temporary files
    rm -f /tmp/ollama-lab.pid 2>/dev/null || true
}

main() {
    # Set up cleanup
    trap cleanup_on_exit EXIT
    
    # Clear log file
    > "$LOG_FILE"
    
    log_info "Launching Ollama-lab..."
    send_notification "Launching Ollama-lab..."
    
    # Check Ollama service first
    if ! check_ollama_service; then
        send_notification "Ollama service error - check logs"
        exit 1
    fi
    
    # Try to use systemd service first
    if ! check_ollama_lab_service; then
        # Fall back to manual launch
        if ! launch_manual; then
            send_notification "Failed to launch Ollama-lab"
            exit 1
        fi
    fi
    
    # Wait for service to be ready
    if ! wait_for_service; then
        send_notification "Ollama-lab startup timeout"
        exit 1
    fi
    
    # Open browser
    open_browser
    
    # Show status
    show_status
    
    log_success "Ollama-lab launched successfully!"
    send_notification "Ollama-lab ready at $OLLAMA_LAB_URL"
}

# Run in background if not already running
if [ "$1" != "--foreground" ]; then
    # Check if already running
    if curl -s "$OLLAMA_LAB_URL" > /dev/null 2>&1; then
        log_info "Ollama-lab already running"
        send_notification "Ollama-lab already running"
        open_browser
        exit 0
    fi
    
    # Launch in background
    nohup "$0" --foreground > /dev/null 2>&1 &
    exit 0
fi

main "$@"