#!/usr/bin/env bash

## Setup local environment for ansible scripting and remote nodes management.

havecmd() {
    type "$1" &> /dev/null
}
die() {
    echo -e "\nERROR: $@\n" && exit $1
}

if havecmd ansible; then 
    echo "Ansible installed."
else
    echo "Ansible not found, installing ..."
    [[ $EUID -eq 0 ]] || die 1 "Please run with sudo"

    if havecmd apt; then
        echo "Debian detected ..."
        sudo apt update
        sudo apt install -y git ansible
    elif havecmd dnf; then
        echo "RedHat detected ..."
        sudo dnf update
        sudo dnf install -y epel-release
        sudo dnf update
        sudo dnf install -y git ansible
    else
        die 2 "Neither APT nor DNF found"
    fi
fi

git pull
