#!/bin/sh

# include parse_yaml function
. ./parse_yaml.sh

# read yaml file
eval $(parse_yaml $1 "config_")

# access yaml content
echo $config_ECM_PACKAGE_FOLDER_folder$config_ECM_PACKAGE_FOLDER_drop
echo $config_BLADE_PACKAGE_bldpkg
echo $config_BLADE1_bld1
echo $config_PUBBR_pubbr
echo $config_OM_gateway_OM_gateway
echo $config_ECM_DOMAIN_name_ecmdmn$config_ECM_DOMAIN_name_drop
echo $config_ECM_QCOW2_name_main$config_ECM_QCOW2_name_drop$config_ECM_QCOW2_name_qcow2
echo $config_ECM_HOST_name_core
echo $config_ECM_OM_IP_addr_ipaddr
echo $config_ECM_DB_HOST_dbhost
echo $config_ACT_DOMAIN_name_actdmn$config_ACT_DOMAIN_name_drop
echo $config_ACT_QCOW2_name_actdmn$config_ACT_QCOW2_name_drop$config_ACT_QCOW2_name_qcow2
echo $config_ACT_HOST_name_core
echo $config_ACT_OM_IP_addr_ipaddr
