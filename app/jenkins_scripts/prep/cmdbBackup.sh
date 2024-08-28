#!/bin/sh
#source /app/jenkins_scripts/prep/coreVMs.performance

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

USER="enterprisedb"
PASS="3n7erpr|seD&"

system=$1
nodes=$(get_DbmVMs $system)
dbnode=$(echo $nodes | awk 'NR==1{print $1;exit}')
echo "DB node: "$dbnode

echo "Starting backup on node $dbnode ..."
cmd="sshpass -p \"$PASS\" ssh -t $USER@$dbnode \"/usr/edb/bart2.0/bin/bart BACKUP -s edb -z\""
echo "running: $cmd"

eval $cmd

if [ $? -eq 0 ]; then
    echo "Backup is completed"
else
    echo "Backup failed"
fi
