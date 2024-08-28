#!/bin/sh
source /app/jenkins_scripts/prep/nodes.performance
PASS="ecm123"

nodes=$1
eval nodes=\$$nodes
echo "Nodes: "$nodes
for host_name in $nodes
do
        echo "Copying files to automate VMs deployment on ABCD host"
        sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
        sshpass -p $PASS scp -r /app/jenkins_scripts/prep/Installation root@$host_name:/ecm-umi/install/kvm/
        echo "Done."
done
