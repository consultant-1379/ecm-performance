#!/usr/bin/bash

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

date

# make a copy of new release/drop baseenv.HA file

cp -p /ecm-umi/install/kvm/baseenv.HA /ecm-umi/install/kvm/baseenv.HA.ORG

# This script will verify that the latest release/drop baseenv.HA is compliant with KNOW_FIELDS below and ,if yes, will generate the new perf-env baseenv.HA file


usage () {
echo "  USAGE:"
echo "     $program -nodes_yaml <nodes> -config_file <config file> -release <ecm release> -drop <drop> -system <system name> -stage_dir <stage folder> -stage_blade <stage blade>"
echo "     e.g: ./replace_baseenv.HA.sh -nodes_yaml perf_nodes.yml -config_file /ecm-umi/install/kvm/baseenv.HA -release 17 -drop 1 -system PerfHA1 -stage_dir /app/stage/ECM171D6 -stage_blade dl360x4547 "
echo
echo -e "\tPARAMETERS :"
echo -e "\t\t-nodes : perf_nodes.yml file."
echo -e "\t\t-config file : baseenv.HA config file."
echo -e "\t\t-ecm release : ECM Release, the results will be stored based on the value."
echo -e "\t\t-drop : the drop# of the Release."
echo -e "\t\t-system : Valid values: according to perf_nodes.yml file, could be PerfHA1,PerfHA2,etc."
echo -e "\t\t-stage dir : stage folder."
echo -e "\t\t-stage blade : blade where stage folder is located."
exit 2
}

while [ ! -z "$1" ]
do
      XCASE=$( echo "$1" |  tr "a-z" "A-Z" )
        case $XCASE in
            -NODES_YAML)
                shift
                export NODES_YAML="$1"
                ;;
            -CONFIG_FILE)
                shift
                export config_file="$1"
                ;;
            -RELEASE)
                shift
                export release="$1"
                ;;
            -DROP)
                shift
                export drop="$1"
                ;;
            -SYSTEM)
                shift
                export system="$1"
                ;;
            -STAGE_DIR)
                shift
                export stage_dir="$1"
                ;;
            -STAGE_BLADE)
                shift
                export stage_blade="$1"
                ;;
                   *)
                usage
                 ;;
        esac
        shift
done

###. ./parse_yaml.sh

##. /ecm-umi/install/kvm/Installation17/parse_yaml.sh
## . /app/jenkins_scripts/prep/Installation/parse_yaml.sh


###### IMPORTANT !!!! ########
#
# This script will only work if the fields in the baseenv.Ha file that is updated match the fields listed in variable KNOWN_FIELDS.
# The list provided in variable KNOWN_FIELDS is obtained using following shell command:
#        echo $(echo $(grep -o "^[^#][^#]*" file_name |grep -o "\w*=" | sed 's/=//g' | sort))
#        where file_name is base.env file
# example: export KNOWN_FIELDS=$(echo $(grep -o "^[^#][^#]*" baseenv.HA |grep -o "\w*=" | sed 's/=//g' | sort))

# Get configuration type
conf_type=$(get_ConfigurationType ${system})
echo " conf_type= "
echo $conf_type

# 18.0 version 
#KNOWN_FIELDS="ACCESS_BRIDGE ACCESS_BRIDGE_VLAN ACT_EXTERNAL_VIP ACT_INTERNAL_VIP ACT_KEEPALIVED_VRID ACT_N1_DOMAIN_NAME ACT_N1_FE_IP_ADDR ACT_N1_HOST_NAME ACT_N1_LICENSE_ENDPOINTS ACT_N1_OM_IP_ADDR ACT_N1_QCOW2_NAME ACT_N2_DOMAIN_NAME ACT_N2_FE_IP_ADDR ACT_N2_HOST_NAME ACT_N2_LICENSE_ENDPOINTS ACT_N2_OM_IP_ADDR ACT_N2_QCOW2_NAME ACT_N3_DOMAIN_NAME ACT_N3_FE_IP_ADDR ACT_N3_HOST_NAME ACT_N3_LICENSE_ENDPOINTS ACT_N3_OM_IP_ADDR ACT_N3_QCOW2_NAME APPLICATION_DOMAIN BLADE1 BLADE2 BLADE3 BLADE_ACT_N1 BLADE_ACT_N2 BLADE_ACT_N3 BLADE_ECM_N1 BLADE_ECM_N2 BLADE_ESA_N1 BLADE_ESA_N2 BLADE_F5_N1 BLADE_F5_N2 BLADE_NSO_N1 BLADE_NSO_N2 BLADE_PACKAGE BLADE_RDB_N1 BLADE_RDB_N2 BLADE_RDB_N3 BRIDGE_ETH DNS_NAMESERVERS DNS_SEARCH ECM_FRBR ECM_IMAGE_STAGE ECM_N1_DOMAIN_NAME ECM_N1_FE_IP_ADDR ECM_N1_HOST_NAME ECM_N1_LICENSE_HOST ECM_N1_OM_IP_ADDR ECM_N1_QCOW2_NAME ECM_N2_DOMAIN_NAME ECM_N2_FE_IP_ADDR ECM_N2_HOST_NAME ECM_N2_LICENSE_HOST ECM_N2_OM_IP_ADDR ECM_N2_QCOW2_NAME ECM_PACKAGE_FOLDER ESA_CLUSTER_NAME ESA_N1_DOMAIN_NAME ESA_N1_FE_IP_ADDR ESA_N1_HOST_NAME ESA_N1_OM_IP_ADDR ESA_N1_QCOW2_NAME ESA_N2_DOMAIN_NAME ESA_N2_FE_IP_ADDR ESA_N2_HOST_NAME ESA_N2_OM_IP_ADDR ESA_N2_QCOW2_NAME F5_N1_DOMAIN_NAME F5_N1_FE_IP_ADDR F5_N1_HOST_NAME F5_N1_OM_IP_ADDR F5_N1_QCOW2_NAME F5_N2_DOMAIN_NAME F5_N2_FE_IP_ADDR F5_N2_HOST_NAME F5_N2_OM_IP_ADDR F5_N2_QCOW2_NAME FE_BRIDGE FE_BRIDGE_VLAN FE_NETMASK FO_BRIDGE FO_BRIDGE_VLAN HOST_DOMAIN INFRA_BRIDGE INFRA_BRIDGE_VLAN INSTALL_ACT_N1 INSTALL_ACT_N2 INSTALL_ACT_N3 INSTALL_ECM_N1 INSTALL_ECM_N2 INSTALL_ESA_N1 INSTALL_ESA_N2 INSTALL_F5_N1 INSTALL_F5_N2 INSTALL_NSO_N1 INSTALL_NSO_N2 INSTALL_RDB_N1 INSTALL_RDB_N2 INSTALL_RDB_N3 LOAD_EXTERNAL LOAD_FLOAT_DMZ LOAD_FLOAT_ECMFE LOAD_GATEWAY LOAD_INSTANCES1_DMZ LOAD_INSTANCES1_ECMFE LOAD_INSTANCES1_FAILOVER LOAD_INSTANCES1_MANAGEMENT LOAD_INSTANCES1_NAME LOAD_INSTANCES2_DMZ LOAD_INSTANCES2_ECMFE LOAD_INSTANCES2_FAILOVER LOAD_INSTANCES2_MANAGEMENT LOAD_INSTANCES2_NAME LOAD_INTERNAL LOAD_NAMESERVERS LOAD_SEARCH LOAD_SERVICES_NAS_IP LOAD_SERVICES_RDB1 LOAD_SERVICES_RDB2 LOAD_SERVICES_RDB3 LOAD_TRAP_DESTINATION_NODE1 LOAD_TRAP_DESTINATION_NODE2 NSO_INTERNAL_VIP NSO_N1_DOMAIN_NAME NSO_N1_FE_IP_ADDR NSO_N1_HOST_NAME NSO_N1_OM_IP_ADDR NSO_N1_QCOW2_NAME NSO_N2_DOMAIN_NAME NSO_N2_FE_IP_ADDR NSO_N2_HOST_NAME NSO_N2_OM_IP_ADDR NSO_N2_QCOW2_NAME NTP_SERVERS NTP_TIMEZONE OAM_BRIDGE OAM_BRIDGE_VLAN OAM_PUBBR OM_GATEWAY OM_NETMASK PRIMARYDNS PRIMARYNTP RDB_DOMAIN RDB_N1_DOMAIN_NAME RDB_N1_FE_IP_ADDR RDB_N1_HOST_NAME RDB_N1_OM_IP_ADDR RDB_N1_QCOW2_NAME RDB_N1_ROLE RDB_N2_DOMAIN_NAME RDB_N2_FE_IP_ADDR RDB_N2_HOST_NAME RDB_N2_OM_IP_ADDR RDB_N2_QCOW2_NAME RDB_N2_ROLE RDB_N3_DOMAIN_NAME RDB_N3_FE_IP_ADDR RDB_N3_HOST_NAME RDB_N3_OM_IP_ADDR RDB_N3_QCOW2_NAME RDB_N3_ROLE RDB_NFS_FOLDER RDB_NFS_SERVER_IP RDB_NODE1 RDB_NODE2 RDB_NODE3 RDB_VIP RDB_VIP_NETWORK RESET_F5 SECONDARYDNS SECONDARYNTP SYSTEMS_ACTIVEMQ_FILE_SYSTEM SYSTEMS_ECM1_FQDN SYSTEMS_ECM1_PSEUDOINTERFACES SYSTEMS_ECM2_FQDN SYSTEMS_ECM2_PSEUDOINTERFACES SYSTEMS_GATEWAY SYSTEMS_IMAGES_FILE_SYSTEM SYSTEMS_NFS SYSTEMS_NFS_DOMAIN SYSTEMS_NSO1_FQDN SYSTEMS_NSO2_FQDN TIMEZONE"


case $conf_type in
              17)
KNOWN_FIELDS="ACCESS_BRIDGE ACCESS_BRIDGE_VLAN ACT_N1_DOMAIN_NAME ACT_N1_FE_IP_ADDR ACT_N1_HOST_NAME ACT_N1_LICENSE_ENDPOINTS ACT_N1_OM_IP_ADDR ACT_N1_QCOW2_NAME ACT_N2_DOMAIN_NAME ACT_N2_FE_IP_ADDR ACT_N2_HOST_NAME ACT_N2_LICENSE_ENDPOINTS ACT_N2_OM_IP_ADDR ACT_N2_QCOW2_NAME APPLICATION_DOMAIN BLADE1 BLADE2 BLADE3 BLADE_ACT_N1 BLADE_ACT_N2 BLADE_ECM_N1 BLADE_ECM_N2 BLADE_ESA_N1 BLADE_ESA_N2 BLADE_F5_N1 BLADE_F5_N2 BLADE_PACKAGE BRIDGE_ETH DNS_NAMESERVERS DNS_SEARCH ECM_FRBR ECM_IMAGE_STAGE ECM_N1_DOMAIN_NAME ECM_N1_FE_IP_ADDR ECM_N1_HOST_NAME ECM_N1_LICENSE_HOST ECM_N1_OM_IP_ADDR ECM_N1_QCOW2_NAME ECM_N2_DOMAIN_NAME ECM_N2_FE_IP_ADDR ECM_N2_HOST_NAME ECM_N2_LICENSE_HOST ECM_N2_OM_IP_ADDR ECM_N2_QCOW2_NAME ECM_PACKAGE_FOLDER ESA_N1_DOMAIN_NAME ESA_N1_FE_IP_ADDR ESA_N1_HOST_NAME ESA_N1_OM_IP_ADDR ESA_N1_QCOW2_NAME ESA_N2_DOMAIN_NAME ESA_N2_FE_IP_ADDR ESA_N2_HOST_NAME ESA_N2_OM_IP_ADDR ESA_N2_QCOW2_NAME F5_N1_DOMAIN_NAME F5_N1_FE_IP_ADDR F5_N1_HOST_NAME F5_N1_OM_IP_ADDR F5_N1_QCOW2_NAME F5_N2_DOMAIN_NAME F5_N2_FE_IP_ADDR F5_N2_HOST_NAME F5_N2_OM_IP_ADDR F5_N2_QCOW2_NAME FE_BRIDGE FE_BRIDGE_VLAN FE_NETMASK FO_BRIDGE FO_BRIDGE_VLAN HOST_DOMAIN INFRA_BRIDGE INFRA_BRIDGE_VLAN INITIAL_IMPORT INSTALL_ACT_N1 INSTALL_ACT_N2 INSTALL_ECM_N1 INSTALL_ECM_N2 INSTALL_ESA_N1 INSTALL_ESA_N2 INSTALL_F5_N1 INSTALL_F5_N2 LOAD_EXTERNAL LOAD_FLOAT_DMZ LOAD_FLOAT_ECMFE LOAD_GATEWAY LOAD_INSTANCES1_DMZ LOAD_INSTANCES1_ECMFE LOAD_INSTANCES1_FAILOVER LOAD_INSTANCES1_MANAGEMENT LOAD_INSTANCES1_NAME LOAD_INSTANCES2_DMZ LOAD_INSTANCES2_ECMFE LOAD_INSTANCES2_FAILOVER LOAD_INSTANCES2_MANAGEMENT LOAD_INSTANCES2_NAME LOAD_INTERNAL LOAD_NAMESERVERS LOAD_SEARCH LOAD_SERVICES_NAS_IP LOAD_SERVICES_RAC1_IP LOAD_SERVICES_RAC2_IP LOAD_TRAP_DESTINATION_NODE1 LOAD_TRAP_DESTINATION_NODE2 NTP_SERVERS NTP_TIMEZONE OAM_BRIDGE OAM_BRIDGE_VLAN OAM_PUBBR OM_GATEWAY OM_NETMASK ORACLE_RAC_DOMAIN ORACLE_RAC_NODE1 ORACLE_RAC_NODE2 ORACLE_RAC_SCAN PRIMARYDNS PRIMARYNTP SECONDARYDNS SECONDARYNTP SYSTEMS_ACTIVEMQ_FILE_SYSTEM SYSTEMS_ECM1_FQDN SYSTEMS_ECM1_PSEUDOINTERFACES SYSTEMS_ECM2_FQDN SYSTEMS_ECM2_PSEUDOINTERFACES SYSTEMS_GATEWAY SYSTEMS_IMAGES_FILE_SYSTEM SYSTEMS_NFS TAKE_EXPORT TIMEZONE"
                ;;
              18)
KNOWN_FIELDS="ACCESS_BRIDGE ACCESS_BRIDGE_VLAN ACT_EXTERNAL_VIP ACT_INTERNAL_VIP ACT_KEEPALIVED_VRID ACT_N1_DOMAIN_NAME ACT_N1_FE_IP_ADDR ACT_N1_HOST_NAME ACT_N1_INFRA_IP_ADDR ACT_N1_LICENSE_ENDPOINTS ACT_N1_OM_IP_ADDR ACT_N1_QCOW2_NAME ACT_N2_DOMAIN_NAME ACT_N2_FE_IP_ADDR ACT_N2_HOST_NAME ACT_N2_INFRA_IP_ADDR ACT_N2_LICENSE_ENDPOINTS ACT_N2_OM_IP_ADDR ACT_N2_QCOW2_NAME ACT_N3_DOMAIN_NAME ACT_N3_FE_IP_ADDR ACT_N3_HOST_NAME ACT_N3_INFRA_IP_ADDR ACT_N3_LICENSE_ENDPOINTS ACT_N3_OM_IP_ADDR ACT_N3_QCOW2_NAME APPLICATION_DOMAIN BLADE1 BLADE2 BLADE3 BLADE_ACT_N1 BLADE_ACT_N2 BLADE_ACT_N3 BLADE_CUSTWF_N1 BLADE_CUSTWF_N2 BLADE_ECM_N1 BLADE_ECM_N2 BLADE_ESA_N1 BLADE_ESA_N2 BLADE_F5_N1 BLADE_F5_N2 BLADE_NSO_N1 BLADE_NSO_N2 BLADE_PACKAGE BLADE_RDB_N1 BLADE_RDB_N2 BLADE_RDB_N3 BRIDGE_ETH custwf_camunda_admin_password custwf_camunda_schema_password custwf_db_admin_password CUSTWF_INTERNAL_VIP CUSTWF_N1_DOMAIN_NAME CUSTWF_N1_FE_IP_ADDR CUSTWF_N1_HOST_NAME CUSTWF_N1_INFRA_IP_ADDR CUSTWF_N1_OM_IP_ADDR CUSTWF_N1_QCOW2_NAME CUSTWF_N2_DOMAIN_NAME CUSTWF_N2_FE_IP_ADDR CUSTWF_N2_HOST_NAME CUSTWF_N2_INFRA_IP_ADDR CUSTWF_N2_OM_IP_ADDR CUSTWF_N2_QCOW2_NAME custwf_schema_password db_enterprisedb_password DNS_NAMESERVERS DNS_SEARCH ECM_FRBR ECM_IMAGE_STAGE ECM_N1_DOMAIN_NAME ECM_N1_FE_IP_ADDR ECM_N1_HOST_NAME ECM_N1_INFRA_IP_ADDR ECM_N1_LICENSE_HOST ECM_N1_OM_IP_ADDR ECM_N1_QCOW2_NAME ECM_N2_DOMAIN_NAME ECM_N2_FE_IP_ADDR ECM_N2_HOST_NAME ECM_N2_INFRA_IP_ADDR ECM_N2_LICENSE_HOST ECM_N2_OM_IP_ADDR ECM_N2_QCOW2_NAME ECM_PACKAGE_FOLDER ESA_CLUSTER_NAME ESA_N1_DOMAIN_NAME ESA_N1_FE_IP_ADDR ESA_N1_HOST_NAME ESA_N1_INFRA_IP_ADDR ESA_N1_OM_IP_ADDR ESA_N1_QCOW2_NAME ESA_N2_DOMAIN_NAME ESA_N2_FE_IP_ADDR ESA_N2_HOST_NAME ESA_N2_INFRA_IP_ADDR ESA_N2_OM_IP_ADDR ESA_N2_QCOW2_NAME EXT_NET_ROUTE_DESTINATION EXT_NET_ROUTE_GATEWAY F5_N1_DOMAIN_NAME F5_N1_FE_IP_ADDR F5_N1_HOST_NAME F5_N1_OM_IP_ADDR F5_N1_QCOW2_NAME F5_N2_DOMAIN_NAME F5_N2_FE_IP_ADDR F5_N2_HOST_NAME F5_N2_OM_IP_ADDR F5_N2_QCOW2_NAME FE_BRIDGE FE_BRIDGE_VLAN FE_NETMASK FO_BRIDGE FO_BRIDGE_VLAN HOST_DOMAIN INFRA_BRIDGE INFRA_BRIDGE_VLAN INFRA_NETMASK INSTALL_ACT_N1 INSTALL_ACT_N2 INSTALL_ACT_N3 INSTALL_CUSTWF_N1 INSTALL_CUSTWF_N2 INSTALL_ECM_N1 INSTALL_ECM_N2 INSTALL_ESA_N1 INSTALL_ESA_N2 INSTALL_F5_N1 INSTALL_F5_N2 INSTALL_NSO_N1 INSTALL_NSO_N2 INSTALL_RDB_N1 INSTALL_RDB_N2 INSTALL_RDB_N3 LOAD_EXTERNAL LOAD_FLOAT_DMZ LOAD_FLOAT_ECMFE LOAD_GATEWAY LOAD_INSTANCES1_DMZ LOAD_INSTANCES1_ECMFE LOAD_INSTANCES1_ECMINFRA LOAD_INSTANCES1_FAILOVER LOAD_INSTANCES1_MANAGEMENT LOAD_INSTANCES1_NAME LOAD_INSTANCES2_DMZ LOAD_INSTANCES2_ECMFE LOAD_INSTANCES2_ECMINFRA LOAD_INSTANCES2_FAILOVER LOAD_INSTANCES2_MANAGEMENT LOAD_INSTANCES2_NAME LOAD_INTERNAL LOAD_NAMESERVERS LOAD_SEARCH LOAD_SERVICES_NAS_IP LOAD_SERVICES_RDB1 LOAD_SERVICES_RDB2 LOAD_SERVICES_RDB3 LOAD_TRAP_DESTINATION_NODE1 LOAD_TRAP_DESTINATION_NODE2 nso_activation_user_password nso_broker_user_password nso_camunda_admin_password nso_cloudmgr_user_password nso_db_admin_password NSO_INTERNAL_VIP NSO_N1_DOMAIN_NAME NSO_N1_FE_IP_ADDR NSO_N1_HOST_NAME NSO_N1_INFRA_IP_ADDR NSO_N1_OM_IP_ADDR NSO_N1_QCOW2_NAME NSO_N2_DOMAIN_NAME NSO_N2_FE_IP_ADDR NSO_N2_HOST_NAME NSO_N2_INFRA_IP_ADDR NSO_N2_OM_IP_ADDR NSO_N2_QCOW2_NAME nso_schema_password NTP_SERVERS NTP_TIMEZONE OAM_BRIDGE OAM_BRIDGE_VLAN OAM_PUBBR OM_GATEWAY OM_NETMASK PRIMARYDNS PRIMARYNTP RDB_DOMAIN RDB_N1_DOMAIN_NAME RDB_N1_FE_IP_ADDR RDB_N1_HOST_NAME RDB_N1_INFRA_IP_ADDR RDB_N1_OM_IP_ADDR RDB_N1_QCOW2_NAME RDB_N1_ROLE RDB_N2_DOMAIN_NAME RDB_N2_FE_IP_ADDR RDB_N2_HOST_NAME RDB_N2_INFRA_IP_ADDR RDB_N2_OM_IP_ADDR RDB_N2_QCOW2_NAME RDB_N2_ROLE RDB_N3_DOMAIN_NAME RDB_N3_FE_IP_ADDR RDB_N3_HOST_NAME RDB_N3_INFRA_IP_ADDR RDB_N3_OM_IP_ADDR RDB_N3_QCOW2_NAME RDB_N3_ROLE RDB_NFS_FOLDER RDB_NFS_SERVER_IP RDB_NODE1 RDB_NODE2 RDB_NODE3 RDB_VIP RDB_VIP_NETWORK RESET_F5 SECONDARYDNS SECONDARYNTP STATIC_ROUTE_REMOTE_NETWORK SYSTEMS_ACTIVEMQ_FILE_SYSTEM SYSTEMS_CUSTWF1_FQDN SYSTEMS_CUSTWF2_FQDN SYSTEMS_ECM1_FQDN SYSTEMS_ECM1_PSEUDOINTERFACES SYSTEMS_ECM2_FQDN SYSTEMS_ECM2_PSEUDOINTERFACES SYSTEMS_GATEWAY SYSTEMS_IMAGES_FILE_SYSTEM SYSTEMS_NFS SYSTEMS_NFS_DOMAIN SYSTEMS_NSO1_FQDN SYSTEMS_NSO2_FQDN TIMEZONE"
                ;;
              *)
                echo "Unsupported configuration type \"$conf_type\" and the KNOWN_FIELDS cannot be determined. Aborting."
                exit
                ;;
            esac

echo -e "The script ONLY supports baseenv.HA files with following fields:\n${KNOWN_FIELDS}"


## In order to ensure that the target baseenv.HA file is compatible with the one the script is design for, we are comparing the fields in target baseenv.HA file with KNOWN_FIELD variable

export TARGET_FILE_FIELDS=$(echo $(grep -o "^[^#][^#]*" $config_file |grep -o "\w*=" | sed 's/=//g' | sort))
if [ "$KNOWN_FIELDS" = "$TARGET_FILE_FIELDS" ]

then
  echo " "
  echo " KNOWN_FIELDS variable matches TARGET_FILE_FIELDS variable "
  echo ""
else
 echo ""
 echo " Error:  TARGET_FILE_FIELDS not matching KNOWN_FIELDS "

 echo ""
 echo " trying to find the diff fields between: KNOWN_FIELDS <> TARGET_FILE_FIELDS ..."
 echo ""
 diff <(echo $KNOWN_FIELDS | sed -e 's/ /\n/g') <(echo $TARGET_FILE_FIELDS | sed -e 's/ /\n/g')
 echo ""
 echo "the complete target fields list:"
 echo $TARGET_FILE_FIELDS

 echo ""
 echo " Stop further processing on baseenv.HA .....exiting "
 exit 1
fi

# read yaml file
eval $(parse_yaml $NODES_YAML "config_")


# Function update_config_value - replaces field value in config file:
# 	The config file lines are in format:
#		 [<something>]<field_name>=<field_value> [<something>]
#
#	NOTE: It will only work if there is no white space before or after = sign !!!
#
#       Arguments: 
#		arg1: The field name (for example BLADE_PACKAGE)
#		arg2: The field value
#		arg3: Config file name (baseenv.HA)


function update_subst_config_value() {
	eval SUBST_VALUE=\$$2
	#echo "sub=${SUBST_VALUE}"
	update_config_value $1 ${SUBST_VALUE} $3
}


function update_config_value() {
        #echo "Got: $1 $2 $3"
	# Regular expression:
	# search for arg1 plus any non white space character
	# replace with arg1=arg2 expression
        # ! is used instead of / as sed delimiter
        sed -i -e 's!'$1'=[^[:space:]]*!'$1'='$2'!g' $3 
}

function empty_config_value(){
	sed -i -e 's!'$1'=[^[:space:]]*!'$1'=!g' $2
}

# Update parameters in baseenv.HA file 

eval update_config_value ECM_PACKAGE_FOLDER $stage_dir $config_file
eval update_config_value BLADE_PACKAGE $stage_blade $config_file
eval update_subst_config_value BLADE1 config_${system}_subsystems_ha1_blade_host $config_file
eval update_subst_config_value BLADE2 config_${system}_subsystems_ha2_blade_host $config_file
eval update_subst_config_value BLADE3 config_${system}_subsystems_ha3_blade_host $config_file

eval update_subst_config_value OM_GATEWAY config_${system}_subsystems_ha1_omgw_ip $config_file
#eval update_subst_config_value DNS_SEARCH config_${system}_subsystems_ha1_dnsearch $config_file
#eval update_subst_config_value APPLICATION_DOMAIN config_${system}_subsystems_ha1_appldm_url"${DNS_SEARCH}" $config_file
eval update_subst_config_value APPLICATION_DOMAIN config_${system}_subsystems_ha1_appldm_url $config_file
#eval update_config_value APPLICATION_DOMAIN "ecmha-ka26.${sub}" $config_file

eval update_subst_config_value ECM_N1_DOMAIN_NAME config_${system}_subsystems_ha1_blade_vms_core_deploy_domain $config_file
eval update_subst_config_value ECM_N1_QCOW2_NAME config_${system}_subsystems_ha1_blade_vms_core_deploy_qcow2 $config_file
eval update_subst_config_value ECM_N1_HOST_NAME config_${system}_subsystems_ha1_blade_vms_core_host $config_file
eval update_subst_config_value ECM_N1_OM_IP_ADDR config_${system}_subsystems_ha1_blade_vms_core_omip $config_file
eval update_subst_config_value ECM_N1_FE_IP_ADDR config_${system}_subsystems_ha1_blade_vms_core_feip $config_file
eval update_subst_config_value INSTALL_ECM_N1 config_${system}_subsystems_ha1_blade_vms_core_instflag $config_file

eval update_subst_config_value ECM_N2_DOMAIN_NAME config_${system}_subsystems_ha2_blade_vms_core_deploy_domain $config_file
eval update_subst_config_value ECM_N2_QCOW2_NAME config_${system}_subsystems_ha2_blade_vms_core_deploy_qcow2 $config_file
eval update_subst_config_value ECM_N2_HOST_NAME config_${system}_subsystems_ha2_blade_vms_core_host $config_file
eval update_subst_config_value ECM_N2_OM_IP_ADDR config_${system}_subsystems_ha2_blade_vms_core_omip $config_file
eval update_subst_config_value ECM_N2_FE_IP_ADDR config_${system}_subsystems_ha2_blade_vms_core_feip $config_file
eval update_subst_config_value INSTALL_ECM_N2 config_${system}_subsystems_ha2_blade_vms_core_instflag $config_file

eval update_subst_config_value ACT_N1_DOMAIN_NAME config_${system}_subsystems_ha1_blade_vms_act_deploy_domain $config_file
eval update_subst_config_value ACT_N1_QCOW2_NAME config_${system}_subsystems_ha1_blade_vms_act_deploy_qcow2 $config_file
eval update_subst_config_value ACT_N1_HOST_NAME config_${system}_subsystems_ha1_blade_vms_act_host $config_file
eval update_subst_config_value ACT_N1_OM_IP_ADDR config_${system}_subsystems_ha1_blade_vms_act_omip $config_file
eval update_subst_config_value ACT_N1_FE_IP_ADDR config_${system}_subsystems_ha1_blade_vms_act_feip $config_file
eval update_subst_config_value INSTALL_ACT_N1 config_${system}_subsystems_ha1_blade_vms_act_instflag $config_file

eval update_subst_config_value ACT_N2_DOMAIN_NAME config_${system}_subsystems_ha2_blade_vms_act_deploy_domain $config_file
eval update_subst_config_value ACT_N2_QCOW2_NAME config_${system}_subsystems_ha2_blade_vms_act_deploy_qcow2 $config_file
eval update_subst_config_value ACT_N2_HOST_NAME config_${system}_subsystems_ha2_blade_vms_act_host $config_file
eval update_subst_config_value ACT_N2_OM_IP_ADDR config_${system}_subsystems_ha2_blade_vms_act_omip $config_file
eval update_subst_config_value ACT_N2_FE_IP_ADDR config_${system}_subsystems_ha2_blade_vms_act_feip $config_file
eval update_subst_config_value INSTALL_ACT_N2 config_${system}_subsystems_ha2_blade_vms_act_instflag $config_file

eval update_subst_config_value ACT_N3_DOMAIN_NAME config_${system}_subsystems_ha3_blade_vms_act_deploy_domain $config_file
eval update_subst_config_value ACT_N3_QCOW2_NAME config_${system}_subsystems_ha3_blade_vms_act_deploy_qcow2 $config_file
eval update_subst_config_value ACT_N3_HOST_NAME config_${system}_subsystems_ha3_blade_vms_act_host $config_file
eval update_subst_config_value ACT_N3_OM_IP_ADDR config_${system}_subsystems_ha3_blade_vms_act_omip $config_file
eval update_subst_config_value ACT_N3_FE_IP_ADDR config_${system}_subsystems_ha3_blade_vms_act_feip $config_file
eval update_subst_config_value INSTALL_ACT_N3 config_${system}_subsystems_ha3_blade_vms_act_instflag $config_file

eval update_subst_config_value ESA_N1_DOMAIN_NAME config_${system}_subsystems_ha1_blade_vms_esa_deploy_domain $config_file
eval update_subst_config_value ESA_N1_QCOW2_NAME config_${system}_subsystems_ha1_blade_vms_esa_deploy_qcow2 $config_file
eval update_subst_config_value ESA_N1_HOST_NAME config_${system}_subsystems_ha1_blade_vms_esa_host $config_file
eval update_subst_config_value ESA_N1_OM_IP_ADDR config_${system}_subsystems_ha1_blade_vms_esa_omip $config_file
eval update_subst_config_value ESA_N1_FE_IP_ADDR config_${system}_subsystems_ha1_blade_vms_esa_feip $config_file
eval update_subst_config_value INSTALL_ESA_N1 config_${system}_subsystems_ha1_blade_vms_esa_instflag $config_file

eval update_subst_config_value ESA_N2_DOMAIN_NAME config_${system}_subsystems_ha2_blade_vms_esa_deploy_domain $config_file
eval update_subst_config_value ESA_N2_QCOW2_NAME config_${system}_subsystems_ha2_blade_vms_esa_deploy_qcow2 $config_file
eval update_subst_config_value ESA_N2_HOST_NAME config_${system}_subsystems_ha2_blade_vms_esa_host $config_file
eval update_subst_config_value ESA_N2_OM_IP_ADDR config_${system}_subsystems_ha2_blade_vms_esa_omip $config_file
eval update_subst_config_value ESA_N2_FE_IP_ADDR config_${system}_subsystems_ha2_blade_vms_esa_feip $config_file
eval update_subst_config_value INSTALL_ESA_N2 config_${system}_subsystems_ha2_blade_vms_esa_instflag $config_file

eval update_subst_config_value ESA_CLUSTER_NAME config_${system}_esasystem_esaclstname $config_file

eval update_subst_config_value RDB_N1_DOMAIN_NAME config_${system}_subsystems_ha1_blade_vms_dbm_deploy_domain $config_file
eval update_subst_config_value RDB_N1_QCOW2_NAME config_${system}_subsystems_ha1_blade_vms_dbm_deploy_qcow2 $config_file
eval update_subst_config_value RDB_N1_HOST_NAME config_${system}_subsystems_ha1_blade_vms_dbm_host $config_file
eval update_subst_config_value RDB_N1_OM_IP_ADDR config_${system}_subsystems_ha1_blade_vms_dbm_omip $config_file
eval update_subst_config_value RDB_N1_FE_IP_ADDR config_${system}_subsystems_ha1_blade_vms_dbm_feip $config_file
eval update_subst_config_value RDB_N1_ROLE config_${system}_subsystems_ha1_blade_vms_dbm_role $config_file
eval update_subst_config_value INSTALL_RDB_N1 config_${system}_subsystems_ha1_blade_vms_dbm_instflag $config_file

eval update_subst_config_value RDB_N2_DOMAIN_NAME config_${system}_subsystems_ha2_blade_vms_dbm_deploy_domain $config_file
eval update_subst_config_value RDB_N2_QCOW2_NAME config_${system}_subsystems_ha2_blade_vms_dbm_deploy_qcow2 $config_file
eval update_subst_config_value RDB_N2_HOST_NAME config_${system}_subsystems_ha2_blade_vms_dbm_host $config_file
eval update_subst_config_value RDB_N2_OM_IP_ADDR config_${system}_subsystems_ha2_blade_vms_dbm_omip $config_file
eval update_subst_config_value RDB_N2_FE_IP_ADDR config_${system}_subsystems_ha2_blade_vms_dbm_feip $config_file
eval update_subst_config_value RDB_N2_ROLE config_${system}_subsystems_ha2_blade_vms_dbm_role $config_file
eval update_subst_config_value INSTALL_RDB_N2 config_${system}_subsystems_ha2_blade_vms_dbm_instflag $config_file

eval update_subst_config_value RDB_N3_DOMAIN_NAME config_${system}_subsystems_ha3_blade_vms_dbm_deploy_domain $config_file
eval update_subst_config_value RDB_N3_QCOW2_NAME config_${system}_subsystems_ha3_blade_vms_dbm_deploy_qcow2 $config_file
eval update_subst_config_value RDB_N3_HOST_NAME config_${system}_subsystems_ha3_blade_vms_dbm_host $config_file
eval update_subst_config_value RDB_N3_OM_IP_ADDR config_${system}_subsystems_ha3_blade_vms_dbm_omip $config_file
eval update_subst_config_value RDB_N3_FE_IP_ADDR config_${system}_subsystems_ha3_blade_vms_dbm_feip $config_file
eval update_subst_config_value RDB_N3_ROLE config_${system}_subsystems_ha3_blade_vms_dbm_role $config_file
eval update_subst_config_value INSTALL_RDB_N3 config_${system}_subsystems_ha3_blade_vms_dbm_instflag $config_file

eval update_subst_config_value NSO_N1_DOMAIN_NAME config_${system}_subsystems_ha1_blade_vms_nso_deploy_domain $config_file
eval update_subst_config_value NSO_N1_QCOW2_NAME config_${system}_subsystems_ha1_blade_vms_nso_deploy_qcow2 $config_file
eval update_subst_config_value NSO_N1_HOST_NAME config_${system}_subsystems_ha1_blade_vms_nso_host $config_file
eval update_subst_config_value NSO_N1_OM_IP_ADDR config_${system}_subsystems_ha1_blade_vms_nso_omip $config_file
eval update_subst_config_value NSO_N1_FE_IP_ADDR config_${system}_subsystems_ha1_blade_vms_nso_feip $config_file
eval update_subst_config_value SYSTEMS_NSO1_FQDN config_${system}_subsystems_ha1_blade_vms_nso_fqdn $config_file
eval update_subst_config_value INSTALL_NSO_N1 config_${system}_subsystems_ha1_blade_vms_nso_instflag $config_file

eval update_subst_config_value NSO_N2_DOMAIN_NAME config_${system}_subsystems_ha2_blade_vms_nso_deploy_domain $config_file
eval update_subst_config_value NSO_N2_QCOW2_NAME config_${system}_subsystems_ha2_blade_vms_nso_deploy_qcow2 $config_file
eval update_subst_config_value NSO_N2_HOST_NAME config_${system}_subsystems_ha2_blade_vms_nso_host $config_file
eval update_subst_config_value NSO_N2_OM_IP_ADDR config_${system}_subsystems_ha2_blade_vms_nso_omip $config_file
eval update_subst_config_value NSO_N2_FE_IP_ADDR config_${system}_subsystems_ha2_blade_vms_nso_feip $config_file
eval update_subst_config_value SYSTEMS_NSO2_FQDN config_${system}_subsystems_ha2_blade_vms_nso_fqdn $config_file
eval update_subst_config_value INSTALL_NSO_N2 config_${system}_subsystems_ha2_blade_vms_nso_instflag $config_file

eval update_subst_config_value NSO_INTERNAL_VIP config_${system}_nsosystem_nsointvip $config_file

eval update_subst_config_value CUSTWF_N1_DOMAIN_NAME config_${system}_subsystems_ha1_blade_vms_cwf_deploy_domain $config_file
eval update_subst_config_value CUSTWF_N1_QCOW2_NAME config_${system}_subsystems_ha1_blade_vms_cwf_deploy_qcow2 $config_file
eval update_subst_config_value CUSTWF_N1_HOST_NAME config_${system}_subsystems_ha1_blade_vms_cwf_host $config_file
eval update_subst_config_value CUSTWF_N1_OM_IP_ADDR config_${system}_subsystems_ha1_blade_vms_cwf_omip $config_file
eval update_subst_config_value CUSTWF_N1_FE_IP_ADDR config_${system}_subsystems_ha1_blade_vms_cwf_feip $config_file
eval update_subst_config_value SYSTEMS_CUSTWF1_FQDN config_${system}_subsystems_ha1_blade_vms_cwf_fqdn $config_file
eval update_subst_config_value INSTALL_CUSTWF_N1 config_${system}_subsystems_ha1_blade_vms_cwf_instflag $config_file

eval update_subst_config_value CUSTWF_N2_DOMAIN_NAME config_${system}_subsystems_ha2_blade_vms_cwf_deploy_domain $config_file
eval update_subst_config_value CUSTWF_N2_QCOW2_NAME config_${system}_subsystems_ha2_blade_vms_cwf_deploy_qcow2 $config_file
eval update_subst_config_value CUSTWF_N2_HOST_NAME config_${system}_subsystems_ha2_blade_vms_cwf_host $config_file
eval update_subst_config_value CUSTWF_N2_OM_IP_ADDR config_${system}_subsystems_ha2_blade_vms_cwf_omip $config_file
eval update_subst_config_value CUSTWF_N2_FE_IP_ADDR config_${system}_subsystems_ha2_blade_vms_cwf_feip $config_file
eval update_subst_config_value SYSTEMS_CUSTWF2_FQDN config_${system}_subsystems_ha2_blade_vms_cwf_fqdn $config_file
eval update_subst_config_value INSTALL_CUSTWF_N2 config_${system}_subsystems_ha2_blade_vms_cwf_instflag $config_file

eval update_subst_config_value CUSTWF_INTERNAL_VIP config_${system}_cwfsystem_cwfintvip $config_file

##eval update_config_value F5_N1_DOMAIN_NAME "F5"$release"N1" $config_file
##eval update_config_value F5_N1_QCOW2_NAME "F5"$release"_N1.qcow2" $config_file
##eval update_subst_config_value F5_N1_DOMAIN_NAME config_${system}_subsystems_ha1_blade_vms_f5_deploy_domain $config_file
##eval update_subst_config_value F5_N1_QCOW2_NAME config_${system}_subsystems_ha1_blade_vms_f5_deploy_qcow2 $config_file
eval update_subst_config_value F5_N1_DOMAIN_NAME config_${system}_subsystems_ha1_blade_vms_f5_deploy_domain $config_file
eval update_subst_config_value F5_N1_QCOW2_NAME config_${system}_subsystems_ha1_blade_vms_f5_deploy_qcow2 $config_file
eval update_subst_config_value F5_N1_HOST_NAME config_${system}_subsystems_ha1_blade_vms_f5_host $config_file
eval update_subst_config_value F5_N1_OM_IP_ADDR config_${system}_subsystems_ha1_blade_vms_f5_omip $config_file
eval update_subst_config_value F5_N1_FE_IP_ADDR config_${system}_subsystems_ha1_blade_vms_f5_feip $config_file
eval update_subst_config_value INSTALL_F5_N1 config_${system}_subsystems_ha1_blade_vms_f5_instflag $config_file

##eval update_config_value F5_N2_DOMAIN_NAME "F5"$release"N2" $config_file
##eval update_config_value F5_N2_QCOW2_NAME "F5"$release"_N2.qcow2" $config_file
##eval update_subst_config_value F5_N2_DOMAIN_NAME config_${system}_subsystems_ha2_blade_vms_f5_deploy_domain $config_file
##eval update_subst_config_value F5_N2_QCOW2_NAME config_${system}_subsystems_ha2_blade_vms_f5_deploy_qcow2 $config_file
eval update_subst_config_value F5_N2_DOMAIN_NAME config_${system}_subsystems_ha2_blade_vms_f5_deploy_domain $config_file
eval update_subst_config_value F5_N2_QCOW2_NAME config_${system}_subsystems_ha2_blade_vms_f5_deploy_qcow2 $config_file
eval update_subst_config_value F5_N2_HOST_NAME config_${system}_subsystems_ha2_blade_vms_f5_host $config_file
eval update_subst_config_value F5_N2_OM_IP_ADDR config_${system}_subsystems_ha2_blade_vms_f5_omip $config_file
eval update_subst_config_value F5_N2_FE_IP_ADDR config_${system}_subsystems_ha2_blade_vms_f5_feip $config_file
eval update_subst_config_value INSTALL_F5_N2 config_${system}_subsystems_ha2_blade_vms_f5_instflag $config_file

eval update_subst_config_value RDB_VIP config_${system}_dbmsystem_dbmvip $config_file
eval update_subst_config_value RDB_NFS_SERVER_IP config_${system}_dbmsystem_dbmnfs $config_file
eval update_subst_config_value RDB_NFS_FOLDER config_${system}_dbmsystem_dbmnfsfld $config_file
eval update_subst_config_value RDB_VIP_NETWORK config_${system}_dbmsystem_dbmntwif $config_file

eval update_subst_config_value SYSTEMS_ACTIVEMQ_FILE_SYSTEM config_${system}_filesystem_mq $config_file
eval update_subst_config_value SYSTEMS_IMAGES_FILE_SYSTEM config_${system}_filesystem_im $config_file

eval update_subst_config_value SYSTEMS_NFS config_${system}_systems_nfs $config_file
eval update_subst_config_value FE_NETMASK config_${system}_systems_fenetmask $config_file
eval update_subst_config_value SYSTEMS_ECM1_FQDN config_${system}_systems_1fqdn $config_file
eval update_subst_config_value SYSTEMS_ECM2_FQDN config_${system}_systems_2fqdn $config_file

eval update_subst_config_value SYSTEMS_ECM1_PSEUDOINTERFACES config_${system}_systems_1psd $config_file
eval update_subst_config_value SYSTEMS_ECM2_PSEUDOINTERFACES config_${system}_systems_2psd $config_file
eval update_subst_config_value SYSTEMS_GATEWAY config_${system}_systems_gtwy $config_file

eval update_subst_config_value ACT_KEEPALIVED_VRID config_${system}_actsystem_actkpalvid $config_file
eval update_subst_config_value ACT_INTERNAL_VIP config_${system}_actsystem_actintvip $config_file
eval update_subst_config_value ACT_EXTERNAL_VIP config_${system}_actsystem_actextvip $config_file

eval update_subst_config_value LOAD_EXTERNAL config_${system}_load_external $config_file
eval update_subst_config_value LOAD_INTERNAL config_${system}_load_internal $config_file
eval update_subst_config_value LOAD_GATEWAY config_${system}_subsystems_ha1_omgw_ip $config_file

eval update_subst_config_value LOAD_FLOAT_DMZ config_${system}_load_dmz $config_file
eval update_subst_config_value LOAD_FLOAT_ECMFE config_${system}_load_ecmfe $config_file
eval update_subst_config_value LOAD_TRAP_DESTINATION_NODE1 config_${system}_load_trpn1 $config_file
eval update_subst_config_value LOAD_TRAP_DESTINATION_NODE2 config_${system}_load_trpn2 $config_file

eval update_subst_config_value LOAD_INSTANCES1_NAME config_${system}_instances_inst1_name $config_file
eval update_subst_config_value LOAD_INSTANCES1_FAILOVER config_${system}_instances_inst1_flvr $config_file
eval update_subst_config_value LOAD_INSTANCES1_MANAGEMENT config_${system}_instances_inst1_mgt $config_file
eval update_subst_config_value LOAD_INSTANCES1_ECMFE config_${system}_instances_inst1_ecmfe $config_file
eval update_subst_config_value LOAD_INSTANCES1_DMZ config_${system}_instances_inst1_dmz $config_file

eval update_subst_config_value LOAD_INSTANCES2_NAME config_${system}_instances_inst2_name $config_file
eval update_subst_config_value LOAD_INSTANCES2_FAILOVER config_${system}_instances_inst2_flvr $config_file
eval update_subst_config_value LOAD_INSTANCES2_MANAGEMENT config_${system}_instances_inst2_mgt $config_file
eval update_subst_config_value LOAD_INSTANCES2_ECMFE config_${system}_instances_inst2_ecmfe $config_file
eval update_subst_config_value LOAD_INSTANCES2_DMZ config_${system}_instances_inst2_dmz $config_file

eval update_subst_config_value LOAD_SERVICES_NAS_IP config_${system}_services_nasip $config_file

# For F5 VM deployments only: need to provide following values in baseenv.HA config file
eval update_config_value OAM_BRIDGE_VLAN "1779" $config_file
eval update_config_value ACCESS_BRIDGE_VLAN "1777" $config_file
eval update_config_value FE_BRIDGE_VLAN "1778" $config_file
eval update_config_value FO_BRIDGE_VLAN "1745" $config_file
eval update_config_value INFRA_BRIDGE_VLAN "1746" $config_file

# For F5 new configuration to be pushed successfully: it needs default configuration loaded first
eval update_config_value RESET_F5 "true" $config_file

#INFRA variables are not used in performance test system, so they will be emptied, according to the CPI
eval empty_config_value ACT_N1_INFRA_IP_ADDR $config_file
eval empty_config_value ACT_N2_INFRA_IP_ADDR $config_file
eval empty_config_value ACT_N3_INFRA_IP_ADDR $config_file
eval empty_config_value CUSTWF_N1_INFRA_IP_ADDR $config_file
eval empty_config_value CUSTWF_N2_INFRA_IP_ADDR $config_file
eval empty_config_value ECM_N1_INFRA_IP_ADDR $config_file
eval empty_config_value ECM_N2_INFRA_IP_ADDR $config_file
eval empty_config_value ESA_N1_INFRA_IP_ADDR $config_file
eval empty_config_value ESA_N2_INFRA_IP_ADDR $config_file
eval empty_config_value EXT_NET_ROUTE_DESTINATION $config_file
eval empty_config_value EXT_NET_ROUTE_GATEWAY $config_file
eval empty_config_value LOAD_INSTANCES1_ECMINFRA $config_file
eval empty_config_value LOAD_INSTANCES2_ECMINFRA $config_file
eval empty_config_value INFRA_NETMASK $config_file
eval empty_config_value NSO_N1_INFRA_IP_ADDR $config_file
eval empty_config_value NSO_N2_INFRA_IP_ADDR $config_file
eval empty_config_value RDB_N1_INFRA_IP_ADDR $config_file
eval empty_config_value RDB_N2_INFRA_IP_ADDR $config_file
eval empty_config_value RDB_N3_INFRA_IP_ADDR $config_file

eval empty_config_value custwf_camunda_admin_password $config_file
eval empty_config_value custwf_camunda_schema_password $config_file
eval empty_config_value custwf_db_admin_password $config_file
eval empty_config_value custwf_schema_password $config_file
eval empty_config_value db_enterprisedb_password $config_file
eval empty_config_value nso_activation_user_password $config_file
eval empty_config_value nso_broker_user_password $config_file
eval empty_config_value nso_camunda_admin_password $config_file
eval empty_config_value nso_cloudmgr_user_password $config_file
eval empty_config_value nso_db_admin_password $config_file
eval empty_config_value nso_schema_password $config_file


# verify date of latest generated baseenv.Ha
echo " verify date of latest generated baseenv.HA "
ls -rlt /ecm-umi/install/kvm/baseenv.HA
##ls -rlt /app/jenkins_scripts/prep/Installation/baseenv.HA
