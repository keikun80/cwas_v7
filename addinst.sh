#!/bin/bash

function _front()
{ 
    TITLE="CHLUX INSTANCE CREATOR"
    clear
    eval printf %.0s\# '{1..'${COLUMNS:-$(tput cols)}'}'; echo    
    echo -e "" 
    printf "%*s\n" $(((${#TITLE}+$(tput cols))/2)) "$TITLE"
    echo -e "\t Version : 1.0" 
    echo -e "\t Author  : Chlux Co,Ltd."
    echo -e "\t Release : 25. Dec. 2016" 
    echo -e "\t Package : TOMCAT"
    echo -e ""
    #echo -e "\t INSTANCE NAME : "${INSTNAME}
    #echo -e "\t ACTION        : "$2 
    eval printf %.0s\# '{1..'${COLUMNS:-$(tput cols)}'}'; echo  
} 

function _footer()
{ 
echo "FOOTER"
}
function _setDefault()
{
    shutdownport=8005
    httpport=8080
    httpsport=8443
    redport=${httpsport}
    ajpport=8109
}
function addInst() { 

    #INSTROOT=`pwd` 
    #INSTDIR=${INSTROOT}/instance/${INSTNAME}
    #CONFDIR="conf/"  
    #CONFIG="sia.conf"
    #CONF=${CONFDIR}${CONFIG}    
    
    if [ ! -f .javaopts ]; then  
        echo -e "\e[31mCiritical] No file for setup JAVA_OTPS . Please run installer first\e[0m" 
        exit;
    fi 
    if [ -d ${INSTDIR} ]; then  
        echo -e "\e[33mAlready exist Instance name (${INSTNAME})\e[0m"
        echo -e "\e[93mExit script\e[0m" 
        exit
    fi 
 
    echo -e "\e[32mInstnace name : \e[33m" ${INSTNAME}"\e[0m"
    echo -e -n "\e[32mShutdown port (default : 8005) : \e[0m" 
    read a
    if [[ $a ]]; then
       shutdownport=${a} 
    fi 
    echo -e -n "\e[32mhttp port (default : 8080) : \e[0m"
    read b 
    if [[ $b ]]; then
       httpport=${b} 
    fi 
    echo -e -n "\e[32mhttps port (default : 8443) : \e[0m"
    read c
    if [[ $c ]]; then
       httpsport=${c} 
    fi 
    echo -e -n "\e[32mredirect port (default : 8443) : \e[0m"
    read d 
    if [[ $c ]]; then
      redport=${d} 
    fi 
    echo -e -n "\e[32majp port (default : 8109) : \e[0m"
    read e  
    if [[ $e ]]; then
      ajpport=${e} 
    fi 

    #echo -e "\e[32madd instance ${INSTNAME} \e[0m"
    echo -e "\e[32mcreate instance directory for  \e[33m${INSTNAME} \e[0m"
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
    echo -e "\e[32mcreate instance configuration for  \e[33m${INSTNAME} \e[0m"

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
    
    cat .javaopts >> ${INSTDIR}/${CONF}
    cp ${INSTROOT}/share/server.xml.dist ${INSTDIR}/${CONFDIR}server.xml

} 
function removeInst() {  
    `rm -rf ${INSTDIR}`
}

function _checkArgv()
{ 
    echo -e "\e[32mWill you create this instance  : \e[33m${INSTNAME}\e[0m" 
    read -r -p "Continue[Y/n] : " response
    case ${response} in
            [yY][eE][sS]|[yY])
                echo -e "\e[32mStart create instance \e[33m"${INSTNAME}"...\e[0m" 
                ;;
            [nN][oO]|[nN]) 
                echo -e "\e[93mExit script\e[0m" 
                exit
                ;;
            *)  
                echo -e "\e[93mExit script\e[0m" 
                exit
                ;;
        esac  
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
    exit
else 
    _front 
    _checkArgv 

    case $ARGV in 
    add) 
        _setDefault
        addInst
        ;;
    remove)
        removeInst  
        ;;
    esac 
fi
