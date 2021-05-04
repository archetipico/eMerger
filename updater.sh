#!/bin/bash

printf "\n\n\n"
#DO NOT WRITE FROM HERE

printf "\n\n\n"
#DO NOT WRITE TO HERE

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
NORMAL=$(tput sgr0)

printProgress() {
    if [[ "$2" == "starting" ]]; then
	    printf "${RED}\n$1 $2\n${NORMAL}"
    else
	    printf "${GREEN}$1 $2\n${NORMAL}"
    fi
}

printf "${RED}This script requires sudo to run commands.\n${NORMAL}"
PKG=""
if [[ -n "$(command -v apt-get)" ]]; then
    PKG="apt-get"
    if [[ -n "$(command -v apt)" ]]; then
        PKG="apt"
    fi
    
    printf "${GREEN}System detected: ${RED}Using $PKG\n${NORMAL}"
    
    printProgress update: starting
    sudo $PKG update
    printProgress update: completed

    printProgress upgrade: starting
    sudo $PKG upgrade
    printProgress upgrade: completed

    printProgress autoclean: starting
    sudo $PKG autoclean
    printProgress autoclean: completed

    printProgress autoremove: starting
    sudo $PKG autoremove
    printProgress autoremove: completed
elif [[ -n "$(command -v yum)" ]]; then
    PKG="yum"
    if [[ -n "$(command -v dnf)" ]]; then
        PKG="dnf"
    fi

    printf "${GREEN}System detected: ${RED}Using $PKG\n${NORMAL}"

    printProgress update: starting
    sudo $PKG update
    printProgress update: completed

    printProgress upgrade: starting
    sudo $PKG upgrade
    printProgress upgrade: completed

    printProgress cleanAll: starting
    sudo $PKG clean all
    printProgress cleanAll: completed
elif [[ -n "$(command -v pacman)" ]]; then
    PKG="pacman"

    printf "${GREEN}System detected: ${RED}Using $PKG\n${NORMAL}"

    printProgress update: starting
    sudo $PKG -Syy
    printProgress update: completed

    printProgress upgrade: starting
    sudo $PKG -Syu
    printProgress upgrade: completed

    printProgress cleanAll: starting
    sudo $PKG -R $($PKG -Qtdq)
    printProgress cleanAll: completed
elif [[ -n "$(command -v emerge)" ]]; then
    PKG="emerge"

    printf "${GREEN}System detected: ${RED}Using $PKG\n${NORMAL}"

    printProgress syncing: starting
    $PKG --sync
    printProgress syncing: completed

    printProgress update: starting
    $PKG --update --deep --newuse --with-bdeps y @world --ask
    printProgress update: completed

    printProgress deepclean: starting
    emerge --depclean --ask
    revdep-rebuild
    printProgress deepclean: completed
else
    printf "${RED}System not supported${NORMAL}"
fi

printf "${RED}Showing files in .local/share/Trash/${NORMAL}\n"
ls ~/.local/share/Trash/
printf "Do you wanna clean trash?"
read -p "[y/n]: " answer 
if [[ "$answer" == "y" ]]; then
    sudo rm -rf ~/.local/share/Trash/*
    printProgress trash: cleaned
else
    printProgress trash: "not cleaned"
fi

printf "\n"
