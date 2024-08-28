#!/bin/sh

# exit on error
set -e

# debug
#set -x

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

ADMIN="osadm"
PASS="vFd0_hMpbm34"

# Get system
system=$1
nodes=$(get_CoreVMs $system)
echo -e "\nnodes:\n"$nodes

node1=$(echo $nodes | awk 'NR==1{print $1; exit}')
echo -e "\nNode1: "$node1

# Get url for selected system
url=$(get_PerfURL $system)

# Get configuration type  for selected system
conf_type=$(get_ConfigurationType $system)

# Get jdbc host string for selected system
jdbc_host=$(get_JdbcHost $system)

echo -e "\njdbc_host is: " $jdbc_host
echo -e "\nCore host is: " $node1
echo -e "\nURL string is: " $url
echo -e "\nConf_Type is: " $conf_type

gui_user=$2
gui_pswd=$3

echo -e "\ngui_user: "$gui_user
echo -e "gui_pswd: "$gui_pswd

        echo -e "\nCopying performance_site.yml and create_performance_site.sh files to "$node1

#        sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$node1 uptime
        sshpass -p $PASS scp -oStrictHostKeyChecking=no -r /app/jenkins_scripts/prep/Perf/performance_site.yml ${ADMIN}@$node1:~/performance_site.yaml
	echo -e "\nsshpass error code: "$?

	sshpass -p $PASS scp -oStrictHostKeyChecking=no -r /app/jenkins_scripts/prep/Perf/create_performance_site.sh ${ADMIN}@$node1:~/create_performance_site.sh
        echo -e "\nsshpass error code: "$?

        echo -e "\nRunnning script create_performance_site.sh remotely on Core host:"$node1
	sshpass -p $PASS ssh ${ADMIN}@$node1 "~/create_performance_site.sh" $jdbc_host $url $conf_type $gui_user $gui_pswd 
        echo -e "\nsshpass error code: "$?

echo "Done."
