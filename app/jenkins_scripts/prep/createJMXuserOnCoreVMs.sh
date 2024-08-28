#!/bin/sh
#source /app/jenkins_scripts/prep/coreVMs.performance
ADMIN="osadm"
PASS="vFd0_hMpbm34"

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1
nodes=$(get_CoreVMs $system)
echo -e "\nNodes: "$nodes

for host_name in $nodes
do
	echo -e "\nPreparing host (checking uptime):"$host_name
	sshpass -p $PASS ssh -oStrictHostKeyChecking=no ${ADMIN}@$host_name uptime

	echo -e "\nChecking ECM version on CoreVM:"
	sshpass -p $PASS ssh -oStrictHostKeyChecking=no ${ADMIN}@$host_name ecmversion | grep ecm-gui | awk '{print $2}' | cut -c1-11

	sshpass -p $PASS ssh ${ADMIN}@$host_name sudo /app/ecm/appserver/jboss-eap-6.4/bin/add-user.sh -u 'admin' -p 'Admin!23' 

	echo -e "\nDone for "$host_name
done
