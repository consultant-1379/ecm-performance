#!/bin/sh
#Test: Random Read - 4 minutes run with numjobs=8, 10 secs run with numjobs=1
# input parameter: fio config file  /root/FIO/fio_input/random_read_1.cfg
date
rm -f /root/FIO/fio_testcases/randomread.*
#fio --name=randread --ioengine=libaio --iodepth=16 --rw=randread --bs=4k --direct=0 --size=512M --numjobs=1 --runtime=240 --output=../fio_logs/randomreadTEST512MB.log
#echo "this is $1"
#echo $1
echo " .... executing FIO test case    "
cd /root/FIO/fio_testcases
fio $1 > /root/FIO/fio_logs/randomreadTEST1GB.log
sleep 10
echo " ...... done     "
echo " ..... printing iops stats      "
grep iops /root/FIO/fio_logs/randomreadTEST1GB.log
date
