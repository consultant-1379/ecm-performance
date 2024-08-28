#!/bin/sh

echo "cleaning up pending Chrome sessions on ecm154x208.ete.ka.sw.ericsson.se"

ps -efa | grep chrome | grep -v grep | awk '{print $2}' | wc

kill -9 $(ps -efa | grep chrome | grep -v grep | awk '{print $2}')
