#!/bin/bash

leafcall() {
	local line
	local i

	i=0
	while [ "$i" -lt "$2" ]
	do
  		echo -n "####"
		((i++))
	done

	line=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" $1)
	echo " $line"
}

recurcall() {
	local line
	local i

	local index
	local lastch
	local url
	local depth=$(expr $2 + 1)

	curl -s -H "X-aws-ec2-metadata-token: $TOKEN" $1 | while read line
	do
		i=0
		while [ "$i" -lt "$2" ]
		do
  			echo -n "####"
			((i++))
		done
		echo " $line"
		index=$((${#line}-1))
		lastch=${line:$index:1}
		if [ "$lastch" = "/" ]; then
			url="$1/${line::-1}"
			recurcall "$url" "$depth"
		else
			url="$1/${line}"
			leafcall "$url" "$depth"
		fi
	done
}


baseurl="http://169.254.169.254/latest/meta-data"
curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data | while read line
do
	echo "## $line"
	index=$((${#line}-1))
	lastch=${line:$index:1}
	if [ "$lastch" = "/" ]; then
		url="$baseurl/${line::-1}"
		recurcall "$url" "1"
	else
		url="$baseurl/${line}"
		leafcall "$url" "1"
	fi
done

exit 0

