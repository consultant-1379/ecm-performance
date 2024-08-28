#!/bin/sh

# for debug use set -x
#set -x
set -e

PARENT_DIR=${0%/*}
SCRIPTS_DIR=${PARENT_DIR}/scripts
CRONTAB="/var/spool/cron/root"

echo -e "\nStarting `basename $0` as: `whoami`\n"

echo -e "\nChecking crontab content:\n"

set +e
grep "* sh $SCRIPTS_DIR/perf_sampler.sh" $CRONTAB
CRON=$?
set -e

if [ $CRON -ne 0 ]
then
     echo -e "#Performance: Collect socket and thread statistics" >> $CRONTAB
     echo -e "0-59/10 * * * * sh $SCRIPTS_DIR/perf_sampler.sh > /dev/null 2>&1" >> $CRONTAB
fi

echo -e "\nStopping perfmon service if it is already running...\n"
set +e
systemctl stop perfmon
set -e

echo -e "\nInstalling perfmon service...\n"

SERVICEFILE="/usr/lib/systemd/system/perfmon.service"

echo -e "[Unit]\nDescription=PerfMon Jmeter Agent\nAfter=network.target\n" > $SERVICEFILE
echo -e "[Service]\nType=simple\nExecStart=/usr/bin/java -jar ${PARENT_DIR}/jmeter/CMDRunner.jar --tool PerfMonAgent\n" >> $SERVICEFILE
echo -e "[Install]\nWantedBy=multi-user.target" >> $SERVICEFILE

ls -l $SERVICEFILE

echo -e "\nReloading services...\n"
systemctl daemon-reload

echo -e "\nEnabling service to start at boot...\n"
systemctl enable perfmon

echo -e "\nStarting perfmon service...\n"
systemctl start perfmon
systemctl status perfmon

echo -e "\nperfmon service install finished\n"

