#!/usr/bin/env bash

function inject_code {
	echo "$1" 

	#parse the input file
	IFS=' :'
	read -ra FILE <<< "$1:"
	file=${FILE[1]}
	startdelim=${FILE[2]}
	enddelim=${FILE[3]}

	#read the actual file and substitute the code section
	insection=0
	whitespace=''
	while IFS= read line; do
		if [[ $insection == 0 && "$line" =~ "$startdelim" ]]; then
			insection=1
			#get the whitespace of this line
			[[ "$line" =~ ^[[:space:]]* ]]
			whitespace=$BASH_REMATCH
		elif [[ $insection == 1 && "$line" =~ "$enddelim" ]]; then
			insection=0
		elif [[ $insection == 1 ]]; then
			echo ${line#$whitespace}
		fi
	done < $file
}

incode=0

while IFS= read line; do
	#[[ "${line}" =~ ^[[:whitespace:]]+fnmdjsk$ ]] && echo "match: $line"
	#[[ "${line}" =~ "?[[:alnum:]]+" ]] && echo "match2: $line"
	if [[ "${line}" =~ '```' && $incode == 0 ]]; then
		incode=1
		#echo $line
		inject_code "$line"
	elif [[ "${line}" =~ '```' && $incode == 1 ]]; then
		incode=0
		echo $line
	else
		echo $line
	fi
	#echo $line
done 
