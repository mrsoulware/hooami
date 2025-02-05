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

inputItem=$1

# read -p "Input the item of Menu list (quit for exit) : " inputItem
echo ${inputItem};

if [ "$inputItem" = "INSTANCE-ID" ]; then
	$HOOAMI_HOME/../script/m1.sh
elif [ "$inputItem" = "VIEW-ALL" ]; then
	$HOOAMI_HOME/../script/m99.sh
fi;
echo "======================================================================="

exit 0

