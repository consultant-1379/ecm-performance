MODULE_NAME=tomcat-server
export CATALINA_OPTS="-Xmx800m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/dve/ecm248x227.${MODULE_NAME}.$$.hprof -XX:+CrashOnOutOfMemoryError -XX:+ExitOnOutOfMemoryError -XX:ErrorFile=/var/log/dve/ecm248x227.${MODULE_NAME}.$$.hs_err.log"
