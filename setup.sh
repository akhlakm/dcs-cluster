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
        echo "OK -- ANSIBLE_CONFIG is set to ./ansible.cfg"
    else
        export ANSIBLE_CONFIG=ansible.cfg
        echo "OK -- ANSIBLE_CONFIG has been set to ./ansible.cfg"
    fi
}

check_install_ansible() {
    if havecmd ansible;
    then 
        echo "OK -- Ansible found"
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

    # Build the etc_hosts
    echo "# Auto generated /etc/hosts by ./setup.sh" > etc_hosts
    echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> etc_hosts
    echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> etc_hosts

    # Check each defined host
    for host in host_vars/*;
    do
        host=$(basename $host)
        case `grep $host /etc/hosts >/dev/null; echo $?` in
            0)
                # code if found
                grep $host /etc/hosts | tee -a etc_hosts

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

    echo "OK -- etc_hosts generated. Please update if necessary."
    echo "------------------------------------------------------"
    cat etc_hosts
    echo "------------------------------------------------------"
}

check_ssh_pubkey() {
    if [[ $(find ~/.ssh -name "id_*.pub") == "" ]]
    then
        echo "No SSH public key found, please generate one ..."
        ssh-keygen -t ed25519 -C "${HOSTNAME}"
    else
        echo "OK -- ssh pubkey file"
    fi
}

check_ansible_ping() {
    echo "Checking ansible ping, please provide remote machines password ..."
    ansible all -m ping -k
}

check_install_ansible
ansible_config
# check_etc_hosts
check_ssh_pubkey
# check_ansible_ping
