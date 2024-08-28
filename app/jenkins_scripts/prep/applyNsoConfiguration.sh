#!/bin/sh

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1

restIP=$(get_PerfURL $system)

echo -e "\nApplying NSO post installation steps, which is described in the \"ECM_NSO_SelfContained_Demo_Kit_B\" from Chirag"

echo -e "\nStep#1a:"

echo -e "\nrestIP: "$restIP

newman_environment_template_file="/app/performance_production/NSO_configuration/ECM_NSO_SelfContained_Demo_Kit_B/ECM_NSO_Demo_Chrome_Postman_Collections/Perf-nonHA-ECM18-NSO-Demo--Kit-Environment.postman_environment.json"

newman_environment_file_to_use="/app/performance_production/NSO_configuration/ECM_NSO_SelfContained_Demo_Kit_B/ECM_NSO_Demo_Chrome_Postman_Collections/env.json"

postman_collection_file_to_run="/app/performance_production/NSO_configuration/ECM_NSO_SelfContained_Demo_Kit_B/ECM_NSO_Demo_Chrome_Postman_Collections/Step1a---Service-Config-Mapping-Table-ECM-NSO-Demo-APIs.postman_collection.json"

for URL in $restIP
do
	echo -e "\ncomposing restIP value into the newman environment file: "$newman_environment_file_to_use
	cat $newman_environment_template_file | sed -e "s/ECM-IP-DNSADDRESS/$restIP/" > $newman_environment_file_to_use

	echo -e "\nInvoking newman to run postman collection against the core VM: "$restIP"\n"
	newman run $postman_collection_file_to_run --environment $newman_environment_file_to_use --insecure

	echo -e "\nDeleting temporary env file: "$newman_environment_file_to_use"\n"
	rm -f $newman_environment_file_to_use
done


echo -e "\nStep#1b:"

echo -e "\nCopying sample model files from NSO to ACT:"

PASS="ecm123"

NSO_IPs=$(get_NsoVMs $system)
echo -e "\nNSO_IPs=$NSO_IPs"

FIRST_NSO_IP=$(echo "$NSO_IPs" | sed -n 1p)
echo -e "\nFIRST_NSO_IP=$FIRST_NSO_IP"


ACT_IPs=$(get_ActVMs $system)
echo -e "\nACT_IPs=$ACT_IPs"

FIRST_ACT_IP=$(echo "$ACT_IPs" | sed -n 1p)
echo -e "\nFIRST_ACT_IP=$FIRST_ACT_IP"

#sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_NSO_IP uptime

echo -e "\nGetting files from NSO server via scp..."
sshpass -p $PASS scp -o ConnectTimeout=2 root@$FIRST_NSO_IP:/opt/ericsson/do/samples/scm/deploy_scm_samples.sh /tmp
sshpass -p $PASS scp -o ConnectTimeout=2 root@$FIRST_NSO_IP:/opt/ericsson/do/samples/scm/scm_samples.tar.gz /tmp

echo -e "\nDownloaded files from NSO:"
ls -l /tmp/deploy_scm_samples.sh
ls -l /tmp/scm_samples.tar.gz

echo -e "\nCopy files to ACT via scp..."
sshpass -p $PASS scp -o ConnectTimeout=2 /tmp/deploy_scm_samples.sh root@$FIRST_ACT_IP:/tmp
sshpass -p $PASS scp -o ConnectTimeout=2 /tmp/scm_samples.tar.gz root@$FIRST_ACT_IP:/tmp

echo -e "\nUploaded files on ACT:"
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP ls -l /tmp/deploy_scm_samples.sh
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP ls -l /tmp/scm_samples.tar.gz


echo -e "\nChange the owner and permissions for the files on ACT:"
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP chmod -v 750 /tmp/deploy_scm_samples.sh /tmp/scm_samples.tar.gz
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP chown -v actadm:activation /tmp/deploy_scm_samples.sh /tmp/scm_samples.tar.gz

echo -e "\nSwitch to the actadm user on ACT and execute the deploy script:"
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP sudo -u actadm /tmp/deploy_scm_samples.sh

echo -e "\nTo verify that the sample models were loaded correctly to the Activation VM,"
echo -e "open a browser window and navigate to the Ericsson Dynamic Activation Resource Configuration GUI URL:"

SYSTEM_TYPE=$(get_SystemType $system)
#echo -e "\nSYSTEM_TYPE=$SYSTEM_TYPE"

if [ $SYSTEM_TYPE = ha ]
then
	echo -e "https://$(get_System_ACT_EXT_VIP $system):8383/scm"
else
        echo -e "https://$FIRST_ACT_IP:8383/scm"
fi

echo -e "To access the sample feature models, click on the Launch Model Browser button! These should be seen:\n"
echo -e "BaseConfig"
echo -e "HealthStatus"
echo -e "LicenseMgmt"
echo -e "Security"
echo -e "ServiceLevelChange\n"
echo -e "To access the sample vendor templates, click on the Launch Template Management button! These should be seen:\n"
echo -e "Router_Cisco_1"
echo -e "Security_Fortinet_1"
echo -e "Security_PaloAlto_1"
echo -e "SFType_SFVendor_SFVersion\n"


echo -e "uploading Chirag files to ACT:"
CHIRAG_FILES='/app/performance_production/NSO_configuration/ECM_NSO_SelfContained_Demo_Kit_B/ECM_NSO_Demo_Onboarding_References/NSO_SCM_VendorTemplates'
sshpass -p $PASS scp -o ConnectTimeout=2 $CHIRAG_FILES/nso_add_pnfuser.sh root@$FIRST_ACT_IP:/tmp
sshpass -p $PASS scp -o ConnectTimeout=2 $CHIRAG_FILES/nso_deploy_demo_vendor_templates.sh root@$FIRST_ACT_IP:/tmp
sshpass -p $PASS scp -o ConnectTimeout=2 $CHIRAG_FILES/nso_demo_scm_templates.tar.gz root@$FIRST_ACT_IP:/tmp


echo -e "\nUploaded files on ACT:"
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP ls -l /tmp/nso_add_pnfuser.sh
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP ls -l /tmp/nso_deploy_demo_vendor_templates.sh
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP ls -l /tmp/nso_demo_scm_templates.tar.gz

echo -e "\nChange the owner and permissions for the files on ACT:"
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP chmod 750 /tmp/nso_add_pnfuser.sh /tmp/nso_deploy_demo_vendor_templates.sh /tmp/nso_demo_scm_templates.tar.gz
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP chown actadm:activation /tmp/nso_deploy_demo_vendor_templates.sh /tmp/nso_demo_scm_templates.tar.gz /tmp/nso_add_pnfuser.sh

echo -e "\nSwitch to the actadm user on ACT and execute the deploy script:"
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_ACT_IP sudo -u actadm /tmp/nso_deploy_demo_vendor_templates.sh

echo -e "\nTo verify that the sample models were loaded correctly to the Activation VM,"
echo -e "To access the sample feature models, click on the Launch Model Browser button! These should be seen:\n"

if [ $SYSTEM_TYPE = ha ]
then
     echo -e "https://$(get_System_ACT_EXT_VIP $system):8383/scm"
else
        echo -e "https://$FIRST_ACT_IP:8383/scm"
fi

echo -e "BaseConfig"
echo -e "HealthStatus"
echo -e "LicenseMgmt"
echo -e "Security"
echo -e "ServiceLevelChange\n"
echo -e "To access the sample vendor templates, click on the Launch Template Management button! These should be seen:\n"
echo -e "> Controller_Ericsson_101"
echo -e "> Generic_DCGWVendor_101"
echo -e "Router_Cisco_1"
echo -e "> Router_L3Tech_101"
echo -e "Security_Fortinet_1"
echo -e "> Security_GuardTech_101"
echo -e "Security_PaloAlto_1"
echo -e "SFType_SFVendor_SFVersion\n"

exit
