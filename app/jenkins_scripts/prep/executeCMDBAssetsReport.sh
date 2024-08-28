#!/bin/sh
. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1

# Get configuration type  for selected system
conf_type=$(get_ConfigurationType $system)

echo -e "\nsystem is: " $system
echo -e "\nconf_type string [17 or 18]: " $conf_type

case $conf_type in
              17)
			nodes=$(get_Blades $system)
			OracleNode=$(echo $nodes | awk 'NR==1{print $1; exit}')
			OPASS="1qaz2wsx"

			echo -e "\nOracle node is: "$OracleNode

			echo -e "\nCopying files to "$OracleNode
			sshpass -p $OPASS scp  -oConnectTimeout=2 -r /app/jenkins_scripts/prep/Perf/report1.sh oracle@$OracleNode:/home/oracle
			echo -e "\nsshpass return value: "$?

			echo -e "\nExecuting sql report script on "$OracleNode
			sshpass -p $OPASS ssh -t -t -oConnectTimeout=2 oracle@$OracleNode /home/oracle/report1.sh
                        echo -e "\nsshpass return value: "$?

			echo -e "\nDone."
                	;;
              18)
			nodes=$(get_DbmVMs $system)
			DbmNode=$(echo $nodes | awk 'NR==1{print $1; exit}')
			PASS="ecm123"

			echo -e "\nDBM node is: "$DbmNode

			echo -e "\nCopying files to "$DbmNode
			sshpass -p $PASS scp /app/jenkins_scripts/prep/Perf/report_dbm.sh root@$DbmNode:/root/report_dbm.sh
                        echo -e "\nsshpass return value: "$?

			echo -e "\nExecuting psql report script on "$DbmNode
			sshpass -p $PASS ssh -t -t root@$DbmNode /root/report_dbm.sh
                        echo -e "\nsshpass return value: "$?

			echo -e "\nDone."
			;;
              *)
			echo "Unsupported configuration type \"$conf_type\". Aborting."
			exit
			;;
esac
