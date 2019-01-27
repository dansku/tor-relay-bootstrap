#!/bin/bash

# check for sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as sudo" 1>&2
    exit 1
fi

PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# update software
apt update
apt dist-upgrade -y

# install extra apps
apt install -y lsb-release apt-transport-https mosh vnstat bmon htop python-setuptools

# configure firewall rules
echo "== Configuring firewall rules"
apt-get install -y debconf-utils
echo "iptables-persistent iptables-persistent/autosave_v6 boolean true" | debconf-set-selections
echo "iptables-persistent iptables-persistent/autosave_v4 boolean true" | debconf-set-selections
apt-get install -y iptables iptables-persistent
cp $PWD/etc/iptables/rules.v4 /etc/iptables/rules.v4
cp $PWD/etc/iptables/rules.v6 /etc/iptables/rules.v6
chmod 600 /etc/iptables/rules.v4
chmod 600 /etc/iptables/rules.v6
iptables-restore < /etc/iptables/rules.v4
ip6tables-restore < /etc/iptables/rules.v6

# install fail2ban
apt install -y fail2ban

# install ntp (tlsdate is no longer available in Debian stable)
apt install -y ntp

## install tor and nyx
apt install -y tor
easy_install pip
pip install nyx

# make sure tor is not running
killall tor

# copy config file 
cp $PWD/etc/tor/torrc /etc/tor/torrc

# give user permission to files and folders
chown -R $USER:$USER /home/tor/.tor
chown -R $USER:$USER /var/lib/tor/
chown -R $USER:$USER /var/log/tor/

echo "Done, now just type tor to start application and use nyx to monitore it. Enjoy :)"