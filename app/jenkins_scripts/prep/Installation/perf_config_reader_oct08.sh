#!/bin/bash

NODES_YAML=/app/jenkins_scripts/prep/Installation/perf_nodes.yml
# read yaml file
. /app/jenkins_scripts/prep/Installation/parse_yaml.sh
eval $(parse_yaml $NODES_YAML "config_")


# List elements names
function getListElementsNames() {
#   arg1 - list path (variable name) in yaml file
    list_name=$1
    echo $list_name
    for list_element in $(compgen -v |grep $1 | sed "s/${list_name}_//g" | awk -F_ '{print $1}'|sort|uniq)
    do
      echo ${list_name}_${list_element}
    done
}

# Value in the list element
function getListElementsValue() {
#   arg1 - list path (variable name) in yaml file  
#   arg2 - value name 
    list_name=$1
    value_name=$2
    echo $list_name 
    echo $value_name
    for list_element in $(getListElementsNames $list_name)
    do 
      eval echo \$${list_element}_${value_name}
   done
}

function get_System() {
   system_name=$1
   echo config_${system_name}
}

function get_SystemType() {
   system_name=$1
   eval echo \$$(get_System ${system_name})_type
}

function get_Platform() {
   system_name=$1
   eval echo \$$(get_System ${system_name})_platform
}

function get_ConfigurationType() {
   system_name=$1
   eval echo \$$(get_System ${system_name})_conftype
}

function get_JdbcHost() {
   system_name=$1
   eval echo \$$(get_System ${system_name})_jdbc_host
}

function get_PerfURL() {
   system_name=$1
      eval echo \$$(get_System ${system_name})_url
}

function get_ABCDHost() {
   system_name=$1
   eval echo \$$(get_System ${system_name})_abcd_host
}

function get_Subsystems() {
   system_name=$1
   for sub in $(getListElementsNames "$(get_System ${system_name})_subsystems")
   do
      echo ${sub}
   done
}

# Get 1st Core VM for HA or 

# List of O&M IPs in the subsystem
function get_Subsystem_VMs_IPs() {
#  arg1 - subsystem name
   subsystem_name=$1
   echo $subsystem_name 
   vm_list_name=${subsystem_name}_blade_vms
   for vm_ip in $(getListElementsValue $vm_list_name "omip")
   do
      echo ${vm_ip}
   done
}

# List of O&M IPs in the system
function get_System_VMs_IPs() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      get_Subsystem_VMs_IPs $subsystem	
   done
}

# List of O&M Core VM IPs in the system
function get_CoreVMs() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_vms_core_omip
   done
}

# Gets VM property value for all VMs of specified type in the system
function get_VM_Property() {
#  arg1 - system name
   system_name=$1
   vm_type=$2 # allowed: core,act,esa,dbm
   property=$3 # 
   for subsystem in $(get_Subsystems $system_name)
   do
	  
      eval echo \$${subsystem}_blade_vms_${vm_type}_${property}
   done
}

# Gets blade property
function get_Blade_Property() {
#  arg1 - system name
   system_name=$1
   property=$2
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_${property}
   done
}


# List of O&M Act VM IPs in the system
function get_ActVMs() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_vms_act_omip
   done
}

# List of O&M Act VM Host Names in the system
function get_ActVMHosts() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_vms_act_host
   done
}

# List of Core VM Host Names in the system
function get_CoreVMHosts() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_vms_core_host
   done
}

# List of O&M Esa VM IPs in the system
function get_EsaVMs() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_vms_esa_omip
   done
}

# List of O&M Esa VM Host Names in the system
function get_EsaVMHosts() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_vms_esa_host
   done
}

# List of O&M DBM VM IPs in the system
function get_DbmVMs() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_vms_dbm_omip
   done
}

# List of O&M DBM VM Host Names in the system
function get_DbmVMHosts() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_vms_dbm_host
   done
}

# List of O&M NSO VM Host Names in the system
function get_NsoVMHosts() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_vms_nso_host
   done
}

# List of O&M NSO VM IPs Names in the system
function get_NsoVMs() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
       eval echo \$${subsystem}_blade_vms_nso_omip
   done
}

# List of O&M F5 VM IPs Names in the system
function get_F5VMs() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
	eval echo \$${subsystem}_blade_vms_f5_omip
   done
}

# List of Blade IPs  in the system
function get_Blades() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_ip
   done
}

# List of Blade Host Name  in the system
function get_BladesHost() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      eval echo \$${subsystem}_blade_host
   done
}


# List of O&M IPs and Blade IPs in the system
function get_System_PerfNodes() {
#  arg1 - system name
   system_name=$1
   for subsystem in $(get_Subsystems $system_name)
   do
      echo "value is "$subsystem 
      get_Subsystem_VMs_IPs $subsystem	
      eval echo \$${subsystem}_blade_ip
   done
}

# REST/GUI access IP 
function get_System_Access_IP() {
#  arg1 - system name
   system_name=$1
   eval echo \$$(get_System $system_name)_access_ip
}

# ACT EXT VIP
function get_System_ACT_EXT_VIP() {
#  arg1 - system name
   system_name=$1
      eval echo \$$(get_System $system_name)_actsystem_actextvip
}
function get_Jenkin_VIP(){
   system_name=$1
   eval echo \$$(get_System $system_name_ip
}

