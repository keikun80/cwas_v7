#!/bin/bash  


currentDir=`pwd`;
#echo ${JAVA_HOME} 
#echo ${CLASSPATH}  



temp_java_home=${JAVA_HOME}
# check JAVA_OPT 

#if [[ ! ${JAVA_HOME} ]]; then 
echo -e "APACHE TOMCAT INSTALLATION - SIA"
echo -n "enter JAVA_HOME for tomcat (default : ${temp_java_home} ) : "
read a
if [[ $a ]]; then
    temp_java_home=${a}    
fi
#fi
  
`cp share/launcher.sh.dist ./launcher.sh` 
sed -i -e "s:CHANGE_JAVA_HOME:${temp_java_home}:g" launcher.sh 

if [ ! -d instnace ]; then 
    mkdir -p instance
fi
#echo ${temp_java_home}  
#echo -e 'export JAVA_HOME='${temp_java_home} >> .setenv 

# else input JAVA_OPT 


#check PATH include java

