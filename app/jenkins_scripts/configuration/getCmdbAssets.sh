echo -e "SET HEADING OFF\nSET FEEDBACK OFF\nselect Name from CM_TENANT WHERE Name <> 'ECM';" | sqlplus -s cmdb/cmdb@ecmrac-ka2-scan:1521/ecmdb1
