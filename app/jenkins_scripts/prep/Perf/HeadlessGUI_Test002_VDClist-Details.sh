#!/bin/sh

echo " Verify Firefox version is Mozilla Firefox 45.0, NOT 54.0 or higher "
firefox --version

echo "cleaning up pending firefox sessions on ecm154x208.ete.ka.sw.ericsson.se"

ps -efa | grep firefox | grep -v grep | awk '{print $2}' | wc
kill -9 $(ps -efa | grep firefox | grep -v grep | awk '{print $2}')
ps -efa | grep firefox | grep -v grep | awk '{print $2}' | wc

# create functions: deletevirtualX, createvirtualX1
deletevirtualX()
{
	date
	echo " script to clean-up headless window on Jmeter host  "
	echo " kill any existent Xvfb process "
	kill -9 $(ps -efa | grep Xvfb | grep 640x480x8 | grep -v grep | awk '{print $2}')
	echo "  verify no Xvfb process exists  "
	ps -efa | grep Xvfb | grep 640x480x8 | grep -v grep | wc

	echo " remove any /tmp/.Xi-lock file , with i from 1 to 98"
	for i in {1..98}; do rm -f /tmp/.X$i*-lock; done
	return 0
}
createvirtualX1()
{
	echo " script to set headless window on Jmeter host  "
	date
	echo " headless GUI: start a new Xvfb process in background "
	Xvfb :2 -ac -screen 0 640x480x8 &
	sleep 2
	echo " verify new Xvfb process been created "
	ps -efa | grep Xvfb | grep -v grep
	export DISPLAY=:2
	echo " verify Virtual Display is set "
	echo $DISPLAY
	echo " verify network sockets created "
	sleep 5
	netstat -an | grep X2
	date
	return 0
}
# capture current DISPLAY ID
VAR1=$DISPLAY
echo " call deletevirtualX function "
deletevirtualX
echo $DISPLAY
echo "call createvirtualX1 function "
createvirtualX1
echo $DISPLAY
echo " Start Jmeter scripts ..... "
/root/jmeter/bin/jmeter -n -t JMeterTestPlans/non-HA-GUI-Login-VDClist-Details.jmx -j JMeter_Logs/jmeter-gui-test002-1.log -l JMeter_Logs/jmeter-gui-test002-1.jtl -Jusers=1 -Jloops=1 -Jrampup=1 -Jresults=./GUITestResults
sleep 5
date
echo "call deletevirtualX function "
deletevirtualX
echo "call createvirtualX1 function "
createvirtualX1
/root/jmeter/bin/jmeter -n -t JMeterTestPlans/non-HA-GUI-Login-VDClist-Details.jmx -j JMeter_Logs/jmeter-gui-test002-5.log -l JMeter_Logs/jmeter-gui-test002-5.jtl -Jusers=5 -Jloops=3 -Jrampup=1 -Jresults=./GUITestResults
sleep 5
date
echo "call deletevirtualX function "
deletevirtualX
echo "call createvirtualX1 function "
createvirtualX1
/root/jmeter/bin/jmeter -n -t JMeterTestPlans/non-HA-GUI-Login-VDClist-Details.jmx -j JMeter_Logs/jmeter-gui-test002-15.log -l JMeter_Logs/jmeter-gui-test002-15.jtl -Jusers=15 -Jloops=3 -Jrampup=1 -Jresults=./GUITestResults
sleep 5
date
echo "call deletevirtualX function "
deletevirtualX
echo "call createvirtualX1 function "
createvirtualX1
/root/jmeter/bin/jmeter -n -t JMeterTestPlans/non-HA-GUI-Login-VDClist-Details.jmx -j JMeter_Logs/jmeter-gui-test002-35.log -l JMeter_Logs/jmeter-gui-test002-35.jtl -Jusers=35 -Jloops=3 -Jrampup=1 -Jresults=./GUITestResults
sleep 5
date
echo "call deletevirtualX function "
deletevirtualX
echo "call createvirtualX1 function "
createvirtualX1
/root/jmeter/bin/jmeter -n -t JMeterTestPlans/non-HA-GUI-Login-VDClist-Details.jmx -j JMeter_Logs/jmeter-gui-test002-50.log -l JMeter_Logs/jmeter-gui-test002-50.jtl -Jusers=50 -Jloops=3 -Jrampup=1 -Jresults=./GUITestResults
sleep 5
date
echo "call deletevirtualX function "
deletevirtualX
echo "call createvirtualX1 function "
createvirtualX1
/root/jmeter/bin/jmeter -n -t JMeterTestPlans/non-HA-GUI-Login-VDClist-Details.jmx -j JMeter_Logs/jmeter-gui-test002-75.log -l JMeter_Logs/jmeter-gui-test002-75.jtl -Jusers=75 -Jloops=3 -Jrampup=1 -Jresults=./GUITestResults
sleep 5
date
echo "call deletevirtualX function "
deletevirtualX
echo "call createvirtualX1 function "
createvirtualX1
/root/jmeter/bin/jmeter -n -t JMeterTestPlans/non-HA-GUI-Login-VDClist-Details.jmx -j JMeter_Logs/jmeter-gui-test002-100.log -l JMeter_Logs/jmeter-gui-test002-100.jtl -Jusers=100 -Jloops=3 -Jrampup=1 -Jresults=./GUITestResults
echo " End Jmeter scripts ..... "
echo " call deletevirtualX function "
deletevirtualX
# reset DISPLAY ID to initial value
export DISPLAY=$VAR1
echo $DISPLAY
echo " .... done "
date
