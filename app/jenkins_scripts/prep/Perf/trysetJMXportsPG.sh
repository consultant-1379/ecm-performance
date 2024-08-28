#!/bin/sh
echo " Update setenv.sh with port jmxremote.port=7101 "
echo ""
###cd /usr/local/pgngn/tomcat-server-163.164.0.2/bin
cp -p setenv.sh setenv.sh.ORG
#var="export CATALINA_OPTS=\"-Xmx800m -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=7101 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/dve/localhost.\""

#echo "export CATALINA_OPTS=$CATALINA_OPTS -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=7101 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false" >> setenv.sh

#sed -i.bak 's/.*CATALINA_OPTS.*/'"$var"'/' setenv.sh

#var="echo \" -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=7101 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false\" >> setenv.sh"

# append to this word log 

eval $var

sed 2d -i.bak setenv.sh

echo " Verify setenv.sh updated "
echo ""
VAR="grep 7101 setenv.sh"
echo "grep 7101 setenv.sh"
eval $VAR

echo " Update dve-application-start.sh with port jmxremote.port=7100 "

cd /usr/local/pgngn/dve-application-4.74.0.3/bin/

cp -p dve-application-start.sh dve-application-start.sh.ORG

sed -i.bak '/server/ i -Dcom.sun.management.jmxremote \\' dve-application-start.sh
sed -i.bak '/server/ i -Dcom.sun.management.jmxremote.port=7100 \\' dve-application-start.sh
sed -i.bak '/server/ i -Dcom.sun.management.jmxremote.ssl=false \\' dve-application-start.sh
sed -i.bak '/server/ i -Dcom.sun.management.jmxremote.authenticate=false \\' dve-application-start.sh
echo ""
echo " Verify dve-application-start.sh updated "
grep 7100 dve-application-start.sh
echo ""
echo " NOTE: Need to reboot the PG hosts for these changes to take effects "
echo ""
echo " NOTE: after the reboot need to re-run the Jenkins script <2. Prepare_ECM_Nodes_for_Jmeter>
echo ""
