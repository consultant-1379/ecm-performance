#!/bin/sh

host_name=$1
PASS=$2
OS=$3

echo "Performing network prerequisites ..."
sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
sshpass -p $PASS ssh root@$host_name systemctl disable firewalld
sshpass -p $PASS ssh root@$host_name systemctl stop firewalld
sshpass -p $PASS ssh root@$host_name systemctl disable NetworkManager 
sshpass -p $PASS ssh root@$host_name systemctl stop NetworkManager
sshpass -p $PASS ssh root@$host_name systemctl enable network
sshpass -p $PASS ssh root@$host_name systemctl start network

echo "Install openstack repository centos-release-openstack-"$OS
sshpass -p $PASS ssh root@$host_name yum install -y centos-release-openstack-$OS
sshpass -p $PASS ssh root@$host_name yum update -y
sshpass -p $PASS ssh root@$host_name yum install -y openstack-packstack
sshpass -p $PASS ssh root@$host_name packstack --allinone --dry-run
echo "Done."
