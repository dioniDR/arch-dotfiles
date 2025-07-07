#!/bin/bash

# =============================================================================
# setup-ollama-lab.sh - Complete Ollama-lab setup script
# =============================================================================
# Configures Ollama service, downloads gemma3:1b model, sets up F3 binding,
# and creates systemd service for autostart
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
        notify-send "Ollama-lab Setup" "$1"
    fi
}

check_dependencies() {
    log_info "Checking dependencies..."
    
    local deps=("curl" "python3" "systemctl")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing[*]}"
        exit 1
    fi
    
    log_success "All dependencies found"
}

install_ollama() {
    log_info "Installing Ollama..."
    
    if command -v ollama &> /dev/null; then
        log_success "Ollama already installed"
        return 0
    fi
    
    log_info "Downloading and installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
    
    if [ $? -eq 0 ]; then
        log_success "Ollama installed successfully"
        send_notification "Ollama installed successfully"
    else
        log_error "Failed to install Ollama"
        exit 1
    fi
}

start_ollama_service() {
    log_info "Starting Ollama service..."
    
    sudo systemctl enable ollama
    sudo systemctl start ollama
    
    # Wait for service to start
    sleep 3
    
    if systemctl is-active --quiet ollama; then
        log_success "Ollama service started"
    else
        log_error "Failed to start Ollama service"
        exit 1
    fi
}

download_model() {
    log_info "Downloading model: $OLLAMA_MODEL"
    
    # Check if model already exists
    if ollama list | grep -q "$OLLAMA_MODEL"; then
        log_success "Model $OLLAMA_MODEL already exists"
        return 0
    fi
    
    log_info "Downloading $OLLAMA_MODEL (this may take a while...)"
    send_notification "Downloading $OLLAMA_MODEL model..."
    
    if ollama pull "$OLLAMA_MODEL"; then
        log_success "Model $OLLAMA_MODEL downloaded successfully"
        send_notification "Model $OLLAMA_MODEL ready!"
    else
        log_error "Failed to download model $OLLAMA_MODEL"
        exit 1
    fi
}

setup_python_environment() {
    log_info "Setting up Python environment..."
    
    cd "$OLLAMA_LAB_DIR"
    
    # Create virtual environment if it doesn't exist
    if [ ! -d "venv" ]; then
        log_info "Creating Python virtual environment..."
        python3 -m venv venv
    fi
    
    # Activate and install dependencies
    source venv/bin/activate
    pip install -r requirements.txt
    
    log_success "Python environment ready"
}

setup_hyprland_binding() {
    log_info "Setting up Hyprland F3 binding..."
    
    if [ ! -f "$HYPRLAND_CONFIG" ]; then
        log_error "Hyprland config not found: $HYPRLAND_CONFIG"
        exit 1
    fi
    
    # Check if F3 binding already exists
    if grep -q "bind = , F3," "$HYPRLAND_CONFIG"; then
        log_warning "F3 binding already exists in Hyprland config"
        return 0
    fi
    
    # Add F3 binding to launch ollama-lab
    echo "" >> "$HYPRLAND_CONFIG"
    echo "# Ollama-lab F3 binding" >> "$HYPRLAND_CONFIG"
    echo "bind = , F3, exec, $HOME/arch-dotfiles/scripts/ollama-lab/launch-ollama-lab.sh" >> "$HYPRLAND_CONFIG"
    
    log_success "F3 binding added to Hyprland config"
}

create_systemd_service() {
    log_info "Creating systemd service for autostart..."
    
    cat > "/tmp/${SERVICE_NAME}.service" << EOF
[Unit]
Description=Ollama-lab Web Interface
After=network.target ollama.service
Requires=ollama.service

[Service]
Type=simple
User=$USER
WorkingDirectory=$OLLAMA_LAB_DIR
Environment=PATH=$OLLAMA_LAB_DIR/venv/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=$OLLAMA_LAB_DIR/venv/bin/python main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    sudo mv "/tmp/${SERVICE_NAME}.service" "$SERVICE_FILE"
    sudo systemctl daemon-reload
    
    log_success "Systemd service created"
}

enable_autostart() {
    read -p "Enable autostart for ollama-lab? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Enabling autostart..."
        sudo systemctl enable "$SERVICE_NAME"
        log_success "Autostart enabled"
    else
        log_info "Autostart not enabled (can be enabled later with: sudo systemctl enable $SERVICE_NAME)"
    fi
}

test_installation() {
    log_info "Testing installation..."
    
    # Test Ollama
    if ! ollama list | grep -q "$OLLAMA_MODEL"; then
        log_error "Model $OLLAMA_MODEL not found"
        exit 1
    fi
    
    # Test Python environment
    cd "$OLLAMA_LAB_DIR"
    source venv/bin/activate
    
    timeout 5s python main.py > /dev/null 2>&1 || true
    
    if [ $? -eq 124 ]; then
        log_success "Application test passed"
    else
        log_error "Application test failed"
        exit 1
    fi
}

main() {
    log_info "Starting Ollama-lab setup..."
    send_notification "Starting Ollama-lab setup..."
    
    check_dependencies
    install_ollama
    start_ollama_service
    download_model
    setup_python_environment
    setup_hyprland_binding
    create_systemd_service
    enable_autostart
    test_installation
    
    log_success "Ollama-lab setup completed successfully!"
    send_notification "Ollama-lab setup completed! Press F3 to launch."
    
    echo ""
    echo -e "${GREEN}=== SETUP COMPLETE ===${NC}"
    echo -e "${BLUE}• Press F3 to launch Ollama-lab${NC}"
    echo -e "${BLUE}• Web interface: http://localhost:8000${NC}"
    echo -e "${BLUE}• Model: $OLLAMA_MODEL${NC}"
    echo -e "${BLUE}• Autostart: $(systemctl is-enabled $SERVICE_NAME 2>/dev/null || echo 'disabled')${NC}"
    echo ""
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    log_error "Do not run this script as root"
    exit 1
fi

main "$@"