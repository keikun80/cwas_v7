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
	UNAME=`id -u -n`
 
} 

function _footer()
{ 
echo "FOOTER"
} 

# check JAVA_OPT  
function _setjavahome()
{
    if [[ ! ${temp_java_home} ]]; then
        echo -n -e "\e[32mEnter JAVA_HOME(JRE) for tomcat (default : \\e[2m${temp_java_home} ) : \e[0m"
        read a
        if [[ $a ]]; then
            temp_java_home=${a}
        else
            echo -e "\e[91mYou should enter JAVA_HOME(JRE)\e[0m"   
            exit;
            #_setjavahome;
        fi
    else
        echo -e "\e[32mTomcat will use this JAVA_HOME : \e[2m${temp_java_home}\e[0m" 
        read -r -p "Continue[Y/n] : " response
        case ${response} in
            [yY][eE][sS]|[yY])
                echo -e "\e[32mTomcat installing ...\e[0m" 
                ;;
            [nN][oO]|[nN])
                temp_java_home=""
                _setjavahome
                ;;
            *)
                echo -n -e "\e[32mEnter JAVA_HOME(JRE) for tomcat (default : \\e[2m${temp_java_home} ) : \e[0m"
                ;;
        esac
    fi
}

function _getjavaversion() 
{
    echo -e -n "\e[32mChecking JAVA Version (java : ${temp_java_home}/bin/java -version ):"
    javav=`${temp_java_home}/bin/java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}'`
    echo -e ${javav}"\e[0m" 

    if [ -z ${javav} ]; then
        echo -e "\e[31mWrong JAVA_HOME path, Please check again JAVA_HOME\e[0m"  
        exit;
    fi
}

function _setjavaopt()
{
    echo -e "\e[32msetup JAVA_OPTS for ${javav} \e[0m"
   jdk6=$(echo $javav | sed -n '/1.6.0/p')
   jdk7=$(echo $javav | sed -n '/1.7.0/p')
   jdk8=$(echo $javav | sed -n '/1.8.0/p')

    if [ ! -z ${jdk6} ]; then
        #SET JAVA_OPT 
        #echo ${jdk6} 
        #OPT="export \"JAVA_OPTS=\$JAVA_OPTS -Xms128m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=1024m\""
        OPT="export \"JAVA_OPTS=\$JAVA_OPTS -Xms1024m -Xmx2048m -XX:PermSize=512m -XX:MaxPermSize=1024m\"" 
    fi

    if [ ! -z ${jdk7} ]; then
        #SET JAVA_OPT
        #echo ${jdk7} 
        #OPT="export \"JAVA_OPTS=\$JAVA_OPTS -server -Xms128m -Xmx512m\""
        OPT="export \"JAVA_OPTS=\$JAVA_OPTS -Xms1024m -Xmx2048m -XX:PermSize=512m -XX:MaxPermSize=1024m\""
    fi

    if [ ! -z ${jdk8} ]; then
        #SET JAVA_OPT
        #echo ${jdk8}
        #OPT="export \"JAVA_OPTS=\$JAVA_OPTS -server -Xms128m -Xmx512m\""
        OPT="export \"JAVA_OPTS=\$JAVA_OPTS -server -Xms1024m -Xmx2048m -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=512m\""
        #OPT="export \"JAVA_OPTS=\$JAVA_OPTS -Xms128m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=1024m\""
    fi  
	
	FIXEDOPT="export \"JAVA_OPTS=\$JAVA_OPTS -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintHeapAtGC -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -Djava.awt.headless=true -Dcom.sun.management.jmxremote\""
    
	echo -e "export JAVA_HOME=${temp_java_home}" > .javaopts
    echo -e ${OPT} >> .javaopts 
    echo -e ${FIXEDOPT} >> .javaopts 
}

function _setDefault()
{
    shutdownport=8005
    httpport=8080
    httpsport=8443
    redport=${httpsport}
    ajpport=8009
}
function addInst() { 

    #INSTROOT=`pwd` 
    #INSTDIR=${INSTROOT}/instance/${INSTNAME}
    #CONFDIR="conf/"  
    #CONFIG="sia.conf"
    #CONF=${CONFDIR}${CONFIG}    
    
    #if [ ! -f .javaopts ]; then  
    #    echo -e "\e[31mCiritical] No file for setup JAVA_OTPS . Please run installer first\e[0m" 
    #    exit;
    #fi  

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
    echo -e -n "\e[32majp port (default : 8009) : \e[0m"
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
    #cp -r share/conf/web.xml ${INSTDIR}/${CONFDIR}/web.xml 
    cp -r share/conf ${INSTDIR}/.
    cp -r share/webapps/ ${INSTDIR}/
   
    echo -e "\e[32mcreate instance configuration for  \e[33m${INSTNAME} \e[0m"

    echo -e "#!/bin/bash"  >>                                                       ${INSTDIR}/${CONF}
    echo -e "sia_instname=\"${INSTNAME}\"" >>                                          ${INSTDIR}/${CONF}
    echo -e "sia_shutdown=${shutdownport}" >>                                       ${INSTDIR}/${CONF}
    echo -e "sia_http=${httpport}" >>                                               ${INSTDIR}/${CONF}
    echo -e "sia_https=${httpsport}" >>                                             ${INSTDIR}/${CONF}
    echo -e "sia_redirect=${redport}" >>                                            ${INSTDIR}/${CONF}
    echo -e "sia_ajp=${ajpport} " >>                                                ${INSTDIR}/${CONF}
    echo -e "sia_jvmroute=\"${INSTNAME}\"" >>                                           ${INSTDIR}/${CONF} 
   

    cat .javaopts >> ${INSTDIR}/${CONF}
    rm .javaopts 
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.shutdown=\$sia_shutdown\""  >> ${INSTDIR}/${CONF}
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.http=\$sia_http\"" >>     ${INSTDIR}/${CONF}
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.https=\$sia_https\"" >>        ${INSTDIR}/${CONF}
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.redirect=\$sia_redirect\"" >>     ${INSTDIR}/${CONF}
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.ajp=\$sia_ajp\"" >>           ${INSTDIR}/${CONF}
    echo -e "export \"JAVA_OPTS=\$JAVA_OPTS -Dtomcat.port.jvmroute=\$sia_instname\"" >> ${INSTDIR}/${CONF} 
   #echo -e "export \"JAVA_OPTS=\$JAVA_OPTS ${OPT}" >> ${INSTDIR}/${CONF} 
    
    #cat .javaopts >> ${INSTDIR}/${CONF}
    cp ${INSTROOT}/share/dist/server.xml.dist ${INSTDIR}/${CONFDIR}server.xml

} 
function removeInst() {  
    `rm -rf ${INSTDIR}`
}

function _confirm()
{ 
    echo -e "\e[32mWill you create this instance  : \e[33m${INSTNAME}\e[0m" 
    read -r -p "Continue[y/N] : " response
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
INSTROOT=`pwd`  
temp_java_home="/etc/alternatives/jre";
INSTDIR=${INSTROOT}/instance/${INSTNAME}
CONFDIR="conf/"  
CONFIG="sia.conf"
CONF=${CONFDIR}${CONFIG}     

if [ "$#" -ne 2 ]; then  
    echo "Usage : instadd.sh [Instance] {add | remove}" 
    exit
else 
    _front 
    case $2 in 
    "add" )   
	_confirm
	_setjavahome
	_getjavaversion
	_setjavaopt
        _setDefault 
        addInst
        ;;
    "remove" )
        removeInst  
        ;; 
	*)
		exit
    esac 
fi
