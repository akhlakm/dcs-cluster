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
    sudo apt install git ansible
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

git clone --depth 5 --branch $BRANCH $REPO
ansible-playbook -i home-cluster/hosts.yml home-cluster/pb-setup.yml
