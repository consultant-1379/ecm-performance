#!/bin/sh
#source /app/jenkins_scripts/prep/coreVMs.performance
ADMIN="osadm"
PASS="vFd0_hMpbm34"

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1
nodes=$(get_CoreVMs $system)
echo -e "\nNodes: "$nodes

function run0() {
  cmdline=$1
  echo "$cmdline"
  eval $cmdline
}

for host_name in $nodes
do
        #echo "Setting log level to ERROR for host  "$host_name
        #sshpass -p $PASS ssh -oStrictHostKeyChecking=no root@$host_name uptime

	echo -e "\nhandling main logback.xml:"

        run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo grep \"DEBUG\" /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/configuration/main/logback.xml >/tmp/${host_name}_debug_out"
	run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo grep \"TRACE\" /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/configuration/main/logback.xml >/tmp/${host_name}_trace_out"

	echo -e "\ncheck logback.xml for DEBUG and TRACE level settings before sed:"
	
	echo -e "\nDEBUGs:"
        if [[ -s /tmp/${host_name}_debug_out ]]; then cat /tmp/${host_name}_debug_out; else echo "no DEBUG string found"; fi

	echo -e "\nTRACEs:"
        if [[ -s /tmp/${host_name}_trace_out ]]; then cat /tmp/${host_name}_trace_out; else echo "no TRACE string found"; fi        

	echo -e "\nhandling cmdb logback.xml:"

	run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo grep \"DEBUG\" /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/cmdb/configuration/main/logback.xml >/tmp/${host_name}_cmdbdebug_out"
	run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo grep \"TRACE\" /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/cmdb/configuration/main/logback.xml >/tmp/${host_name}_cmdbtrace_out"

	echo -e "\ncheck logback.xml for DEBUG and TRACE level settings logback.xml before sed:"

        echo -e "\nDEBUGs:"
	if [[ -s /tmp/${host_name}_cmdbdebug_out ]]; then cat /tmp/${host_name}_cmdbdebug_out; else echo "no CMDB DEBUG string found"; fi

        echo -e "\nTRACEs:"
	if [[ -s /tmp/${host_name}_cmdbtrace_out ]]; then cat /tmp/${host_name}_cmdbtrace_out; else echo "no CMDB TRACE string found"; fi

	echo -e "\nSetting log level to ERROR for Core VMs"
	run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo sed -i.bak 's%"DEBUG"%"ERROR"%g' /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/configuration/main/logback.xml"
        run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo sed -i.bak 's%"TRACE"%"ERROR"%g' /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/configuration/main/logback.xml"
        run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo sed -i.bak 's%"DEBUG"%"ERROR"%g' /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/cmdb/configuration/main/logback.xml"
        run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo sed -i.bak 's%"TRACE"%"ERROR"%g' /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/cmdb/configuration/main/logback.xml"

	echo -e "\nVerify DEBUG and TRACE removed from logback.xml"

        echo -e "\ncheck DEBUG on Core:"
        run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo grep \"DEBUG\" /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/configuration/main/logback.xml >/tmp/${host_name}_debug_out"
        if [[ -s /tmp/${host_name}_debug_out ]]; then cat /tmp/${host_name}_debug_out; else echo "no DEBUG string found"; fi

        echo -e "\ncheck TRACE on Core:"
	run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo grep \"TRACE\" /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/configuration/main/logback.xml >/tmp/${host_name}_trace_out"
        if [[ -s /tmp/${host_name}_trace_out ]]; then cat /tmp/${host_name}_trace_out; else echo "no TRACE string found"; fi        

	echo -e "\ncheck CMDB DEBUG on Core:"
        run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo grep \"DEBUG\" /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/cmdb/configuration/main/logback.xml >/tmp/${host_name}_cmdbdebug_out"
        if [[ -s /tmp/${host_name}_cmdbdebug_out ]]; then cat /tmp/${host_name}_cmdbdebug_out; else echo "no CMDB DEBUG string found"; fi
										
	echo -e "\ncheck CMDB TRACE on Core:"
	run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo grep \"TRACE\" /app/ecm/appserver/jboss-eap-6.4/modules/com/ericsson/cmdb/configuration/main/logback.xml >/tmp/${host_name}_cmdbtrace_out"
        if [[ -s /tmp/${host_name}_cmdbtrace_out ]]; then cat /tmp/${host_name}_cmdbtrace_out; else echo "no CMDB TRACE string found"; fi  

	echo -e "\nRestarting service jboss-eap for log level change to take effect:"
	run0 "sshpass -p $PASS ssh ${ADMIN}@$host_name sudo service jboss-eap restart"

        echo -e "\nDone with node $host_name."
done
#echo ""
#echo " Restart ECM on Cores: ecm_shutdown.sh  ecm_startup.sh "
