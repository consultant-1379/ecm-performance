#!/bin/sh

echo " script to clean-up headless GUI setup on Jmeter host  "
date

echo " Verify Firefox version is Mozilla Firefox 45.0, NOT 54.0 or higher "
firefox --version

echo "cleaning up pending firefox sessions on ecm154x208.ete.ka.sw.ericsson.se"

ps -efa | grep firefox | grep -v grep | awk '{print $2}' | wc
killall firefox
#kill -9 $(ps -efa | grep firefox | grep -v grep | awk '{print $2}')
sleep 5
ps -efa | grep firefox | grep -v grep | awk '{print $2}' | wc

# create function: deletevirtualX
deletevirtualX()
{
        date
        echo " script to clean-up headless window on Jmeter host  "
        echo " kill any existent Xvfb process "
#kill -9 $(ps -efa | grep Xvfb | grep 1920x1080x24 | grep -v grep | awk '{print $2}')
killall Xvfb
sleep 2
echo "  verify no Xvfb process exists  "
ps -efa | grep Xvfb | grep 1920x1080x24| grep -v grep | wc

        echo " remove any /tmp/.Xi-lock file , with i from 1 to 98"
        for i in {1.98}; do rm -f /tmp/.X$i*-lock; done
        return 0
}

echo " call deletevirtualX function "
deletevirtualX
sleep 2
echo $DISPLAY
date
echo " Done. "
