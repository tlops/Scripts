#!/bin/bash
# 1. Create ProgressBar function
# 1.1 Input is currentState($1) and totalState($2)
# 1.2 Modified from https://github.com/fearside/ProgressBar/blob/master/progressbar.sh

function ProgressBar {
# Process data
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
# Build progressbar string lengths
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

# 1.2 Build progressbar strings and print the ProgressBar line
# 1.2.1 Output example:
# 1.2.1.1 Progress : [########################################] 100%
printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"

}
# I used this to monitor two files (output: list of items to be deleted"
# and (input: list of already deleted items "log").
# input =$(cat someFilledFile | wc -l)
# output =$(cat someGrowingFile | wc -l)
# 
processing (){
	total=`cat output`
	# convert to base 100
	hundred_percent=$((100*$total/$total))
	endLimit=$hundred_percent
	#echo $endLimit

	# This accounts as the "totalState" variable for the ProgressBar function

	# Gives the first digit to start the run, if tesing with codegen.sh
	# you can
	state=1

	while [ $state -lt $endLimit ]; do
		already_done=`cat input`
		percentage_done=$((100*$already_done/$total))
		state=$percentage_done
		
		sleep 5
		ProgressBar $state $endLimit  #call the ProgressBar Function
	done
	printf '\nFinished!\n'
	exit 0
}

processing
#ProgressBar 5 100
