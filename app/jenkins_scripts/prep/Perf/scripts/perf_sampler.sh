#!/bin/sh
# 
# ******** ERICSSON INTERNAL ***********
# 
# Collects socket statistics on the system level and socket and thread counts on JVMs
#
# Output: Log files in LOGDIR directory
# Author: George Kuzman 
# Date: 6/9/2016
#

LOGDIR="/var/log"
PROCLOG="$LOGDIR/ecmperf_proc_stat.log"
JAVAPROCLOG="$LOGDIR/ecmperf_java_procs.log"
SYSSOCKLOG="$LOGDIR/ecmperf_sys_sock_stat.log"

if [ ! -e $PROCLOG ]
then
   echo date,time,PID,sockets,threads > $PROCLOG
fi

if [ ! -e $JAVAPROCLOG ]
then
   echo date,time,PID,CMD > $JAVAPROCLOG
fi

if [ ! -e $SYSSOCKLOG ]
then
   echo date,time,used,tcp_inuse,tcp_orphan,tcp_tw,tcp_alloc,ss_total,ss_tcp_total,ss_kernel_total,ss_tcp_estab,ss_tcp_closed,ss_tcp_orphaned,ss_tcp_synrecv,ss_tcp_timewait,ss_tcp_ports > $SYSSOCKLOG
fi

#Get overall socket stats
echo $(date +%x),$(date +%T),$(cat /proc/net/sockstat | gawk '/sockets/ {total=$3} /TCP:/{print total"," $3 "," $5"," $7"," $9}'),$(/usr/bin/ss -s | /bin/sed  's/[(),\/]/ /g' | /bin/gawk '/Total:/ {total=$2;ktotal=$4} /TCP:/{print total","ktotal","$2","$4","$6","$8","$10","$12","$15}') >> $SYSSOCKLOG

# Get java PIDs and record stats
JAVAPIDS=$(ps -ef | grep '/bin/java' | grep -v 'grep' |awk '{print $2}')
for pid in $JAVAPIDS
do
    grep -q ,$pid, $JAVAPROCLOG || echo $(date +%x),$(date +%T),$pid,$(ps -q $pid -o cmd h) >> $JAVAPROCLOG
    echo $(date +%x),$(date +%T),$pid,$(ls -l /proc/$pid/fd |grep 'socket:' |wc -l),$(ls /proc/$pid/task |wc -l) 2> /dev/null >> $PROCLOG
done


