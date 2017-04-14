#!/bin/bash
#while [[ $# -gt 1 ]]; do
#
argse="$1"
pong (){
	ping -c 1 $argse 2>&1 > /dev/null
}

if [ $# -eq 1 ]; then
	
	while true; do
		pong
		if [ $? -ne 0 ]; then
			echo "CRITICAL: The host $argse is down"
			sleep 30

		else
			echo "OK: the host $argse is UP!"
			exit 0
		fi
	done

else 
	echo "you need an argument to run this command"
	echo "Usage: $0 <hostname> or <IP-address>"
fi
