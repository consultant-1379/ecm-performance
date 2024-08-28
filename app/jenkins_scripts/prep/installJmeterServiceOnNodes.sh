#!/bin/sh

#set -x
set -e 

ADMIN="osadm"
PASS="vFd0_hMpbm34"

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1
nodes=$(get_System_PerfNodes $system)

echo -e "\nEnv all Nodes: "$nodes

for host_name in $nodes
do
	echo -e "\nPreparing host, checking uptime "$host_name
	sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 ${ADMIN}@$host_name sudo uptime

        echo -e "\nCopying files to "$host_name
	sshpass -p $PASS scp  -oConnectTimeout=2 -r /app/jenkins_scripts/prep/Perf ${ADMIN}@$host_name:~

	#sshpass -p $PASS ssh  -oConnectTimeout=2 root@$host_name /root/Perf/firewall.sh
	sshpass -p $PASS ssh  -oConnectTimeout=2 ${ADMIN}@$host_name "sudo ~/Perf/firewall_port.sh"  ||  { echo -e "Opening firewall on ${host_name} failed.";exit -1; }
	sshpass -p $PASS ssh  -oConnectTimeout=2 ${ADMIN}@$host_name "sudo ~/Perf/installPerfmonService.sh"  || {  echo -e "Installing perfmon service on ${host_name} failed.";  exit -1; }

	echo -e "\nCompleted step 1/3 for $host_name\n"
done

core_nodes=$(get_CoreVMs $system)

echo -e "\nCore Nodes: "#$core_nodes

for host_name in ${core_nodes}
do
       echo -e "\nOpening firewall for port 12500 on "$host_name
#       sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$host_name uptime
       sshpass -p $PASS ssh  -oConnectTimeout=2 ${ADMIN}@$host_name "sudo ~/Perf/firewall_port_core.sh"

       echo -e "\nDone with step 2/3 for Core node $host_name\n"
done

act_nodes=$(get_ActVMs $system)

echo -e "\nACT Nodes: "$act_nodes

for host_name in $act_nodes
do
       echo -e "\nBring firewall down for host  "$host_name
       sshpass -p $PASS ssh  -oConnectTimeout=2 ${ADMIN}@$host_name "sudo service iptables stop"

       echo -e "\nDone with step 3/3 for ACT node $host_name\n"
done
