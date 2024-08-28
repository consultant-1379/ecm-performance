#!/usr/bin/bash

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

date

# make a copy of new release/drop baseenv.nonHA file

cp -p /ecm-umi/install/kvm/baseenv.nonHA /ecm-umi/install/kvm/baseenv.nonHA.ORG

# This script will verify that the latest release/drop baseenv.nonHA is compliant with KNOW_FIELDS below and ,if yes, will generate the new perf-env baseenv.nonHA file


usage () {
echo "  USAGE:"
echo "     $program -nodes_yaml <nodes> -config_file <config file> -release <ecm release> -drop <drop> -system <system name> -stage_dir <stage folder> -stage_blade <stage blade>"
echo "     e.g: ./replace_baseenv.nonHA.sh -nodes_yaml perf_nodes.yml -config_file /ecm-umi/install/kvm/baseenv.nonHA -release 18 -drop 1 -system PerfNonHA1 -stage_dir /app/stage/ECM171D6 -stage_blade sl210tx3298 "
echo
echo -e "\tPARAMETERS :"
echo -e "\t\t-nodes : perf_nodes.yml file."
echo -e "\t\t-config file : baseenv.nonHA config file."
echo -e "\t\t-ecm release : ECM Release, the results will be stored based on the value."
echo -e "\t\t-drop : the drop# of the Release."
echo -e "\t\t-system : Valid values: according to perf_nodes.yml file, could be PerfNonHA1,PerfNonHA2,etc."
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
# This script will only work if the fields in the baseenv.nonHa file that is updated match the fields listed in variable KNOWN_FIELDS.
# The list provided in variable KNOWN_FIELDS is obtained using following shell command:
#        echo $(echo $(grep -o "^[^#][^#]*" file_name |grep -o "\w*=" | sed 's/=//g' | sort))
#        where file_name is base.env file
# example: export KNOWN_FIELDS=$(echo $(grep -o "^[^#][^#]*" baseenv.nonHA |grep -o "\w*=" | sed 's/=//g' | sort))


# Get configuration type
conf_type=$(get_ConfigurationType ${system})
echo " conf_type= "
echo $conf_type


case $conf_type in
              17)
KNOWN_FIELDS="ACT_DOMAIN_name ACT_HOST_name ACT_LICENSE_endpoints ACT_OM_IP_addr ACT_QCOW2_name BLADE1 BLADE_PACKAGE ECM_DB_HOST ECM_DOMAIN_name ECM_HOST_name ECM_IMAGE_STAGE ECM_LICENSE_Host ECM_OM_IP_addr ECM_PACKAGE_FOLDER ECM_QCOW2_name HOST_domain INSTALL_ACT INSTALL_ECM OM_gateway OM_netmask primaryDNS primaryNTP PUBBR secondaryDNS secondaryNTP timeZone"
                ;;
              18)
KNOWN_FIELDS="ACT_DOMAIN_name ACT_HOST_name ACT_LICENSE_endpoints ACT_OM_IP_addr ACT_QCOW2_name BLADE1 BLADE_PACKAGE custwf_camunda_admin_password custwf_camunda_schema_password custwf_db_admin_password CUSTWF_DOMAIN_name CUSTWF_HOST_name CUSTWF_OM_IP_addr CUSTWF_QCOW2_name custwf_schema_password db_enterprisedb_password ECM_DOMAIN_name ECM_HOST_name ECM_IMAGE_STAGE ECM_LICENSE_Host ECM_OM_IP_addr ECM_PACKAGE_FOLDER ECM_QCOW2_name HOST_domain INSTALL_ACT INSTALL_CUSTWF INSTALL_ECM INSTALL_NSO INSTALL_RDB nso_activation_user_password nso_broker_user_password nso_camunda_admin_password nso_cloudmgr_user_password nso_db_admin_password NSO_DOMAIN_name NSO_HOST_name NSO_OM_IP_addr NSO_QCOW2_name nso_schema_password OM_gateway OM_netmask primaryDNS primaryNTP PUBBR RDB_DOMAIN_name RDB_HOST_name RDB_OM_IP_addr RDB_QCOW2_name secondaryDNS secondaryNTP timeZone"
                ;;
              *)
                echo "Unsupported configuration type \"$conf_type\" and the KNOWN_FIELDS cannot be determined. Aborting."
                exit
                ;;
            esac
# Rel 18.1 version Drop828
#KNOWN_FIELDS="ACT_DOMAIN_name ACT_HOST_name ACT_LICENSE_endpoints ACT_OM_IP_addr ACT_QCOW2_name BLADE1 BLADE_PACKAGE custwf_camunda_admin_password custwf_camunda_schema_password custwf_db_admin_password CUSTWF_DOMAIN_name CUSTWF_HOST_name CUSTWF_OM_IP_addr CUSTWF_QCOW2_name custwf_schema_password db_enterprisedb_password ECM_DOMAIN_name ECM_HOST_name ECM_IMAGE_STAGE ECM_LICENSE_Host ECM_OM_IP_addr ECM_PACKAGE_FOLDER ECM_QCOW2_name HOST_domain INSTALL_ACT INSTALL_CUSTWF INSTALL_ECM INSTALL_NSO INSTALL_RDB nso_activation_user_password nso_broker_user_password nso_camunda_admin_password nso_cloudmgr_user_password nso_db_admin_password NSO_DOMAIN_name NSO_HOST_name NSO_OM_IP_addr NSO_QCOW2_name nso_schema_password OM_gateway OM_netmask primaryDNS primaryNTP PUBBR RDB_DOMAIN_name RDB_HOST_name RDB_OM_IP_addr RDB_QCOW2_name secondaryDNS secondaryNTP timeZone"

# Rel 18.0 version Drop11:
#KNOWN_FIELDS="ACT_DOMAIN_name ACT_HOST_name ACT_LICENSE_endpoints ACT_OM_IP_addr ACT_QCOW2_name BLADE1 BLADE_PACKAGE CUSTWF_DOMAIN_name CUSTWF_HOST_name CUSTWF_OM_IP_addr CUSTWF_QCOW2_name ECM_DOMAIN_name ECM_HOST_name ECM_IMAGE_STAGE ECM_LICENSE_Host ECM_OM_IP_addr ECM_PACKAGE_FOLDER ECM_QCOW2_name HOST_domain INSTALL_ACT INSTALL_CUSTWF INSTALL_ECM INSTALL_NSO INSTALL_RDB NSO_DOMAIN_name NSO_HOST_name NSO_OM_IP_addr NSO_QCOW2_name OM_gateway OM_netmask primaryDNS primaryNTP PUBBR RDB_DOMAIN_name RDB_HOST_name RDB_OM_IP_addr RDB_QCOW2_name secondaryDNS secondaryNTP timeZone"

# Rel 18.0 version Drop 2:
#KNOWN_FIELDS="ACT_DOMAIN_name ACT_HOST_name ACT_LICENSE_endpoints ACT_OM_IP_addr ACT_QCOW2_name BLADE1 BLADE2 BLADE_PACKAGE DBM_DOMAIN_name DBM_HOST_name DBM_OM_IP_addr DBM_QCOW2_name ECM_DOMAIN_name ECM_HOST_name ECM_IMAGE_STAGE ECM_LICENSE_Host ECM_OM_IP_addr ECM_PACKAGE_FOLDER ECM_QCOW2_name HOST_domain INSTALL_ACT INSTALL_DBM INSTALL_ECM INSTALL_NSO INSTALL_SC NSO_DOMAIN_name NSO_HOST_name NSO_OM_IP_addr NSO_QCOW2_name OM_gateway OM_netmask primaryDNS primaryNTP PUBBR SC_DOMAIN_name SC_HOST_name SC_OM_IP_addr SC_QCOW2_name secondaryDNS secondaryNTP timeZone"

# Rel 18.0 Drop 6 version:
#KNOWN_FIELDS="ACT_DOMAIN_name ACT_HOST_name ACT_LICENSE_endpoints ACT_OM_IP_addr ACT_QCOW2_name BLADE1 BLADE2 BLADE_PACKAGE ECM_DOMAIN_name ECM_HOST_name ECM_IMAGE_STAGE ECM_LICENSE_Host ECM_OM_IP_addr ECM_PACKAGE_FOLDER ECM_QCOW2_name HOST_domain INSTALL_ACT INSTALL_ECM INSTALL_NSO INSTALL_RDB NSO_DOMAIN_name NSO_HOST_name NSO_OM_IP_addr NSO_QCOW2_name OM_gateway OM_netmask primaryDNS primaryNTP PUBBR RDB_DOMAIN_name RDB_HOST_name RDB_OM_IP_addr RDB_QCOW2_name secondaryDNS secondaryNTP timeZone"

# Rel 17.1 version:
#KNOWN_FIELDS="ACT_DOMAIN_name ACT_HOST_name ACT_LICENSE_endpoints ACT_OM_IP_addr ACT_QCOW2_name BLADE1 BLADE_PACKAGE ECM_DB_HOST ECM_DOMAIN_name ECM_HOST_name ECM_IMAGE_STAGE ECM_LICENSE_Host ECM_OM_IP_addr ECM_PACKAGE_FOLDER ECM_QCOW2_name HOST_domain INSTALL_ACT INSTALL_ECM OM_gateway OM_netmask primaryDNS primaryNTP PUBBR secondaryDNS secondaryNTP timeZone"

echo -e "The script ONLY supports baseenv.nonHA files with following fields:\n${KNOWN_FIELDS}"


## In order to ensure that the target baseenv.nonHA file is compatible with the one the script is design for, we are comparing the fields in target baseenv.nonHA file with KNOWN_FIELD variable

echo " this is the config file to get updated"
echo $config_file

export TARGET_FILE_FIELDS=$(echo $(grep -o "^[^#][^#]*" $config_file |grep -o "\w*=" | sed 's/=//g' | sort))
if [ "$KNOWN_FIELDS" = "$TARGET_FILE_FIELDS" ]

then
  echo " "
  echo " KNOWN_FIELDS variable matches TARGET_FILE_FIELDS variable "
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
 echo " Stop further processing on baseenv.nonHA .....exiting "
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
#		arg3: Config file name (baseenv.nonHA)


function update_subst_config_value() {
	eval SUBST_VALUE=\$$2
	#echo "sub=${SUBST_VALUE}"
        #eval SUBST_VALUE=${SUBST_VALUE}
        #echo "update_subst_config_value():  \$1=$1 \$2=$2 \$3=$3"
	update_config_value $1 ${SUBST_VALUE} $3
}


function update_config_value() {
        # echo "Got: $1 $2 $3"
	# Regular expression:
	# search for arg1 plus any non white space character
	# replace with arg1=arg2 expression
        # ! is used instead of / as sed delimiter
        # echo "update_config_value():  \$1=$1 \$2=$2 \$3=$3"
        sed -i -e 's!'$1'=[^[:space:]]*!'$1'='$2'!g' $3 
        #echo cmd=$cmd
	#eval $cmd
}

function empty_config_value(){
        sed -i -e 's!'$1'=[^[:space:]]*!'$1'=!g' $2
}

eval update_config_value ECM_PACKAGE_FOLDER $stage_dir $config_file
eval update_config_value BLADE_PACKAGE $stage_blade $config_file
eval update_subst_config_value BLADE1 config_${system}_subsystems_nonHA_blade_host $config_file
eval update_subst_config_value BLADE2 config_${system}_subsystems_nonHA_blade_host $config_file

#eval update_config_value PUBBR bigipoambr $config_file

eval update_subst_config_value ECM_DOMAIN_name config_${system}_subsystems_nonHA_blade_vms_core_deploy_domain $config_file
eval update_subst_config_value ECM_QCOW2_name config_${system}_subsystems_nonHA_blade_vms_core_deploy_qcow2 $config_file
eval update_subst_config_value ECM_HOST_name config_${system}_subsystems_nonHA_blade_vms_core_host $config_file
eval update_subst_config_value ECM_OM_IP_addr config_${system}_subsystems_nonHA_blade_vms_core_omip $config_file

eval update_subst_config_value ACT_DOMAIN_name config_${system}_subsystems_nonHA_blade_vms_act_deploy_domain $config_file
eval update_subst_config_value ACT_QCOW2_name config_${system}_subsystems_nonHA_blade_vms_act_deploy_qcow2 $config_file
eval update_subst_config_value ACT_HOST_name config_${system}_subsystems_nonHA_blade_vms_act_host $config_file
eval update_subst_config_value ACT_OM_IP_addr config_${system}_subsystems_nonHA_blade_vms_act_omip $config_file

eval update_subst_config_value OM_GATEWAY config_${system}_subsystems_nonHA_omgw_ip $config_file
eval update_subst_config_value PUBBR config_${system}_subsystems_nonHA_bridge_name $config_file

# add this below for Release 18.x
#eval update_subst_config_value RDB_DOMAIN_name config_${system}_subsystems_nonHA_blade_vms_dbm_deploy_domain $config_file
#eval update_subst_config_value RDB_QCOW2_name config_${system}_subsystems_nonHA_blade_vms_dbm_deploy_qcow2 $config_file
#eval update_subst_config_value RDB_HOST_name config_${system}_subsystems_nonHA_blade_vms_dbm_host $config_file
#eval update_subst_config_value RDB_OM_IP_addr config_${system}_subsystems_nonHA_blade_vms_dbm_omip $config_file

#eval update_subst_config_value NSO_DOMAIN_name config_${system}_subsystems_nonHA_blade_vms_nso_deploy_domain $config_file
#eval update_subst_config_value NSO_QCOW2_name config_${system}_subsystems_nonHA_blade_vms_nso_deploy_qcow2 $config_file
#eval update_subst_config_value NSO_HOST_name config_${system}_subsystems_nonHA_blade_vms_nso_host $config_file
#eval update_subst_config_value NSO_OM_IP_addr config_${system}_subsystems_nonHA_blade_vms_nso_omip $config_file
#eval update_subst_config_value INSTALL_NSO config_${system}_subsystems_nonHA_blade_vms_nso_instflag $config_file


case $conf_type in
              17)
                echo " Rel 17.1 version selected "
		echo " Skip the additional 18.x configuration in baseenv file"
		echo " verify date of latest generated baseenv.nonHA "
		ls -rlt /ecm-umi/install/kvm/baseenv.nonHA
                exit
                ;;
              18)
                echo " Rel 18.0 version selected "
		echo " Add additional 18.x configuration in baseenv.nonHA file"
		eval update_subst_config_value RDB_DOMAIN_name config_${system}_subsystems_nonHA_blade_vms_dbm_deploy_domain $config_file
		eval update_subst_config_value RDB_QCOW2_name config_${system}_subsystems_nonHA_blade_vms_dbm_deploy_qcow2 $config_file
		eval update_subst_config_value RDB_HOST_name config_${system}_subsystems_nonHA_blade_vms_dbm_host $config_file
		eval update_subst_config_value RDB_OM_IP_addr config_${system}_subsystems_nonHA_blade_vms_dbm_omip $config_file
		eval update_subst_config_value NSO_DOMAIN_name config_${system}_subsystems_nonHA_blade_vms_nso_deploy_domain $config_file
		eval update_subst_config_value NSO_QCOW2_name config_${system}_subsystems_nonHA_blade_vms_nso_deploy_qcow2 $config_file
		eval update_subst_config_value NSO_HOST_name config_${system}_subsystems_nonHA_blade_vms_nso_host $config_file
		eval update_subst_config_value NSO_OM_IP_addr config_${system}_subsystems_nonHA_blade_vms_nso_omip $config_file
		eval update_subst_config_value INSTALL_NSO config_${system}_subsystems_nonHA_blade_vms_nso_instflag $config_file
		eval update_subst_config_value CUSTWF_DOMAIN_name config_${system}_subsystems_nonHA_blade_vms_cwf_deploy_domain $config_file
		eval update_subst_config_value CUSTWF_QCOW2_name config_${system}_subsystems_nonHA_blade_vms_cwf_deploy_qcow2 $config_file
		eval update_subst_config_value CUSTWF_HOST_name config_${system}_subsystems_nonHA_blade_vms_cwf_host $config_file
		eval update_subst_config_value CUSTWF_OM_IP_addr config_${system}_subsystems_nonHA_blade_vms_cwf_omip $config_file
		eval update_subst_config_value INSTALL_CUSTWF config_${system}_subsystems_nonHA_blade_vms_cwf_instflag $config_file
		echo " verify date of latest generated baseenv.nonHA "
		ls -rlt /ecm-umi/install/kvm/baseenv.nonHA
                exit
                ;;
              *)
                echo "Unsupported configuration type \"$conf_type\" and the additional 18.x configuration cannot be determined. Aborting."
                exit
                ;;
            esac

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


# verify date of latest generated baseenv.nonHA
#echo " verify date of latest generated baseenv.nonHA "
#ls -rlt /ecm-umi/install/kvm/baseenv.nonHA
