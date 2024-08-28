#!/bin/sh
#source /app/jenkins_scripts/prep/coreVMs.performance

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

USER="enterprisedb"
PASS="3n7erpr|seD&"

system=$1
backup_id=$2

nodes=$(get_DbmVMs $system)
master=$(echo $nodes | awk 'NR==1{print $1;exit}')
standby1=$(echo $nodes | awk 'NR==1{print $2;exit}')
standby2=$(echo $nodes | awk 'NR==1{print $3;exit}')
echo "master node: $master"
echo "standby1 node: $standby1"
echo "standby2 node: $standby2"

coreNodes=$(get_CoreVMs $system)
#$nsoNodes=$(get_NsoVMs $system)
#cwfNodes=$(get_EcmVMs $system)

# Stop ECM on Core nodes
for coreVm in $coreNodes
do
    stopEcm_cmd="sshpass -p ecm123 ssh -t root@$coreVm /root/ecm_shutdown.sh"
    echo "Running: $stopEcm_cmd"
    eval $stopEcm_cmd
done
	
# Stop efm cluster 
cmd="sshpass -p ecm123 ssh -t root@$master \"efm stop-cluster efm\""
echo "running: $cmd"
eval $cmd


# Perform restore
echo "Starting restore on node $dbnode ..."
cmd="sshpass -p \"$PASS\" ssh -t $USER@$master \"/usr/edb/bart2.0/bin/bart RESTORE -s edb -i $backup_id -p /var/lib/ppas/9.5/data \""
echo "running: $cmd"
eval $cmd

if [ $? -eq 0 ]; then
    echo "Restore is completed"
else
    echo "Restore failed"
fi

# Start efm cluster
cmd="sshpass -p ecm123 ssh -t root@$master \"systemctl start ppas-9.5\""
echo "running: $cmd"
eval $cmd

cmd="sshpass -p ecm123 ssh -t root@$standby1 \"/usr/efm-2.1/bin/rdb_functions reinit_as_active_standby\""
echo "running: $cmd"
eval $cmd

cmd="sshpass -p ecm123 ssh -t root@$standby2 \"/usr/efm-2.1/bin/rdb_functions reinit_as_active_standby\""
echo "running: $cmd"
eval $cmd

cmd="sshpass -p ecm123 ssh -t root@$master \"efm cluster-status efm\""
echo "running: $cmd"
eval $cmd

# Start ECM on core nodes
for coreVm in $coreNodes
do
    startEcm_cmd="sshpass -p ecm123 ssh -t root@$coreVm /root/ecm_startup.sh"
    echo "Running: $startEcm_cmd"
    eval $startEcm_cmd
done


