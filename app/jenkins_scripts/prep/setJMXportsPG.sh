#!/bin/sh
echo " Update setenv.sh with port jmxremote.port=7101 "
#cd /usr/local/pgngn/tomcat-server-161.133/bin/
cd /usr/local/pgngn/tomcat-server-163.164.0.2/bin/
cp -p setenv.sh setenv.sh.ORG
var="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=7101 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"

#sed -i.bak 's/.*CATALINA_OPTS.*/'"$var"'/' setenv.sh

echo $var

sed -i 's/hs_err.log/hs_err.log '"$var"'/g' setenv.sh

echo " Verify setenv.sh updated "
echo ""
grep 7101 setenv.sh

echo " Update dve-application-start.sh with port jmxremote.port=7100 "
echo ""
#cd /usr/local/pgngn/dve-application-3.101/bin/
cd /usr/local/pgngn/dve-application-4.74.0.3/bin/

cp -p dve-application-start.sh dve-application-start.sh.ORG

sed -i.bak '/server/ i -Dcom.sun.management.jmxremote \\' dve-application-start.sh
sed -i.bak '/server/ i -Dcom.sun.management.jmxremote.port=7100 \\' dve-application-start.sh
sed -i.bak '/server/ i -Dcom.sun.management.jmxremote.ssl=false \\' dve-application-start.sh
sed -i.bak '/server/ i -Dcom.sun.management.jmxremote.authenticate=false \\' dve-application-start.sh

echo " Verify dve-application-start.sh updated "
echo ""
grep 7100 dve-application-start.sh

echo " Done. "
