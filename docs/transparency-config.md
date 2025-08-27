# Transparency Configuration

## Overview
Configuration for transparent UI elements across the desktop environment.

## Components

### Kitty Terminal
- **File**: `~/.config/kitty/kitty.conf`
- **Transparency**: 70% opacity (30% transparent)
- **Theme**: Tokyo Night with transparency support
- **Dynamic controls**: `Ctrl+Shift+A+M/L` (may not work in Hyprland)

### Thunar File Manager
- **Hyprland rule**: `windowrulev2 = opacity 0.75, class:^(thunar)$`
- **GTK CSS**: Custom transparency with readable text
- **Features**:
  - Transparent background showing wallpaper
  - White text with black shadow for readability
  - Hover effects for navigation
  - Maintains icon and folder visibility

### GTK3 Configuration
- **File**: `~/.config/gtk-3.0/gtk.css`
- **Target**: Thunar file manager transparency
- **Text**: White with shadow for contrast on any wallpaper
- **Hover**: Subtle white overlay for UX feedback

## Manual Adjustments

### Kitty Transparency
Edit `~/.config/kitty/kitty.conf`:
```
background_opacity 0.70  # Adjust value 0.0-1.0
```

### Thunar Transparency  
Edit `~/.config/hypr/hyprland.conf`:
```
windowrulev2 = opacity 0.75, class:^(thunar)$  # Adjust opacity
```

### Text Contrast
Edit `~/.config/gtk-3.0/gtk.css` - modify color values in text sections.

## Notes
- All transparency configs work with dynamic wallpapers
- Text shadows ensure readability on any background
- Hover effects maintain usability
- Configuration synced with dotfiles repo