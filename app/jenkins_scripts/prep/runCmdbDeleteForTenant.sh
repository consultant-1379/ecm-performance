#!/bin/sh
source /app/jenkins_scripts/prep/nodes.performance
PASS="ecm123"

host_name=$1


cd /app/ecm/tools/cmdb/cmdb-util/util





eval nodes=\$$nodes
echo "Nodes: "$nodes
for host_name in $nodes
do
	echo "Preparing host "$host_name
	sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
	sshpass -p $PASS scp -r /app/jenkins_scripts/prep/Perf root@$host_name:/root/Perf
	sshpass -p $PASS ssh root@$host_name /root/Perf/install.sh
	echo "Done."
done
