#!/bin/sh

PASS="ecm123"

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1
nodes=$(get_System_PerfNodes $system)
echo -e "\nEnv all Nodes: "$nodes

for host_name in $nodes
do
	echo -e "\nPreparing host, getting uptime from "$host_name
	sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$host_name uptime
	echo -e "\nsshpass error code: "$?

	echo -e "\nDisabling legal message on login in Puppet template file (may need some seconds to be effective after configured):"
	sshpass -p $PASS ssh  -oConnectTimeout=2 root@$host_name "cat /dev/null > /etc/puppet/modules/security/files/issue.net"
        echo -e "\nsshpass error code: "$?


        echo -e "\nCopying files to "$host_name
	sshpass -p $PASS scp  -oConnectTimeout=2 -r /app/jenkins_scripts/prep/Perf root@$host_name:/root
        echo -e "\nsshpass error code: "$?

	#sshpass -p $PASS ssh  -oConnectTimeout=2 root@$host_name /root/Perf/firewall.sh
        echo -e "\nConfigure firewall..."
	sshpass -p $PASS ssh  -oConnectTimeout=2 root@$host_name /root/Perf/firewall_port.sh
        echo -e "\nsshpass error code: "$?

        echo -e "\nConfigure perf agent..."
	sshpass -p $PASS ssh  -oConnectTimeout=2 root@$host_name /root/Perf/install.sh
        echo -e "\nsshpass error code: "$?

	echo -e "\nDone 1/3 for $host_name\n"
done


system=$1
nodes_1=$(get_CoreVMs $system)
echo -e "\nCore Nodes: "$nodes_1

for host_name in $nodes_1
do
       echo -e "\nOpening firewall for port 12500 on, getting uptime from "$host_name
       sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$host_name uptime
       echo -e "\nsshpass error code: "$?

       echo -e "\nConfigure firewall port..."
       sshpass -p $PASS ssh  -oConnectTimeout=2 root@$host_name /root/Perf/firewall_port_core.sh
       echo -e "\nsshpass error code: "$?

       echo -e "\nDone 2/3 for Core node $host_name\n"
done


system=$1
nodes=$(get_ActVMs $system)
echo -e "\nACT Nodes: "$nodes

for host_name in $nodes
do
       echo -e "\nBring firewall down for host  "$host_name
       sshpass -p $PASS ssh  -oConnectTimeout=2 root@$host_name service iptables stop
       echo -e "\nsshpass error code: "$?

       echo -e "\nDone 3/3 for ACT node $host_name\n"
done
