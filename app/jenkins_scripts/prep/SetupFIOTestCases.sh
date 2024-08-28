#!/bin/sh
PASS="ecm123"

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1
nodes=$(get_BladesHost $system)
echo "Nodes: "$nodes

for host_name in $nodes
do
	echo "Preparing host "$host_name
	sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
	sshpass -p $PASS scp -r /app/jenkins_scripts/prep/FIO/ root@$host_name:/root/
	echo "Done."
done
