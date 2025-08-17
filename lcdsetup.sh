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
    
    # License
    function show_gnu_license(){
    echo ""
    echo "Copyright (C) 2021  DNA64 aka (viral_dna)"
    echo "https://github.com/DNA64/game-and-watch-noob-installer"
    echo "This program comes with ABSOLUTELY NO WARRANTY."
    echo "This is free software, and you are welcome to redistribute it"
    echo "under certain conditions. See the LICENSE file for more details."
    echo ""
    echo ""
    }

    # Install Inkscape
function gnw_install_inkscape(){
    echo "Checking Ubuntu release..."

    # Get Ubuntu codename (e.g., 'focal', 'jammy', 'mantic')
    UBUNTU_CODENAME=$(lsb_release -c | awk '{print $2}')

    # List of stable Ubuntu codenames
    STABLE_RELEASES=("focal" "jammy" "noble")

    if [[ " ${STABLE_RELEASES[@]} " =~ " ${UBUNTU_CODENAME} " ]]; then
        echo "Detected stable release: ${UBUNTU_CODENAME}"
        echo "Installing Inkscape from PPA..."
        sudo add-apt-repository -y ppa:inkscape.dev/stable-1.1
        sudo apt-get update
        sudo apt install -y inkscape
    else
        echo "Detected interim release: ${UBUNTU_CODENAME}"
        echo "Installing Inkscape from source..."

        # Install build dependencies
        sudo apt update
        sudo apt install -y build-essential cmake pkg-config \
            libgtk-3-dev libglib2.0-dev libpango1.0-dev \
            libcairo2-dev libboost-dev libpoppler-dev \
            libpoppler-glib-dev libgsl-dev libgc-dev \
            libgtkmm-3.0-dev libxml2-dev libxslt1-dev \
            libjpeg-dev libpng-dev libtiff-dev

        # Download and build Inkscape
        wget https://media.inkscape.org/dl/resources/file/inkscape-1.1.tar.xz
        tar -xf inkscape-1.1.tar.xz
        cd inkscape-1.1
        mkdir build && cd build
        cmake ..
        make -j$(nproc)
        sudo make install
        cd ../..
    fi
}

    # Clone and Build LCD-Game-Shrinker
    function gnw_clone_lcdgs(){
    echo "Cloning and Building LCD-Game-Shrinker.."
    git clone https://github.com/bzhxx/LCD-Game-Shrinker
    cd LCD-Game-Shrinker
    echo "Installing Python dependencies.."
    python3 -m pip install -r requirements.txt
    cd ..
    gnw_install_inkscape
    }

    # Since not everyone may want to install G&W games, I've kept this part optional.
    function lcd_game_shrinker(){
    echo ""
    echo "" 
    echo "Do you want to install bzhxx's LCD-Game-Shrinker and it's dependencies?"
    echo "https://github.com/bzhxx/LCD-Game-Shrinker"
    echo ""
    echo "This is required for LCD handheld devices (Game & Watch, Konami, Tiger, Elektronika,...)."
    echo ""
    echo "Please enter 1 for Yes, or 2 for No.."
    select yn in "Yes" "No"; do
    case $yn in
    Yes ) gnw_clone_lcdgs; break;;
    No ) exit;;
    esac
    done
    }
   
    show_gnu_license
    lcd_game_shrinker
