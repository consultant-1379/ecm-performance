#!/bin/sh
# 
# ******** ERICSSON INTERNAL ***********
# 
# Collects socket statistics on the system level and netstat stats
#
# Output: Log files in LOGDIR directory
# Author: Nando Molino 
# Date: 11/16/2017
#

LOGDIR="/var/log"
#LOGDIR="/root/Perf/scripts"
SYSNETSTATLOG="$LOGDIR/ecmperf_sys_netstat_v1.log"
SYSSOCKLOG="$LOGDIR/ecmperf_sys_sock_stat_v1.log"

if [ ! -e $SYSSOCKLOG ]
then
   echo date,time,used,tcp_inuse,tcp_orphan,tcp_tw,tcp_alloc,ss_total,ss_tcp_total,ss_kernel_total,ss_tcp_estab,ss_tcp_closed,ss_tcp_orphaned,ss_tcp_synrecv,ss_tcp_timewait,ss_tcp_ports > $SYSSOCKLOG
fi

#Get overall socket stats
echo $(date +%x),$(date +%T),$(cat /proc/net/sockstat | gawk '/sockets/ {total=$3} /TCP:/{print total"," $3 "," $5"," $7"," $9}'),$(/usr/sbin/ss -s | /bin/sed  's/[(),\/]/ /g' | /bin/gawk '/Total:/ {total=$2;ktotal=$4} /TCP:/{print total","ktotal","$2","$4","$6","$8","$10","$12","$15}') >> $SYSSOCKLOG

if [ ! -e $SYSNETSTATLOG ]
then
   touch $SYSNETSTATLOG
fi

#Get overall netstat stats
echo $(date +%x),$(date +%T) >> $SYSNETSTATLOG
#netstat -an >> $SYSNETSTATLOG
netstat -an | grep CLOSE_WAIT >> $SYSNETSTATLOG
netstat -an | grep TIME_WAIT >> $SYSNETSTATLOG
echo " " >> $SYSNETSTATLOG
