echo ""
echo " ******************************* "
echo " seliics01406 BLADE "
echo " ******************************* "
ping -c 1 seliics01406
ping -c 1 ecm248x225
ping -c 1 ecm248x227
ping -c 1 ecm248x229
ping -c 1 ecm248x231
ping -c 1 ecm248x255

echo ""
echo " ******************************* "
echo " seliics01407 BLADE "
echo " ******************************* "
ping -c 1 seliics01407
ping -c 1 ecm248x226
ping -c 1 ecm248x228
ping -c 1 ecm248x230
ping -c 1 ecm248x233

echo ""
echo " ******************************* "
echo " SCAN VIPs "
echo " ******************************* "
ping -c 1 ecmrac-ka26-scan
ping -c 1 ecmrac1-ka26-vip
ping -c 1 ecmrac2-ka26-vip


echo ""
echo " ******************************* "
echo " bridge = bigipoambr "
echo " ******************************* "
ping -c 1 10.216.248.124
ping -c 1 10.216.248.225
ping -c 1 10.216.248.227
ping -c 1 10.216.248.229
ping -c 1 10.216.248.231
ping -c 1 10.216.248.255
ping -c 1 10.216.248.125
ping -c 1 10.216.248.226
ping -c 1 10.216.248.228
ping -c 1 10.216.248.230
ping -c 1 10.216.248.232
ping -c 1 10.216.248.105
ping -c 1 10.216.249.125
ping -c 1 10.216.249.126
echo ""
echo " ******************************* "
echo " bridge = bigipfebr "
echo " ******************************* "
ping -c 1 10.61.254.1
ping -c 1 10.61.254.2
ping -c 1 10.61.254.3
ping -c 1 10.61.254.4
ping -c 1 10.61.254.5
ping -c 1 10.61.254.6
ping -c 1 10.61.254.7
ping -c 1 10.61.254.8
ping -c 1 10.61.254.9
ping -c 1 10.61.254.10

echo ""
echo " ******************************* "
echo " ECA & Postgres VIPs "
echo " ******************************* "
ping -c 1 10.216.242.223
ping -c 1 10.216.242.224
echo ""
echo " ******************************* "
echo " bridge = bigipaccessbr "
echo " ******************************* "
ping -c 1 10.216.243.70
ping -c 1 10.216.243.71
ping -c 1 10.216.243.72
ping -c 1 10.216.243.73
echo ""
echo " ******************************* "
echo " bridge = bigipfobr "
echo " ******************************* "
ping -c 1 192.168.10.55
ping -c 1 192.168.10.56
echo ""
echo " ******************************* "
echo " Gateways "
echo " ******************************* "
ping -c 1 10.216.248.1
ping -c 1 10.216.243.1
echo ""
echo " ******************************* "
echo " ecmrac-ka26-scan "
echo " ******************************* "
ping -c 1 10.216.248.220
ping -c 1 10.216.248.221
ping -c 1 10.216.248.222
echo ""
echo " ******************************* "
echo " Access URL "
echo " ******************************* "
ping -c 1 10.216.243.73
echo ""
echo " ******************************* "
echo " ecmrac1-ka26-vip  ecmrac2-ka26-vip "
echo " ******************************* "
ping -c 1 10.216.248.223
ping -c 1 10.216.248.224
