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
    echo "Installing Inkscape package (Required by LCD-Game-Shrinker)"
    sudo add-apt-repository ppa:inkscape.dev/stable
    sudo apt-get update
    sudo apt install inkscape
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
