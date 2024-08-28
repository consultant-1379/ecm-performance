#!/bin/sh

. /app/jenkins_scripts/prep/Installation/perf_config_reader_oct08.sh 
system=$1
echo -e $system
restIP=$(get_PerfURL $system) 
nodes=$(get_System_PerfNodes $system)           
echo -e "\nnodes: "$nodes
exit
