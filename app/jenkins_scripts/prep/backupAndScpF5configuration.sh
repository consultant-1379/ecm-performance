#!/bin/sh

. /app/jenkins_scripts/prep/Installation/perf_config_reader.sh

system=$1
sw_version_string=$2

BACKUP_SERVER_IP=10.216.154.206

restIP=$(get_PerfURL $system)

echo -e "\nSaving F5 configuration:\n"

#/home/keep-F5-files/ecm248x231
#F5-BIGIP-ecm248x231-18.0D722-June-29-2018.scf

F5_IPs=$(get_F5VMs $system)
#echo -e "\nF5_IPs=$F5_IPs"

PASS="ecm123"

FIRST_F5_IP=$(echo "$F5_IPs" | sed -n 1p)
#echo -e "\nFIRST_F5_IP=$FIRST_F5_IP"

FILENAME_PREFIX=F5-BIGIP-$(get_VM_Property $system f5 host | sed -n 1p)-$sw_version_string-$(date +%Y%m%d-%H%M%S)
#echo -e "\nFILENAME_PREFIX=$FILENAME_PREFIX"

sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$FIRST_F5_IP tmsh save /sys config file $FILENAME_PREFIX.scf no-passphrase

echo -e "\nDownloading backup files from F5 VM to local:\n"

sshpass -p $PASS scp -o ConnectTimeout=2 root@$FIRST_F5_IP:/var/local/scf/$FILENAME_PREFIX.scf /tmp
sshpass -p $PASS scp -o ConnectTimeout=2 root@$FIRST_F5_IP:/var/local/scf/$FILENAME_PREFIX.scf.tar /tmp

echo -e "\nFiles downloaded to local:\n"
find /tmp/$FILENAME_PREFIX.scf -exec ls -l {} \;
find /tmp/$FILENAME_PREFIX.scf.tar -exec ls -l {} \;

echo -e "\nUploading files from local to $BACKUP_SERVER_IP:\n"
BACKUP_SERVER_STOREDIR=/home/keep-F5-files/$(get_VM_Property $system f5 host | sed -n 1p)
#echo -e "BACKUP_SERVER_STOREDIR=$BACKUP_SERVER_STOREDIR"

echo -e "\nCreating BACKUP_SERVER_STOREDIR..."
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$BACKUP_SERVER_IP mkdir $BACKUP_SERVER_STOREDIR

echo -e "\nSCP to backup server...\n"
sshpass -p $PASS scp -o ConnectTimeout=2 /tmp/$FILENAME_PREFIX.scf root@$BACKUP_SERVER_IP:$BACKUP_SERVER_STOREDIR
sshpass -p $PASS scp -o ConnectTimeout=2 /tmp/$FILENAME_PREFIX.scf.tar root@$BACKUP_SERVER_IP:$BACKUP_SERVER_STOREDIR

echo -e "\nListing backup files on backup server:"
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$BACKUP_SERVER_IP "find $BACKUP_SERVER_STOREDIR/$FILENAME_PREFIX.scf -exec ls -l {} \;"
sshpass -p $PASS ssh -oStrictHostKeyChecking=no -oConnectTimeout=2 root@$BACKUP_SERVER_IP "find $BACKUP_SERVER_STOREDIR/$FILENAME_PREFIX.scf.tar -exec ls -l {} \;"

echo -e "\nDeleting local files...\n"
rm -fv /tmp/$FILENAME_PREFIX.scf
rm -fv /tmp/$FILENAME_PREFIX.scf.tar

echo -e "\nJob done\n"

exit
