#!/bin/bash

	# This script automates the setup of the Game & Watch Build Environment for Retro-Go.
	# Copyright (C) 2021 DNA64 aka (viral_dna)/ https://github.com/DNA64/game-and-watch-noob-installer

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

	export GCC_PATH="/opt/gcc-arm-none-eabi/bin/"
	export OPENOCD="/opt/openocd-git/bin/openocd"
	export PATH="$PATH:$GCC_PATH"
	export FILEA="$HOME/.bashrc"
	export FILEB="$HOME/.gnw_aliases"
	export FILEC="$HOME/.do_not_remove_aliases"
	export FILED="$HOME/.do_not_remove_gcc"

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
	
	# Update Linux
	function gnw_update_linux(){
	echo "Checking for updates.."
	echo "Please enter your password when asked.."
	sudo apt-get update
	sudo apt-get upgrade
	}
	
	# Install required tools:
	function gnw_install_tools(){
	sudo apt-get -y install wget binutils-arm-none-eabi python3 python3-pip git libhidapi-hidraw0 libftdi1 libftdi1-2 lz4
	}

	# Install openocd:
	function gnw_install_openocd(){
	echo "Installing Custom OpenOCD to allow write access to hidden memory banks.."
	wget -nc --progress=bar https://nightly.link/kbeckmann/ubuntu-openocd-git-builder/workflows/docker/master/openocd-git.deb.zip
	unzip openocd-git.deb.zip
	sudo dpkg -i openocd-git_*_amd64.deb
	sudo apt-get -y -f install
	}
	
	# Install GCC 10:
	function gnw_install_gcc(){
	echo "Installing GCC Toolchain.."
	wget -nc --progress=bar https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2
	tar -jxvf gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 --directory .
	sudo mv gcc-arm-none-eabi-10-2020-q4-major /opt/gcc-arm-none-eabi
	}
	
	# Clone and build game-and-watch-backup
	function gnw_clone_backup(){
	echo "Cloning and Building game-and-watch-backup.."
	git clone --recurse-submodules https://github.com/ghidraninja/game-and-watch-backup
	}
	
	# Clone and build flashloader 'Replaced by flashapp'
	function gnw_clone_flashloader(){
	git clone https://github.com/ghidraninja/game-and-watch-flashloader
	cd game-and-watch-flashloader
	make -j$(nproc)
	cd ..
	}

	# Install python dependencies
	function gnw_install_py(){
	cd game-and-watch-retro-go	
	echo "Installing Python dependencies.."
	python3 -m pip install -r requirements.txt
	cd ..
	}
	
	# Clone and build game-and-watch-retro-go
	function gnw_clone_retrogo(){
	echo "Cloning and Building game-and-watch-retro-go.."
	git clone --recurse-submodules https://github.com/sylverb/game-and-watch-retro-go
	cd game-and-watch-retro-go/roms/nes
	wget -nc --progress=bar https://x0.at/4deS.nes
	mv 4deS.nes BladeBuster.nes
	cd ../../
	make -j$(nproc)
	cd ..
	}
	
	# Clean up
	function gnw_auto_remove(){
	echo "Removing any unneeded dependencies.."
	sudo apt autoremove
	echo "Removing installation files.."
	echo ""
	echo "Press Y/y to remove or N/n to keep installation packages when asked.."
	echo "You can keep them or delete them, it doesn't matter."
	sudo rm -i *.deb *.zip *.bz2
	echo ""
	echo "All done!"
	echo "You must close this terminal window for changes to take effect"
	echo "before attempting to unlock, backup and flash your Game & Watch."
	echo "Please report any issues you find and I will do my best to fix them."
	echo " - DNA64 aka (viral_dna)"
	}
	
	function gnw_bashrc_update(){
	echo "if [ -f ~/.gnw_aliases ]; then"
	echo ". ~/.gnw_aliases"
	echo "fi"
	}

	function gnw_gcc_update(){
	echo "# Persistent GCC Path"
	echo "export OPENOCD=/opt/openocd-git/bin/openocd"
	echo "GCC_PATH=/opt/gcc-arm-none-eabi/bin/"
	echo "PATH=\$PATH:\$GCC_PATH:\$OPENOCD"
	}
	
	# Prevents spamming duplicate entries in ~/.gnw_aliases if script is run again for any reason
	function gnw_check_aliases(){
	if [ -f "$FILEC" ]; then
	echo "GCC_PATH was already added to the PATH"
	echo "OPENOCD was already added to the PATH"
	echo "GCC_PATH is: $GCC_PATH"
	echo "OPENOCD path is: $OPENOCD"
	echo "PATH is now: $PATH"
	else
	touch "$FILEB"
	gnw_gcc_update >> "$FILEB"
	echo "GCC_PATH was added to PATH"
	echo "OPENOCD was added to PATH"
	echo "PATH is now: $PATH"
	touch "$FILEC"
	fi
	}

	function gnw_gcc_check(){
	if [ -f "$FILED" ]; then
	echo "~/.bashrc is already updated to include aliases from ~/.gnw_aliases"
	else
	gnw_bashrc_update >> "$FILEA" # Appends the ~/.bashrc file with the contents of gnw_bashrc_update function.
	echo "~/.bashrc was updated to include aliases from ~/.gnw_aliases"
	touch "$FILED"
	fi
	}
	
	# Function Calls
	show_gnu_license
	gnw_update_linux
	gnw_install_tools
	gnw_install_openocd
	gnw_install_gcc
	gnw_clone_backup
	#gnw_clone_flashloader
	gnw_clone_retrogo
	gnw_check_aliases
	gnw_gcc_check
	gnw_install_py
	gnw_auto_remove
