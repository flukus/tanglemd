#!/usr/bin/env bash

function inject_explicit {

	#parse the input file
	IFS=':'
	read -ra FILE <<< "$1"
	file=${FILE[0]}
	startdelim=${FILE[1]}
	enddelim=${FILE[2]}

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

function inject_code {
	echo "$1" 

	IFS=' '; read -ra outfiles <<< "$1"
	master=0
	for outfile in ${outfiles[@]}
	do
		if [[ "$outfile" =~ ^\`\`\` ]]; then
			continue #ignore start tags
		elif [[ "$outfile" =~ '!' ]]; then
			master=1
			#cat $2 #if this is the master append the output
		elif [[ "$outfile" =~ .*\:.*:.* && $master == 0 ]]; then
			inject_explicit "$outfile"
		fi
	done

}

incode=0

while IFS= read line; do
	if [[ "${line}" =~ ^\`\`\`\[a-zA-Z\]*\[\[:space:\]\]\*\! && $incode == 0 ]]; then
		#this is the code master, inject lines directly
		echo $line
	elif [[ "${line}" =~ '```' && $incode == 0 ]]; then
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
