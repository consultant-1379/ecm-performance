#!/bin/sh

PASS="ecm123"

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1
nodes=$(get_CoreVMs $system)
echo "Nodes: "$nodes

for host_name in $nodes
do
       echo " Checking ECM version on Core "
       sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name ecmversion | grep openam | awk '{print $2}' | cut -c1-10
       echo "Done."
done
