#!/bin/sh
#source /app/jenkins_scripts/prep/coreVMs.performance

PASS="ecm123"

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1
nodes=$(get_ActVMs $system)
echo -e "\nNodes: "$nodes

for host_name in $nodes
do
        echo -e "\nSetting JMX ports for host, get uptime from "$host_name
        sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
	echo -e "\nsshpass return value: "$?

	echo -e "\n Copying setJMXportsPG.sh script to remote host $host_name"
	sshpass -p $PASS scp  -oConnectTimeout=2 /app/jenkins_scripts/prep/Perf/setJMXportsPG.sh root@$host_name:/root/Perf
        echo -e "\nsshpass return value: "$?

        echo -e "\n Running setJMXportsPG.sh script on remote host $host_name"
	sshpass -p $PASS ssh  -oConnectTimeout=2 root@$host_name /root/Perf/setJMXportsPG.sh
        echo -e "\nsshpass return value: "$?

        echo -e "\nDone."
done

echo "Reboot PG VMs and then do the following steps on each PG VM: "
echo " 1. verify <netstat -an | grep 7100> and <netstat -an | grep 7101> "
echo " 2. run /root/Perf/install.sh and verify this process is there <ps -efa | grep CMDRunner.jar> "
echo " 3. bring down firewall: service iptables stop "
