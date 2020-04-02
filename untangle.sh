#!/usr/bin/env bash


function eject_explicit {
	echo eject_explicit
}

function eject_code {

	#parse the input file
	IFS=' :'; read -ra FILE <<< "$1:"
   
	IFS=' '
	while read -r file <<< "$1 "; do
		#case $file in
			#'1') echo 1; ;;
		#esac
	done

	file=${FILE[1]}
	startdelim=${FILE[2]}
	enddelim=${FILE[3]}
	tmp=$(mktemp)

	#read the actual file and substitute the code section
	insection=0
	whitespace=''
	#echo "moving code to $file" 1>&2
	while IFS= read line; do
		if [[ $insection == 0 && "$line" =~ "$startdelim" ]]; then
			insection=1
			#get the whitespace of this line
			[[ "$line" =~ ^[[:space:]]* ]]
			whitespace=$BASH_REMATCH
			echo $line >> $tmp
			while read line; do echo "$whitespace$line" >> $tmp; done < $2
		elif [[ $insection == 1 && "$line" =~ "$enddelim" ]]; then
			insection=0
			echo $line >> $tmp
		elif [[ $insection == 0 ]]; then
			echo $line >> $tmp
			#echo ${line#$whitespace}
		fi
	done < $file

	#cat $tmp
	cp $tmp $file
}

incode=0

buffer=''
fileline=''
while IFS= read line; do

	if [[ "${line}" =~ ^\`\`\` && $incode == 0 ]]; then
		incode=1
		echo ${line}
		buffer=$(mktemp)
		fileline="$line"
	elif [[ "${line}" =~ ^\`\`\` && $incode == 1 ]]; then
		incode=0
		echo $line
		eject_code "$fileline" $buffer
		IFS=
		rm $buffer
	elif [[ $incode == 1 ]]; then
		echo $line >> $buffer
	else
		echo $line
	fi

done 
