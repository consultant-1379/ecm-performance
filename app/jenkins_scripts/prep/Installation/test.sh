#!/bin/bash

. ./perf_config_reader.sh
#get_VM_Property $1 core fqdn
#get_Blade_Property $1 fqdn
#get_Subsystems $1
#get_System_VMs_IPs $1
#get_ConfigurationType $1
#get_SystemType $1
#get_JdbcHost $1
#getListElementsNames $1
#get_ABCDHost $1
#get_CoreVMHosts $1
#get_Blades $1
#get_BladesHost $1
#get_CoreFQDNs $1
#get_PerfURLs $1
#get_DbmVMHosts $1
#get_System_Access_IP $1
#get_JnksHost $1
get_PerfURL $1
get_System_Access_IP $1
get_SystemType $1
get_System_PerfNodes $1
