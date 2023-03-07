# game-and-watch-noob-installer
A collection of scripts designed to help beginners setup their build environment and flash their Game &amp; Watch systems with greater ease.

This was previously hosted on my gist account, but I felt it would be better hosted here on Github for a number of reasons.

# Compatability
AMD64 (also known as x86_64, Intel 64). 64-bit Debian based Linux distributions.

- Ubuntu
- Linux Mint
- Kali Linux
- etc..

# TLDR;

Make both `.setup.sh` and `lcdsetup.sh` scripts executable and run in that order. lcdsetup is optional if you don't want G&W/LCD titles.

# Important!
You will need to set these files as executable before being able to run them. You can do so by entering `chmod +x setup.sh` or `chmod +x lcdsetup.sh` respectively from the terminal in the same directory as the script, or right click the file and under properties > permissions check the box to make the file executable so you can run it from the terminal `./setup.sh`

**Examples:**

From the Terminal:

![chmod terminal command example](https://github.com/DNA64/game-and-watch-noob-installer/blob/main/images/chmod.png)

From the UI:

![Executable permissions example](https://github.com/DNA64/game-and-watch-noob-installer/blob/main/images/permisions.png)


# setup.sh

The `setup.sh` script will clone and build both stacksmashing's [game-and-watch-backup](https://github.com/ghidraninja/game-and-watch-backup) and sylverb's fork of the [game-and-watch-retro-go](https://github.com/sylverb/game-and-watch-retro-go) Github repositories. It will also install all required submodules, drivers and dependencies. As well as install a the GCC toolchain and a custom build of OpenOCD that allows you to utilize hidden space on the Game & Watch.

The script will also add both OpenOCD and the GCC toolchain to your systems PATH. This is where a lot of users run into issues turning to the [Discord for support](https://discord.gg/rE2nHVAKvn).

It also downloads a public domain NES rom which is necessary to avoid error messages on initial building of `game-and-watch-retro-go` which leave some users confused and seeking answers as to why they're getting errors. This rom can be deleted once you've added your own, however, please try flashing your system first before adding anymore games or making any additional changes.

Once you've set the file permissions to executable you can run the script from the terminal using `./setup.sh`.

Upon completion you will need to unlock your Game & Watch if you haven't done so already. I will automate this step shortly as well, for now please follow the [steps outlined here](https://github.com/ghidraninja/game-and-watch-backup#usage).

# lcdsetup.sh

This step is optional **ONLY** if you don't plan on installing any LCD based games like the Game & Watch titles. If these titles are something you're interested in, then you will need to run `./lcdsetup.sh` after you've run the `setup.sh` file above.

I've written a [guide to LCD-Game-Shrinker](https://gist.github.com/DNA64/16fed499d6bd4664b78b4c0a9638e4ef) that you can view for more information. I will likely merge it here sometime in the near future. You'll want to start on **Step 7** if you've already used the `lcdsetup.sh` script here.
