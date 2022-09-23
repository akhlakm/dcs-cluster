#!/usr/bin/env bash

## Setup local environment for ansible scripting and remote nodes management.

havecmd() {
    type "$1" &> /dev/null
}
die() {
    echo -e "\nERROR: $@\n" && exit $1
}

ansible_config() {
    # Set the ansible.cfg location to cwd
    if [[ "$ANSIBLE_CONFIG" == "ansible.cfg" ]];
    then 
        echo "OK -- ANSIBLE_CONFIG is set to CWD/ansible.cfg"
    else
        if [[ -f ~/.bash_aliases ]];
        then
            echo "export ANSIBLE_CONFIG=ansible.cfg" >> ~/.bash_aliases
        else 
            echo "export ANSIBLE_CONFIG=ansible.cfg" >> ~/.bashrc
        fi
        echo "OK -- ANSIBLE_CONFIG has been set to CWD/ansible.cfg"
        echo "NOTE: Please source your bashrc"
    fi
}

check_install_ansible() {
    if havecmd ansible;
    then 
        echo "OK -- Ansible installed."
    else
        echo "Ansible not found, installing ..."
        [[ $EUID -eq 0 ]] || die 1 "Please run with sudo"

        if havecmd apt;
        then
            echo "Debian detected ..."
            sudo apt update
            sudo apt install -y git ansible
        elif havecmd dnf;
        then
            echo "RedHat detected ..."
            sudo dnf update
            sudo dnf install -y epel-release
            sudo dnf update
            sudo dnf install -y git ansible
        else
            die 2 "Neither APT nor DNF found"
        fi
    fi
}

check_etc_hosts() {
    # Check if all the host IPs are in /etc/hosts
    echo "IP addresses defined in /etc/hosts ..."
    for host in host_vars/*;
    do
        host=$(basename $host)
        case `grep $host /etc/hosts >/dev/null; echo $?` in
            0)
                # code if found
                grep $host /etc/hosts
                # ping once
                if ping -q -c 1 $host > /dev/null
                then
                    echo "  ping OK"
                else
                    echo "  WARN: Ping to '$host' failed."
                fi
                ;;
            1)
                # code if not found
                echo "  WARN: '$host' not found in /etc/hosts"
                echo "  Please edit /etc/hosts and set its IP address."
                ;;
            *)
                # code if an error occurred
                die 3 "Cannot read /etc/hosts, please use chmod 0644"
                ;;
        esac
    done
}

ansible_config
check_install_ansible
check_etc_hosts
