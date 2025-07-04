# Ollama-lab Scripts

Complete automation scripts for Ollama-lab setup, management, and removal in Arch Linux + Hyprland environment.

## 📋 Overview

This collection provides three main scripts for managing Ollama-lab:

- **`setup-ollama-lab.sh`** - Complete setup and configuration
- **`launch-ollama-lab.sh`** - Launch application (F3 binding)
- **`remove-ollama-lab.sh`** - Complete removal and cleanup

## 🚀 Quick Start

### Initial Setup
```bash
# Navigate to scripts directory
cd ~/arch-dotfiles/scripts/ollama-lab/

# Make scripts executable
chmod +x *.sh

# Run complete setup
./setup-ollama-lab.sh
```

### Launch Application
```bash
# Press F3 (after setup) OR run manually:
./launch-ollama-lab.sh
```

### Remove Everything
```bash
# Complete removal
./remove-ollama-lab.sh
```

## 📝 Script Details

### setup-ollama-lab.sh

**Purpose**: Complete Ollama-lab setup and configuration

**Features**:
- ✅ Installs Ollama if not present
- ✅ Downloads and configures `gemma3:1b` model specifically
- ✅ Sets up Python virtual environment
- ✅ Installs all required dependencies
- ✅ Adds F3 binding to Hyprland configuration
- ✅ Creates systemd service for autostart (optional)
- ✅ Tests complete installation
- ✅ Provides status notifications

**Usage**:
```bash
./setup-ollama-lab.sh
```

**What it does**:
1. Checks system dependencies
2. Installs Ollama via official installer
3. Starts and enables Ollama service
4. Downloads `gemma3:1b` model (815 MB)
5. Sets up Python virtual environment
6. Installs FastAPI, Uvicorn, HTTPX, Pydantic, etc.
7. Adds F3 binding to `~/.config/hypr/hyprland.conf`
8. Creates systemd service for autostart
9. Runs integration tests
10. Shows final status and usage instructions

**Requirements**:
- Internet connection for downloads
- `sudo` access for service management
- Python 3.x installed
- Hyprland configuration file present

### launch-ollama-lab.sh

**Purpose**: Launch Ollama-lab application (executed by F3 binding)

**Features**:
- ✅ Checks Ollama service status
- ✅ Manages Ollama-lab service (systemd or manual)
- ✅ Waits for service readiness
- ✅ Opens browser automatically
- ✅ Provides error recovery
- ✅ Background execution support
- ✅ Status reporting

**Usage**:
```bash
# Manual launch
./launch-ollama-lab.sh

# Foreground mode (for debugging)
./launch-ollama-lab.sh --foreground
```

**What it does**:
1. Checks if Ollama service is running
2. Attempts to use systemd service first
3. Falls back to manual launch if needed
4. Waits for web interface to be ready
5. Opens browser to `http://localhost:8000`
6. Shows status and helpful commands
7. Runs in background by default

**Browser Priority**:
1. Firefox
2. Chromium
3. Google Chrome
4. Brave
5. Epiphany
6. xdg-open (fallback)

### remove-ollama-lab.sh

**Purpose**: Complete removal of Ollama-lab from system

**Features**:
- ✅ Stops and removes systemd service
- ✅ Removes F3 binding from Hyprland
- ✅ Removes Python virtual environment
- ✅ Removes Ollama models
- ✅ Optionally removes Ollama completely
- ✅ Cleans git status
- ✅ Verification of removal
- ✅ Confirmation prompts

**Usage**:
```bash
./remove-ollama-lab.sh
```

**What it does**:
1. Confirms removal with user
2. Stops and disables ollama-lab service
3. Removes service file and reloads systemd
4. Removes F3 binding from Hyprland config
5. Removes Python virtual environment
6. Removes `gemma3:1b` model
7. Optionally removes Ollama binary and data
8. Cleans up git repository status
9. Verifies complete removal

**Safety Features**:
- Confirmation prompts before destructive actions
- Separate prompt for complete Ollama removal
- Verification of removal completion
- Detailed status reporting

## 🔧 Configuration

### Hyprland F3 Binding

The setup script automatically adds this binding to your Hyprland config:

```conf
# Ollama-lab F3 binding
bind = , F3, exec, /home/user/arch-dotfiles/scripts/ollama-lab/launch-ollama-lab.sh
```

### Systemd Service

Optional systemd service for autostart:

```ini
[Unit]
Description=Ollama-lab Web Interface
After=network.target ollama.service
Requires=ollama.service

[Service]
Type=simple
User=user
WorkingDirectory=/home/user/arch-dotfiles/apps/ollama-lab
Environment=PATH=/home/user/arch-dotfiles/apps/ollama-lab/venv/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=/home/user/arch-dotfiles/apps/ollama-lab/venv/bin/python main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### Model Configuration

Default model: **gemma3:1b** (815 MB)
- Lightweight and fast
- Good for development and testing
- Suitable for most use cases

## 🛠️ Management Commands

### Service Management
```bash
# Start service
sudo systemctl start ollama-lab

# Stop service
sudo systemctl stop ollama-lab

# Enable autostart
sudo systemctl enable ollama-lab

# Disable autostart
sudo systemctl disable ollama-lab

# View logs
journalctl -u ollama-lab -f
```

### Manual Management
```bash
# Stop manual process
pkill -f "python.*main.py"

# Check if running
curl -s http://localhost:8000 > /dev/null && echo "Running" || echo "Not running"

# View application logs
tail -f /tmp/ollama-lab.log
```

### Ollama Management
```bash
# List models
ollama list

# Pull new model
ollama pull model-name

# Remove model
ollama rm model-name

# Ollama service
sudo systemctl status ollama
```

## 🔍 Troubleshooting

### Common Issues

**F3 binding not working**:
- Reload Hyprland config: `Super+Shift+R`
- Check binding exists: `grep -n "F3" ~/.config/hypr/hyprland.conf`

**Service won't start**:
- Check logs: `journalctl -u ollama-lab -n 20`
- Verify Ollama is running: `systemctl status ollama`
- Check Python environment: `ls ~/arch-dotfiles/apps/ollama-lab/venv/`

**Browser doesn't open**:
- Check available browsers: `which firefox chromium`
- Manual access: `http://localhost:8000`

**Model download fails**:
- Check internet connection
- Verify Ollama service: `curl http://localhost:11434/api/version`
- Check disk space: `df -h`

### Log Files

- **Launch log**: `/tmp/ollama-lab-launch.log`
- **Application log**: `/tmp/ollama-lab.log`
- **Service logs**: `journalctl -u ollama-lab`
- **Ollama logs**: `journalctl -u ollama`

### Recovery Steps

1. **Reset everything**:
   ```bash
   ./remove-ollama-lab.sh
   ./setup-ollama-lab.sh
   ```

2. **Restart services**:
   ```bash
   sudo systemctl restart ollama
   sudo systemctl restart ollama-lab
   ```

3. **Manual launch**:
   ```bash
   cd ~/arch-dotfiles/apps/ollama-lab/
   source venv/bin/activate
   python main.py
   ```

## 📊 Status Verification

After setup, verify everything is working:

```bash
# Check Ollama
systemctl status ollama
ollama list

# Check Ollama-lab
systemctl status ollama-lab
curl -s http://localhost:8000

# Check F3 binding
grep -A1 -B1 "F3" ~/.config/hypr/hyprland.conf
```

## 🎯 Integration with Arch-Dotfiles

These scripts are designed to integrate seamlessly with the arch-dotfiles project:

- **Location**: `~/arch-dotfiles/scripts/ollama-lab/`
- **Application**: `~/arch-dotfiles/apps/ollama-lab/`
- **Configuration**: Updates `~/.config/hypr/hyprland.conf`
- **Dependencies**: Uses `~/arch-dotfiles/packages/pacman-explicit.txt`

## 🔒 Security Notes

- Scripts require `sudo` only for service management
- Never run scripts as root user
- Ollama binds to localhost only by default
- No external network access required after setup
- Model data stored in secure user directories

## 📋 Dependencies

**System packages** (auto-installed):
- `curl` - For downloads and API checks
- `python3` - Runtime environment
- `systemctl` - Service management

**Python packages** (auto-installed):
- `fastapi>=0.115.0`
- `uvicorn[standard]>=0.34.0`
- `httpx>=0.28.0`
- `pydantic>=2.11.0`
- `python-multipart>=0.0.6`
- `websockets>=11.0`
- `aiofiles>=23.0`

**Arch packages** (available as system packages):
- `python-fastapi`
- `python-httpx`
- `python-pydantic`
- `uvicorn`

---

**Version**: 1.0.0  
**Compatible with**: Arch Linux + Hyprland  
**Model**: gemma3:1b  
**License**: MIT