#!/bin/bash
# USAGE: ./newamedia.sh files2delete
#
files2remove="$1"
countDeleted=0 # counst how many files were found and deleted 
countNotFound=0 # files not found
started=`date +%s`  # Start Time keeper 
timest=`date +%Y%m%d-%H%M`  # Timestamp to be added to the log
logfile="amediadeletelog_$timest"  # logfile to be created
IFS=$(echo -en "\n\b")    # important: sets entries to new line

if [ $# -ne 1 ]; then
	echo "You need a parameter, the list of files to delete"
	echo "USAGE: $0 <files>"
	exit 1
fi


# start
echo "Processing . . ."
files2remove=(`cat $files2remove`)

echo  "${#files2remove[@]} directories to be processed ..." # prints the number of files found in files2remove
for files in "${files2remove[@]}"; do # loops oveer every element in files2remove
	if [ -d "$files" ];then       # if it exists as directory
		((countDeleted++))    # increment the $countDeleted counter
		rm -rf "$files"	      # remove the directory
		echo "`date +%F_%T`: $files" >> $logfile	# Add it to the logfile with timestamp
	#	sleep 3		# wait before the next remove in case, just to keep network/IO calm
	else
		((countNotFound++))		# if directory is missing increment the $countNotFound counter
	fi
done
ended=`date +%s`	# Stop time keeper
exectime=$((($ended-$started)/60)) # calculate time in minutes
echo "Completed: Check $logfile for logs"
echo "Total time taken: $exectime minutes" | tee -a $logfile    	# send to both cmdline and log file
echo "Number of files deleted: $countDeleted" | tee -a $logfile
echo "Number of files NOT Found: $countNotFound" | tee -a $logfile

IFS=$SAVEIFS
