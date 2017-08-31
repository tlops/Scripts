#!/bin/bash
array=(192.168.2.162 192.168.2.164 192.168.2.165 192.168.2.100 192.168.2.115)

for i in ${array[@]}; do
	echo $i
	ping -c1 $i
	nslookup $i
	echo ""
	echo ""
	sleep 3
done
