#!/usr/bin/env bash

function inject_function {
	tmp=$(mktemp)

	#get the file and create the regex to find the declaration
	IFS=':'; read -ra FILE <<< "$1"
	file=${FILE[0]}
	pattern=${FILE[1]}
	IFS='(), '; read -ra patternParts <<< "$pattern"
	patternRegex="${patternParts[0]}.*(.*"
	for part in ${patternParts[@]:1}; do
		patternRegex="$patternRegex$part.*"
	done
	patternRegex="$patternRegex)"

	insection=0
	whitespace=''
	declare -i openBraceCount closeBraceCount inBrace
	while IFS= read line; do
		if [[ $insection == 0 && "$line" =~ $patternRegex && ! "$line" =~ \;$ ]]; then
			insection=1
			[[ "$line" =~ ^[[:space:]]* ]]
			whitespace=$BASH_REMATCH
		fi

		if [[ $insection = 1 ]]; then
			echo "${line#$whitespace}"

			openBraces=${line//[^\{]}
			closeBraces=${line//[^\}]}
			openBraceCount=$((openBraceCount + ${#openBraces}))
			closeBraceCount=$((closeBraceCount + ${#closeBraces}))
			inBrace=$((inBrace + openBraceCount))
			braceDiff=$((openBraceCount - closeBraceCount))

			if (( inBrace != 0 && braceDiff <= 0 )); then
				insection=0
				inBrace=0
				openBraceCount=0
				closeBraceCount=0
			fi

		fi
	done < $file
}

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
		elif [[ "$outfile" =~ .*:.*\(.*\) ]]; then
			inject_function "$outfile"
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
