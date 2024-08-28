#!/bin/sh

set -e 

echo -e "\nStarting `basename $0` as `whoami`:"

echo -e "\nopening firewall for port 4444:"
sudo firewall-cmd --zone=public --add-port=4444/tcp --permanent
sudo firewall-cmd --zone=public --add-port=4444/udp --permanent

echo -e "\nverify port 4444 added to firewall:"
sudo firewall-cmd --list-all-zones | grep 4444

##echo " opening firewall for port 12500..."
##firewall-cmd --zone=public --add-port=12500/tcp --permanent

##echo " verify port 12500 added to firewall "
##firewall-cmd --list-all-zones | grep 12500

echo -e "\nreload the firewall for changes to take effect:"
sudo firewall-cmd --reload
