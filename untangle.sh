#! /usr/bin/env bash


function eject_explicit {
	#parse the input file
	IFS=' :'; read -ra FILE <<< "$1:"
	file=${FILE[0]}
	startdelim=${FILE[1]}
	enddelim=${FILE[2]}
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
			#if this is the master then include code in the output
			whitespace=$BASH_REMATCH
			echo $line >> $tmp
			while read line; do echo "$whitespace$line" >> $tmp; done < $2
		elif [[ $insection == 1 && "$line" =~ "$enddelim" ]]; then
			insection=0
			echo $line >> $tmp
		elif [[ $insection == 0 ]]; then
			echo $line >> $tmp
		fi
	done < $file

	#cat $tmp
	cp $tmp $file
}

function eject_code {

	IFS=' '
	read -ra outfiles <<< "$1"
	for outfile in ${outfiles[@]}
	do
		if [[ "$outfile" =~ '!' ]]; then
			cat $2 #if this is the master append the output
		elif [[ "$outfile" =~ ^\`\`\` ]]; then
			continue
		elif [[ "$outfile" =~ .*\:.*:.* ]]; then
			eject_explicit "$outfile" "$2"
		else
			echo 'error'
		fi
	done
	#echo $1

}

incode=0
buffer=''
fileline=''
while IFS= read inline; do

	if [[ "${inline}" =~ ^\`\`\` && $incode == 0 ]]; then
		incode=1
		echo ${inline}
		buffer=$(mktemp)
		fileline="$inline"
	elif [[ "${inline}" =~ ^\`\`\` && $incode == 1 ]]; then
		incode=0
		eject_code "$fileline" "$buffer"
		echo "${inline}"
		IFS=
		rm $buffer
	elif [[ $incode == 1 ]]; then
		echo $inline >> $buffer
	else
		echo $inline
	fi

done 
