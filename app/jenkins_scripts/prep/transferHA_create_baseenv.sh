#!/bin/sh
. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

PASS="ecm123"

system=$1
nodes=$(get_ABCDHost $system)
echo "Nodes: "$nodes

function run1() {
  cmdline=$1
  echo "Copying files to automate VMs deployment on ABCD host: $cmdline"
  eval $cmdline
}


for host_name in $nodes
do

#        echo "Copying files to automate VMs deployment on ABCD host"
        sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
     run1 "sshpass -p $PASS scp -r /app/jenkins_scripts/prep/Installation root@$host_name:/ecm-umi/install/kvm/"
	echo "after the copy change local folder in perf_config_reader.sh "
        sshpass -p $PASS ssh root@$host_name  sed -i.bak '0,/app/{s/app/ecm-umi/}' /ecm-umi/install/kvm/Installation/replace_baseenv.HA.sh
	sshpass -p $PASS ssh root@$host_name  sed -i.bak 's/jenkins_scripts/install/g' /ecm-umi/install/kvm/Installation/replace_baseenv.HA.sh
	sshpass -p $PASS ssh root@$host_name  sed -i.bak 's/prep/kvm/g' /ecm-umi/install/kvm/Installation/replace_baseenv.HA.sh

	sshpass -p $PASS ssh root@$host_name  sed -i.bak 's/app/ecm-umi/g' /ecm-umi/install/kvm/Installation/perf_config_reader.sh
	sshpass -p $PASS ssh root@$host_name  sed -i.bak 's/jenkins_scripts/install/g' /ecm-umi/install/kvm/Installation/perf_config_reader.sh
	sshpass -p $PASS ssh root@$host_name  sed -i.bak 's/prep/kvm/g' /ecm-umi/install/kvm/Installation/perf_config_reader.sh

	echo " Run script replace_baseenv.HA.sh on ABCD host"
#        sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
	eval sshpass -p $PASS ssh root@$host_name /ecm-umi/install/kvm/Installation/replace_baseenv.HA.sh -nodes_yaml $2 -config_file $3 -release $4 -drop $5 -system $6 -stage_dir $7 -stage_blade $8
#	eval sshpass -p $PASS ssh root@$host_name ls -rlt /ecm-umi/install/kvm/baseenv.HA
        echo "Done."
done
