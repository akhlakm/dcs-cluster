#!/usr/bin/env bash

## USAGE:
## curl https://raw.githubusercontent.com/akhlakm/home-cluster/stream/setup.sh | sudo bash

havecmd() {
    type "$1" &> /dev/null
}
die() {
    echo -e "\nERROR: $@" && exit $1
}

[[ $EUID -eq 0 ]] || die 1 "Please run with SUDO"

if havecmd apt; then
    sudo apt update
    sudo apt install -y git ansible openssh-server
elif havecmd dnf; then
    sudo dnf update
    sudo dnf install epel-release
    sudo dnf update
    sudo dnf install git ansible
else
    die 2 "Neither APT nor DNF found"
fi

BRANCH="stream"
REPO="https://github.com/akhlakm/home-cluster.git"
sudo ansible-pull -U $REPO -C $BRANCH -i hosts.yml pb-setup.yml

[[ -f $HOME/.ssh/authorized_keys ]] || echo "Note: No public ssh keys found!"
