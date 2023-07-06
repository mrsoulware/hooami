#!/bin/bash

leafcall() {
	local url
	local depth
	local key
	local line

	url="$1"
	key="$3"

 	echo -n "$key ="
	line=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" $url | head -1)
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
	local output
	local linecnt
	local lineno

	url=$1
	depth=$2
	nextdepth=$(expr $depth + 1)

	
	output=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" $url)
	linecnt=$(echo "$output" | wc -l)
	lineno=0

	echo "$output" |
	while read -r line || [[ -n "$line" ]]
	do
		((lineno++))
		i=1
		while [ "$i" -lt "$2" ]
		do
			if [ ${lastnode[${i}]} = "T" ]; then
  				echo -n "    "
			else
  				echo -n "│   "
			fi
			((i++))
		done
		if [ "$lineno" == "$linecnt" ]; then
			echo -n "└── "
			lastnode[${depth}]="T"
		else
			echo -n "├── "
			lastnode[${depth}]="F"
		fi

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

echo "meta-data"
recurcall "$baseurl" "1"

exit 0

