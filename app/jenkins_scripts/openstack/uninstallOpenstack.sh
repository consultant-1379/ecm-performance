#!/bin/sh

host_name=$1
PASS=$2

echo "Copying uninstall script to "$host_name" and pass "$PASS
sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime
sshpass -p $PASS scp -o StrictHostKeyChecking=no -r /app/jenkins_scripts/openstack/remote/uninstallOS.sh  root@$host_name:/tmp/
sshpass -p $PASS ssh root@$host_name sh /tmp/uninstallOS.sh
echo "Done."
