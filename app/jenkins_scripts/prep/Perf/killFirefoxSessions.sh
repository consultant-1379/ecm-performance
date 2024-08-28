#!/bin/sh

echo "cleaning up pending Firefox sessions on ecm154x208.ete.ka.sw.ericsson.se"

ps -efa | grep firefox | grep -v grep | awk '{print $2}' | wc

kill -9 $(ps -efa | grep firefox | grep -v grep | awk '{print $2}')
