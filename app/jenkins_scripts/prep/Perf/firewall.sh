#!/bin/sh

echo "Stopping iptables ..."
service iptables stop

# for RHEL 7.x
echo "Stopping firewalld ..."
service firewalld stop
