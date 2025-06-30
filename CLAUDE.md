# Arch-Dotfiles Project Context

## Project Overview
**Type**: Linux dotfiles configuration  
**OS**: Arch Linux + Hyprland (Wayland)  
**Status**: 85% functional, active development  
**Purpose**: Complete desktop environment setup

## Quick Architecture
```
arch-dotfiles/
├── config/hypr/         # Hyprland WM (main: hyprland.conf)
├── config/waybar/       # Status bar (config.jsonc + style.css)  
├── config/wofi/         # App launcher with blur
├── packages/            # pacman + AUR package lists
└── scripts/             # Automation (install, export, waybar tools)
```

## Current System State
- **Active**: Hyprland ✅, Waybar ✅, Audio system ✅
- **Modified files**: hyprland.conf, waybar configs, package lists
- **New features**: Claude optimization, audio scripts, safe waybar editor
- **Git status**: Active development branch

## Key Files & Purposes
| File | Purpose | Status |
|------|---------|--------|
| `config/hypr/hyprland.conf` | Main WM configuration | Modified |
| `config/waybar/config.jsonc` | Status bar layout/modules | Modified |  
| `config/waybar/style.css` | Status bar styling | Active |
| `packages/pacman-explicit.txt` | Official packages (110+) | Updated |
| `scripts/install.sh` | Full system installation | Core |
| `scripts/export-personal.sh` | Config export workflow | Core |
| `scripts/waybar-safe-editor.sh` | Safe waybar modifications | New |

## Package Ecosystem
- **Official**: 110 packages (hyprland, waybar, wofi, kitty, mako, etc.)
- **AUR**: 8 specialized packages
- **Config directories**: 26 in ~/.config

## Development Workflow
1. **Modify configs** → Live system updates
2. **Export changes** → `scripts/export-personal.sh`  
3. **Safe waybar edits** → `scripts/waybar-safe-editor.sh`
4. **Version control** → Git with selective commits

## Architecture Patterns
- **Modular**: Separate config per component
- **Script-driven**: Bash automation for all operations  
- **Live sync**: Real-time config ↔ system state
- **Safe modifications**: Backup + rollback system

## Critical Dependencies
```
Hyprland (WM) → Waybar (status) → Scripts (management)
Config files → Live system (immediate effect)
Export script → Package lists (system sync)
```

## Common Tasks Context
- **Waybar modifications**: Use `waybar-safe-editor.sh` (has backup/rollback)
- **Package management**: Edit package files → run export script
- **System installation**: `scripts/install.sh` (full automation)
- **Config navigation**: `./nav.sh` for project exploration

## Current Issues & Focus Areas
- Audio system integration (PulseAudio + PipeWire)
- Waybar customization (safe modification system)
- Package list maintenance (sync with system)
- Configuration optimization (Claude Code integration)

---
*This context represents 80% of project knowledge in 20% of tokens for optimal Claude Code interaction.*
