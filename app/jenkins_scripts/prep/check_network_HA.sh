#!/bin/sh

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

PASS="ecm123"

system=$1
nodes=$(get_ABCDHost $system)
echo "Nodes: "$nodes
for host_name in $nodes
do
        echo "Copying script IPs_check.sh to check IPs on ABCD host"
        sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
        sshpass -p $PASS scp -r /app/jenkins_scripts/prep/IPs_check.sh root@$host_name:/ecm-umi/install/kvm/
	echo " Run script IPs_check.sh on ABCD host"
        sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
	eval sshpass -p $PASS ssh root@$host_name /ecm-umi/install/kvm/IPs_check.sh
        echo "Done."
done
