#!/bin/bash

# This script sets up user configs and systemd services only.
# Usage: ./setup_configs.sh [backup_dir]
# If backup_dir is not provided, the current directory is used.

set -euo pipefail

# Ensure home directory exists
if [ ! -d "$HOME" ]; then
    echo "Error: Home directory '$HOME_DIR' does not exist."
    exit 1
fi

BACKUP_DIR="${1:-.}"
CONFIG_DIR="$HOME/.config"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
SYSTEMD_USER_DIR="$CONFIG_DIR/systemd/user"

# Ensure backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Backup directory '$BACKUP_DIR' does not exist."
    exit 1
fi

# Create necessary directories
mkdir -p "$CONFIG_DIR" "$SYSTEMD_USER_DIR" "$HOME/.swaylock" "$WALLPAPER_DIR"

# Copy configs
echo "Copying configs..."
cp -r "$BACKUP_DIR/fuzzel" "$CONFIG_DIR/"
cp -r "$BACKUP_DIR/mako" "$CONFIG_DIR/"
cp -r "$BACKUP_DIR/niri" "$CONFIG_DIR/"
cp -r "$BACKUP_DIR/swaylock" "$HOME_DIR/.swaylock/"
cp -r "$BACKUP_DIR/waybar" "$CONFIG_DIR/"
cp -r "$BACKUP_DIR/waypaper" "$CONFIG_DIR/"
cp -r "$BACKUP_DIR/images" "$WALLPAPER_DIR"

# Copy systemd user services
echo "Copying systemd user services..."
cp -r "$BACKUP_DIR/systemd/user/"* "$SYSTEMD_USER_DIR/"

# Create service dependencies 
systemctl --user add-wants niri.service mako.service
systemctl --user add-wants niri.service waybar.service
systemctl --user add-wants niri.service swayidle.service
systemctl --user add-wants niri.service waypaper.service

# Reload systemd user daemon
echo "Reloading systemd user daemon..."
systemctl --user daemon-reload

# Enable and start services
echo "Enabling and starting services..."
systemctl --user enable --now waybar-restart.path

echo "Setup complete!"

