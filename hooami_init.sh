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
#TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
#export TOKEN="$TOKEN"
export HOOAMI_HOME="$HOOAMI_HOME"

echo "======================================================================="
echo " HOOAMI V0.9"
echo "======================================================================="
echo "[TUI] Text-User Interface"
echo "[CLI] Command Line Interface"
echo "======================================================================="

inputStr=''

while true
do
	read -p "Input the string of Menu list (0 for exit) : " inputStr
	echo ${inputStr}

	if [ "$inputStr" = "TUI" ]; then
	        sudo python3.9 $HOOAMI_HOME/tui.py
		break;
	elif [ "$inputStr" = "CLI" ]; then
		$HOOAMI_HOME/hooami3_view.sh
		break;
	elif [ "$inputStr" = "0" ]; then
		break;
	fi
done

exit 0

