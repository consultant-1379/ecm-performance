#!/bin/sh
. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1

jnks_host=$(get_JnksHost $system)

echo ""
echo "system is: " $system
echo ""
echo "Jenkins host is: " $jnks_host
echo " "

PASS="ecm123"

host_name=$jnks_host

	echo "Preparing host "$host_name
	sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
	sshpass -p $PASS scp -r /app/jenkins_scripts/prep/Perf/headless.sh root@$host_name:/root/Perf
	sshpass -p $PASS ssh root@$host_name /root/Perf/headless.sh
	echo "Done."
