source .bash_profile

touch /root/.pgpass
chmod 0600 ~/.pgpass
#echo "localhost:5432:ecmdb1:cmdb:cmdb" >> /root/.pgpass
echo "localhost:5432:ecmdb1:cmdb:uAPTZQ7+9n49Zb" >> /root/.pgpass
echo " Assets currently loaded in DBM database: "
psql -w -U cmdb ecmdb1 <<EOF
SELECT
(SELECT COUNT(*) FROM CM_TENANT) AS TENANTs,
(SELECT COUNT(*) FROM CM_VIMZONE) AS VIMs,
(SELECT COUNT(*) FROM CM_VDC) AS VDCs,
(SELECT COUNT(*) FROM CM_VAPP) AS VAPPs,
(SELECT COUNT(*) FROM CM_VN) AS VNs,
(SELECT COUNT(*) FROM CM_SUBNET) AS SUBNETs,
(SELECT COUNT(*) FROM CM_SERVER) AS VMs,
(SELECT COUNT(*) FROM CM_VNIC) AS VM_VNICs,
(SELECT COUNT(*) FROM CM_BSV) AS BSVs;
EOF
echo ""
echo " List of Tenants: "
echo ""
psql -w -U cmdb ecmdb1 <<EOF
SELECT NAME FROM cmdb.cm_tenant ORDER BY id ASC;
EOF
