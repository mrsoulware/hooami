#!/bin/bash

leafcall() {
	local url
	local depth
	local key
	local line

	url="$1"
	key="$3"

 	echo -n "$key ="
	line=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" $url)
	echo " $line"
}

recurcall() {
	local line
	local i
	local index
	local lastch
	local url
	local nexturl
	local depth
	local nextdepth

	url=$1
	depth=$2
	nextdepth=$(expr $depth + 1)

	curl -s -H "X-aws-ec2-metadata-token: $TOKEN" $url |
	while read line || [[ -n "$line" ]]
	do
		i=0
		while [ "$i" -lt "$2" ]
		do
  			echo -n "####"
			((i++))
		done
		echo -n " "

		index=$((${#line}-1))
		lastch=${line:$index:1}
		if [ "$lastch" = "/" ]; then
			echo "$line"
			nexturl="$url/${line::-1}"
			recurcall "$nexturl" "$nextdepth"
		else
			nexturl="$url/${line}"
			leafcall "$nexturl" "$nextdepth" "$line"
		fi
	done
}

baseurl="http://169.254.169.254/latest/meta-data"

recurcall "$baseurl" "1"

exit 0

