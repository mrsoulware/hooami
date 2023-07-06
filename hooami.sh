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
echo "[1] INSTANCE-ID"
echo "[99] VIEW-ALL"
echo "======================================================================="

inputNo=0

while true
do
	read -p "Input the number of Menu list (0 for exit) : " inputNo

	if [ "$inputNo" = "1" ]; then
		$HOOAMI_HOME/script/m1.sh
	elif [ "$inputNo" = "99" ]; then
		$HOOAMI_HOME/script/m99.sh
	elif [ "$inputNo" = "0" ]; then
		break;
	fi
done

exit 0

