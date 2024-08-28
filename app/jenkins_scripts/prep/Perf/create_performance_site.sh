#!/bin/bash

# Exit on error
set -e
#set -x

jdbc_host=$1
url=$2
conf_type=$3
home_dir=~

echo ""
echo "jdb_host string: " $1
echo y > ${home_dir}/yes
cd /app/ecm/tools/cmdb/cmdb-util/util

echo "URL string:      " $2

echo ""
echo "conf_type string [17 or 18]: " $3
echo " "

gui_user=$4
gui_pswd=$5

#echo -n "username:password" | base64
CODED_AUTH=$(echo -n "${gui_user}":"${gui_pswd}" | base64)

function run0() {
  cmdline=$1
  echo "Command to get the current sites: $cmdline"
  echo "This is the result for current sites:"
  eval $cmdline
}

echo " Get the current sites before the update "

#run0 "curl --insecure -X GET --header 'Accept: application/json' --header 'Authorization: Basic ZWNtYWRtaW46Q2xvdWRBZG1pbjEyMw==' --header 'TenantId: ecm' 'https://$2/ecm_service/sites'"
run0 "curl --insecure -X GET --header 'Accept: application/json' --header 'Authorization: Basic '"$CODED_AUTH"'' --header 'TenantId: ecm' 'https://$2/ecm_service/sites'"
echo " "

function run() {
  cmdline=$1
  echo "Script cmdbUpdate.sh to be executed on Core VM: $cmdline"
  echo ""
  eval $cmdline
}
echo ""

case ${conf_type} in
              17)
                ./cmdbUpdate.sh -filename ~/performance_site.yaml -mode commit -username cmdb -password cmdb -jdbcUrl jdbc:oracle:thin:@$1:1521/ecmdb1 -logLevel info<  /tmp/yes
                ;;
              18|18os)
		sudo ./cmdbUpdate.sh -filename ${home_dir}/performance_site.yaml  -mode commit -username cmdb -password uAPTZQ7+9n49Zb -jdbcUrl jdbc:edb://edb_host:5432/ecmdb1 -logLevel info < ${home_dir}/yes

                ;;
              *)
                echo "Unsupported configuration type \"$conf_type\". Aborting."
                exit
                ;;
            esac


echo " Get the current sites after the update "
run0 "curl --insecure -X GET --header 'Accept: application/json' --header 'Authorization: Basic '"$CODED_AUTH"'' --header 'TenantId: ecm' 'https://$2/ecm_service/sites'"
echo " Done on Core VM "
