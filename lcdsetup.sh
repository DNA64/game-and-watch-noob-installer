#!/bin/bash

# This script automates the setup of the Game & Watch Build Environment for Retro-Go.
# Copyright (C) 2021 DNA64 aka (viral_dna) / https://gist.github.com/DNA64

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

    # Logging
    LOG_FILE="$HOME/lcdsetup.log"

    # ANSI color codes
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color

function log(){
    local level="$1"
    shift
    local message="$@"
    local timestamp="[$(date '+%Y-%m-%d %H:%M:%S')]"
    local formatted="[$level] $message"

    # Log to file (no color)
    echo "$timestamp $formatted" >> "$LOG_FILE"

    # Log to terminal with color
    case "$level" in
        INFO)
            echo -e "${GREEN}$timestamp $formatted${NC}"
            ;;
        WARN)
            echo -e "${YELLOW}$timestamp $formatted${NC}"
            ;;
        ERROR)
            echo -e "${RED}$timestamp $formatted${NC}"
            ;;
        *)
            echo -e "$timestamp [UNKNOWN] $message"
            ;;
    esac
}

# Show GNU License
function show_gnu_license(){
    log INFO "Copyright (C) 2021  DNA64 aka (viral_dna)"
    log INFO "https://github.com/DNA64/game-and-watch-noob-installer"
    log INFO "This program comes with ABSOLUTELY NO WARRANTY."
    log INFO "This is free software, and you are welcome to redistribute it"
    log INFO "under certain conditions. See the LICENSE file for more details."
}

# Ensure Required Command Exists
function ensure_command(){
    local cmd=$1
    local pkg=${2:-$1}  # Default to same name if not specified
    if ! command -v "$cmd" &> /dev/null; then
        log WARN "Command '$cmd' not found. Installing package '$pkg'..."
        sudo apt update
        sudo apt install -y "$pkg"
        if command -v "$cmd" &> /dev/null; then
            log INFO "Successfully installed '$cmd'."
        else
            log ERROR "Failed to install '$cmd'."
            exit 1
        fi
    else
        log INFO "Command '$cmd' is already installed."
    fi
}

# Install Inkscape from source
function gnw_install_inkscape(){
    log INFO "Installing Inkscape from source..."

    # Ensure build tools
    ensure_command wget wget
    ensure_command cmake cmake
    ensure_command make build-essential

    # Install build dependencies
    sudo apt update
    sudo apt install -y pkg-config \
        libgtk-3-dev libglib2.0-dev libpango1.0-dev \
        libcairo2-dev libboost-dev libpoppler-dev \
        libpoppler-glib-dev libgsl-dev libgc-dev \
        libgtkmm-3.0-dev libxml2-dev libxslt1-dev \
        libjpeg-dev libpng-dev libtiff-dev \
        libsoup2.4-dev liblcms2-dev

    # Download and build Inkscape
    wget https://media.inkscape.org/dl/resources/file/inkscape-1.1.tar.xz
    tar -xf inkscape-1.1.tar.xz

    # Find the extracted directory
    INKSCAPE_SRC_DIR=$(tar -tf inkscape-1.1.tar.xz | head -1 | cut -f1 -d"/")
    cd "$INKSCAPE_SRC_DIR"
    mkdir build && cd build
    cmake ..
    make -j$(nproc)
    sudo make install
    cd ../..
}

# ─────────────────────────────────────────────────────────────
# Clone and Build LCD-Game-Shrinker
function gnw_clone_lcdgs(){
    log INFO "Cloning and Building LCD-Game-Shrinker..."
    ensure_command git git
    git clone https://github.com/bzhxx/LCD-Game-Shrinker
    cd LCD-Game-Shrinker

    log INFO "Installing Python dependencies..."
    ensure_command python3 python3
    ensure_command pip3 python3-pip
    python3 -m pip install -r requirements.txt

    cd ..
    gnw_install_inkscape
}

# ─────────────────────────────────────────────────────────────
# Prompt User to Install LCD-Game-Shrinker
function lcd_game_shrinker(){
    log INFO ""
    log INFO "Do you want to install bzhxx's LCD-Game-Shrinker and its dependencies?"
    log INFO "https://github.com/bzhxx/LCD-Game-Shrinker"
    log INFO ""
    log INFO "This is required for LCD handheld devices (Game & Watch, Konami, Tiger, Elektronika,...)."
    log INFO ""
    log INFO "Please enter 1 for Yes, or 2 for No.."
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) gnw_clone_lcdgs; break;;
            No ) log INFO "User declined installation. Exiting."; exit;;
        esac
    done
}

# ─────────────────────────────────────────────────────────────
# Run Script
log INFO "Starting Game & Watch Build Environment setup..."
show_gnu_license
lcd_game_shrinker
log INFO "Setup completed. See ../lcdsetup.log if you had issues."
