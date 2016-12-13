#!/bin/bash


function addInst() { 

    shutdownport=8005
    httpport=8080
    httpsport=8443
    redport=${httpsport}
    ajpport=8109
    #INSTROOT=`pwd` 
    #INSTDIR=${INSTROOT}/instance/${INSTNAME}
    #CONFDIR="conf/"  
    #CONFIG="sia.conf"
    #CONF=${CONFDIR}${CONFIG}    

    if [ -d ${INSTDIR} ]; then  
        echo "Already exist Instance name (${INSTNAME})"
        exit
    fi 
 
    echo -e "Instnace name : " ${INSTNAME} 
    echo -n "Shutdown port (default : 8005) : " 
    read a
    if [[ $a ]]; then
       shutdownport=${a} 
    fi 
    echo -n "http port (default : 8080) : "
    read b 
    if [[ $b ]]; then
       httpport=${b} 
    fi 
    echo -n "https port (default : 8443) : "
    read c
    if [[ $c ]]; then
       httpsport=${c} 
    fi 
    echo -n "redirect port (default : 8443) : "
    read d 
    if [[ $c ]]; then
      redport=${d} 
    fi 
    echo -n "ajp port (default : 8109) : "
    read e  
    if [[ $e ]]; then
      ajpport=${e} 
    fi 

    echo -e "add instance ${INSTNAME}"
    mkdir -p ${INSTDIR}
    mkdir -p ${INSTDIR}/${CONFDIR}
    mkdir -p ${INSTDIR}/lib
    mkdir -p ${INSTDIR}/logs
    mkdir -p ${INSTDIR}/temp
    mkdir -p ${INSTDIR}/work
    mkdir -p ${INSTDIR}/webapps
    cp -r share/web.xml ${INSTDIR}/${CONFDIR}/web.xml
    cp -r share/webapps/ ${INSTDIR}/
   
#    cat > .tempconfig  << EOF
##!/bin/bash
#sia_instname=${INSTNAME}
#sia_shutdown=${shutdownport}
#sia_http=${httpport}
#sia_https=${httpsport}
#sia_redirect=${redport}
#sia_ajp=${ajpport} 
#sia_jvmroute=${INSTNAME}
#export JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.shutdown=\$sia_instname
#export JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.http=\$sia_shutdown
#export JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.https=\$sia_http
#export JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.redirect=\$sia_https
#export JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.ajp=\$sia_ajp
#export JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.jvmroute=\$sia_instname
#EOF
    echo -e "#!/bin/bash"  >>                                                       ${INSTDIR}/${CONF}
    echo -e "sia_instname=\"${INSTNAME}\"" >>                                          ${INSTDIR}/${CONF}
    echo -e "sia_shutdown=${shutdownport}" >>                                       ${INSTDIR}/${CONF}
    echo -e "sia_http=${httpport}" >>                                               ${INSTDIR}/${CONF}
    echo -e "sia_https=${httpsport}" >>                                             ${INSTDIR}/${CONF}
    echo -e "sia_redirect=${redport}" >>                                            ${INSTDIR}/${CONF}
    echo -e "sia_ajp=${ajpport} " >>                                                ${INSTDIR}/${CONF}
    echo -e "sia_jvmroute=\"${INSTNAME}\"" >>                                           ${INSTDIR}/${CONF} 
    
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.shutdown=\$sia_shutdown\"" >> ${INSTDIR}/${CONF}
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.http=\$sia_http\"" >>     ${INSTDIR}/${CONF}
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.https=\$sia_https\"" >>        ${INSTDIR}/${CONF}
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.redirect=\$sia_redirect\"">>     ${INSTDIR}/${CONF}
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.ajp=\$sia_ajp\"" >>           ${INSTDIR}/${CONF}
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.jvmroute=\$sia_instname\"" >> ${INSTDIR}/${CONF} 

    cp ${INSTROOT}/share/server.xml.dist ${INSTDIR}/${CONFDIR}server.xml

} 
function removeInst() {  
    `rm -rf ${INSTDIR}`
}


INSTNAME=$1 
ARGV=$2   
#currentDir=`pwd`
INSTROOT=`pwd` 
INSTDIR=${INSTROOT}/instance/${INSTNAME}
CONFDIR="conf/"  
CONFIG="sia.conf"
CONF=${CONFDIR}${CONFIG}     

if [ "$#" -ne 2 ]; then  
    echo "Usage : instadd.sh [Instance] {add | remove}"
fi
case $ARGV in 

add)
    addInst
    ;;
remove)
   removeInst  
    ;;
esac
