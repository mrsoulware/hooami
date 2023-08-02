#!/bin/bash

fnGetHomePath()
{
	shellpath="$1"
	link=""
	while [ -h "$shellpath" ]; do
		ls=`ls -ld "$shellpath"`
		link=`expr "$ls" : '.*-> \(.*\)$'`
		if expr "$link" : '/.*' > /dev/null; then
			shellpath="$link"
		else
			shellpath=`dirname "$shellpath"`/"$link"
		fi
	done
	dirpath=`dirname $shellpath`
	homepath=`cd $dirpath; pwd -P`
	echo $homepath
}

HOOAMI_HOME=`fnGetHomePath $0`
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
export TOKEN="$TOKEN"
export HOOAMI_HOME="$HOOAMI_HOME"

echo "======================================================================="
echo " HOOAMI V0.9"
echo "======================================================================="
echo "[COMMAND - PARAM Mode]"
echo "======================================================================="


# cat ${HOOAMI_HOME}/script/param.cfg | while read Line; do
#     chk=`echo ${Line} | awk -F\| '{print $1}'`

chk=$(cat ${HOOAMI_HOME}/script/param.cfg | egrep -w "^$1|")
short=$(echo $chk | awk -F\| '{ print $1 }')
full=$(echo $chk | awk -F\| '{ print $2 }')

if [ -z $1 ]; then
    echo ""
    echo "Input Param please..."
    echo ""
    break;
fi;

if [ "$1" != "$short" ]; then 
    echo ""
    echo "Check Param please..."
    echo ""
    break;
fi;

if [ "$1" == "$short" ] && [ "$1" != "" ]; then
    param=$full
    echo ""
    echo "Call with param... [ $param ]"
    echo ""	
    if [ "$1" == "ALL" ]; then
        ${HOOAMI_HOME}/script/m99.sh
    else
        ${HOOAMI_HOME}/script/m19.sh $param
    fi;
    echo ""
    echo "End call......"
    echo ""
fi;

exit 0

