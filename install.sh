#!/bin/bash  


currentDir=`pwd`;
echo ${JAVA_HOME} 
echo ${CLASSPATH} 
temp_java_home=${JAVA_HOME}
# check JAVA_OPT 

if [[ ! ${JAVA_HOME} ]]; then 
    echo "enter JAVA_HOME for tomcat"
    read a
    if [[ $a ]]; then
        temp_java_home=${a}    
    fi
fi
  
`cp ./launcher.sh.dist ./launcher.sh` 
sed -i -e "s:CHANGE_JAVA_HOME:${temp_java_home}:g" launcher.sh 

mkdir instance
#echo ${temp_java_home}  
#echo -e 'export JAVA_HOME='${temp_java_home} >> .setenv 

# else input JAVA_OPT 


#check PATH include java

