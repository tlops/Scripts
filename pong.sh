#!/bin/bash
# I use this script to check if a host is up while I am
# rebooting the machine. It is a simple ping and returns
# OK when the machine is up. It pings every minute till
# the machine is up.
# you can use it eith option "-s" to ssh into the host
# once it is up

argse="$1"
login="$2"

# Color code           
green='\033[0;32m'     
NC='\033[0m' # No colo 
red='\033[0;31m'       
yellow='\033[0;33m'    

pong (){
	ping -c 1 $argse 2>&1 > /dev/null
}

processing (){
	failedcount=0
	
	while [ $failedcount -lt 100 ]; do
		pong
		if [ $? -ne 0 ]; then
			# loop counter
			((failedcount++))
			echo -e "${red}CRITICAL:${NC} The host ${yellow}$argse${NC} is ${red}down!${NC} $failedcount attempt."
			sleep 60

		else
			echo -e "${green}OK:${NC} the host ${yellow}$argse${NC} is ${green}UP!${NC}"
			# increase the counter to break the loop
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

