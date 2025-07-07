#!/bin/bash

# =============================================================================
# remove-ollama-lab.sh - Complete Ollama-lab removal script
# =============================================================================
# Removes Ollama service, models, F3 binding, systemd service, and optionally
# removes Ollama completely from the system
# =============================================================================

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
OLLAMA_MODEL="gemma3:1b"
OLLAMA_LAB_DIR="$HOME/arch-dotfiles/apps/ollama-lab"
HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"
SERVICE_NAME="ollama-lab"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

send_notification() {
    if command -v notify-send &> /dev/null; then
        notify-send "Ollama-lab Removal" "$1"
    fi
}

confirm_removal() {
    echo -e "${YELLOW}WARNING: This will remove Ollama-lab completely${NC}"
    echo "This includes:"
    echo "• Ollama-lab systemd service"
    echo "• F3 binding from Hyprland"
    echo "• Python virtual environment"
    echo "• Ollama models (including $OLLAMA_MODEL)"
    echo "• Optionally: Ollama binary and service"
    echo ""
    
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Removal cancelled"
        exit 0
    fi
}

stop_and_remove_service() {
    log_info "Stopping and removing ollama-lab service..."
    
    # Stop service if running
    if systemctl is-active --quiet "$SERVICE_NAME" 2>/dev/null; then
        sudo systemctl stop "$SERVICE_NAME"
        log_success "Ollama-lab service stopped"
    fi
    
    # Disable service if enabled
    if systemctl is-enabled --quiet "$SERVICE_NAME" 2>/dev/null; then
        sudo systemctl disable "$SERVICE_NAME"
        log_success "Ollama-lab service disabled"
    fi
    
    # Remove service file
    if [ -f "$SERVICE_FILE" ]; then
        sudo rm "$SERVICE_FILE"
        sudo systemctl daemon-reload
        log_success "Ollama-lab service file removed"
    fi
}

remove_hyprland_binding() {
    log_info "Removing F3 binding from Hyprland..."
    
    if [ ! -f "$HYPRLAND_CONFIG" ]; then
        log_warning "Hyprland config not found: $HYPRLAND_CONFIG"
        return 0
    fi
    
    # Remove F3 binding and comment line
    sed -i '/# Ollama-lab F3 binding/d' "$HYPRLAND_CONFIG"
    sed -i '/bind = , F3, exec.*ollama-lab/d' "$HYPRLAND_CONFIG"
    
    log_success "F3 binding removed from Hyprland config"
}

remove_python_environment() {
    log_info "Removing Python virtual environment..."
    
    if [ -d "$OLLAMA_LAB_DIR/venv" ]; then
        rm -rf "$OLLAMA_LAB_DIR/venv"
        log_success "Python virtual environment removed"
    else
        log_warning "Python virtual environment not found"
    fi
}

remove_ollama_model() {
    log_info "Removing Ollama model: $OLLAMA_MODEL"
    
    if command -v ollama &> /dev/null; then
        if ollama list | grep -q "$OLLAMA_MODEL"; then
            ollama rm "$OLLAMA_MODEL"
            log_success "Model $OLLAMA_MODEL removed"
        else
            log_warning "Model $OLLAMA_MODEL not found"
        fi
    else
        log_warning "Ollama not found, skipping model removal"
    fi
}

remove_ollama_completely() {
    read -p "Do you want to remove Ollama completely? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Removing Ollama completely..."
        
        # Stop ollama service
        if systemctl is-active --quiet ollama 2>/dev/null; then
            sudo systemctl stop ollama
        fi
        
        # Disable ollama service
        if systemctl is-enabled --quiet ollama 2>/dev/null; then
            sudo systemctl disable ollama
        fi
        
        # Remove ollama service file
        if [ -f "/etc/systemd/system/ollama.service" ]; then
            sudo rm "/etc/systemd/system/ollama.service"
        fi
        
        # Remove ollama binary
        if [ -f "/usr/local/bin/ollama" ]; then
            sudo rm "/usr/local/bin/ollama"
        fi
        
        # Remove ollama data directory
        if [ -d "/usr/share/ollama" ]; then
            sudo rm -rf "/usr/share/ollama"
        fi
        
        # Remove ollama user data
        if [ -d "$HOME/.ollama" ]; then
            rm -rf "$HOME/.ollama"
        fi
        
        sudo systemctl daemon-reload
        log_success "Ollama completely removed"
    else
        log_info "Keeping Ollama installed"
    fi
}

clean_git_status() {
    log_info "Cleaning up git status..."
    
    cd "$HOME/arch-dotfiles"
    
    # Remove any tracked changes to ollama-lab files
    if git status --porcelain | grep -q "apps/ollama-lab"; then
        git reset HEAD apps/ollama-lab/ 2>/dev/null || true
    fi
    
    log_success "Git status cleaned"
}

verify_removal() {
    log_info "Verifying removal..."
    
    local issues=()
    
    # Check service
    if systemctl is-active --quiet "$SERVICE_NAME" 2>/dev/null; then
        issues+=("Service $SERVICE_NAME is still running")
    fi
    
    # Check F3 binding
    if grep -q "bind = , F3.*ollama-lab" "$HYPRLAND_CONFIG" 2>/dev/null; then
        issues+=("F3 binding still present in Hyprland config")
    fi
    
    # Check virtual environment
    if [ -d "$OLLAMA_LAB_DIR/venv" ]; then
        issues+=("Python virtual environment still exists")
    fi
    
    if [ ${#issues[@]} -eq 0 ]; then
        log_success "Removal verification passed"
    else
        log_warning "Some issues found:"
        for issue in "${issues[@]}"; do
            echo "  • $issue"
        done
    fi
}

main() {
    log_info "Starting Ollama-lab removal..."
    send_notification "Starting Ollama-lab removal..."
    
    confirm_removal
    stop_and_remove_service
    remove_hyprland_binding
    remove_python_environment
    remove_ollama_model
    remove_ollama_completely
    clean_git_status
    verify_removal
    
    log_success "Ollama-lab removal completed!"
    send_notification "Ollama-lab removed successfully"
    
    echo ""
    echo -e "${GREEN}=== REMOVAL COMPLETE ===${NC}"
    echo -e "${BLUE}• Ollama-lab service: Removed${NC}"
    echo -e "${BLUE}• F3 binding: Removed${NC}"
    echo -e "${BLUE}• Python environment: Removed${NC}"
    echo -e "${BLUE}• Model $OLLAMA_MODEL: Removed${NC}"
    echo -e "${BLUE}• Ollama binary: $(command -v ollama &> /dev/null && echo 'Still installed' || echo 'Removed')${NC}"
    echo ""
    echo -e "${YELLOW}Note: You may need to reload Hyprland config (Super+Shift+R)${NC}"
    echo ""
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    log_error "Do not run this script as root"
    exit 1
fi

main "$@"