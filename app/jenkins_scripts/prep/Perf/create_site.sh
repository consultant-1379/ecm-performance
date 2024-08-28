#!/bin/sh

set -e

SCRIPTS_DIR="$(pwd)$(dirname $0 | sed 's/^.//g')/scripts"
CRONTAB="/var/spool/cron/root"

grep -q "* sh $SCRIPTS_DIR/perf_sampler.sh" $CRONTAB
if [ $? -ne 0 ]
then
     echo "#Performance: Collect socket and thread statistics" >> $CRONTAB
     echo "0-59/10 * * * * sh $SCRIPTS_DIR/perf_sampler.sh > /dev/null 2>&1" >> $CRONTAB
fi

        CMD=$(eval echo nohup java -jar $(dirname $0)/jmeter/CMDRunner.jar --tool PerfMonAgent "$@")

ps -ef |grep -v grep |grep CMDRunner.jar >> /dev/null

if [ $? -ne 0 ]
then
        CMD=$(eval echo nohup java -jar $(dirname $0)/jmeter/CMDRunner.jar --tool PerfMonAgent "$@")
        echo "Starting Perf Mon Agent ..."
	eval $CMD >>  /dev/null 2>&1 &
else 
	echo "Perf Mon Agent is running."
        exit
fi

# Verify that the agent is running
sleep 2

ps -ef |grep -v grep |grep CMDRunner.jar >> /dev/null
if [ $? -ne 0 ]
then
       echo "ERROR: Perf Mon Agent did not start." 
else
       echo "Perf Mon Agent started."
fi
