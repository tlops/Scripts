#!/bin/bash
# I use this script to check if a host is up while I am
# rebooting the machine. It is a simple ping and returns
# OK when the machine is up. It pings every minute till
# the machine is up.
# you can use it eith option "-s" to ssh into the host
# once it is up

argse="$1"
login="$2"

pong (){
	ping -c 1 $argse 2>&1 > /dev/null
}

processing (){
	failedcount=0
	
	while [ $failedcount -lt 100 ]; do
		pong
		if [ $? -ne 0 ]; then
			((failedcount++))
			echo "CRITICAL: The host $argse is down. $failedcount attempt."
			sleep 60

		else
			echo "OK: the host $argse is UP!"
			failedcount=$(($failedcount+100))
		fi

	done
}



if [ $# -eq 1 ]; then
	processing
	exit 0
elif [ $# -eq 2 ] && [ $login == "-s" ]; then
	processing	
	ssh $argse
else
	echo "you need an argument to run this command"
        echo "Usage: $0 <hostname> or <IP-address>"
        echo "Usage: $0 <hostname> or <IP-address> -s"
fi

