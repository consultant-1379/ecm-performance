#!/bin/sh
#set -x 
set -e

echo " opening firewall for port 12500..."
firewall-cmd --zone=public --add-port=12500/tcp --permanent

echo " verify port 12500 added to firewall "
firewall-cmd --list-all-zones | grep 12500

echo " reload the firewall for changes to take effect "
firewall-cmd --reload
