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
#echo "[1] INSTANCE-ID"
#echo "[99] VIEW-ALL"
echo "[COMMAND - VIEW&COPY Mode]"

inputNo=0

while true
do
        echo "=======================================================================";
        # list view
        cat $HOOAMI_HOME/script/param.cfg | while read Line; do
            short=`echo $Line | awk -F\| '{print $1}'`;
            full=`echo $Line | awk -F\| '{print $2}'`;
	    length=`echo $short | wc -L`;
	    if [ $length -lt 6 ]; then
                echo -e "[ "$short"\t\t]\t"$full;
            else
                echo -e "[ "$short"\t]\t"$full;
	    fi
	done;
        echo "=======================================================================";
	read -p "Input the number of Menu list (0 for exit) : " inputNo

        cat $HOOAMI_HOME/script/param.cfg | while read Line; do
            chk=`echo ${Line} | awk -F\| '{print $1}'`
            if [ -z $inputNo ]; then
                echo "Input Param please..."
                echo ""
        	break;
            fi
            if [ $inputNo == $chk ]; then
                param=`echo ${Line} | awk -F\| '{print $2}'`
		echo ""
        	echo "===== Call with param... ==> $param"
		echo ""
                ${HOOAMI_HOME}/script/m19.sh $param
		echo ""
        	echo "===== End call...... ====="
		echo ""
            fi
        done;

	if [ "$inputNo" = "0" ]; then
	    break;
	fi
done;

exit 0

