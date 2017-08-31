#!/bin/bash
# Testing "or"
read -r -p "Is this a WowzaHub[h] or WowzaAIP[a]? : " TYPE
if [ "$TYPE" == "h" ] || [ "$TYPE" == "WowzaHub" ] || [ "$TYPE" == "WowzaAIP" ] || [ "$TYPE" == "a" ]; then
echo "correct"
else
echo "wrong"
fi

## testing case
case $TYPE in                                                    
   "WowzaHub" | "h") echo "HUB";;                                   
   "WowzaAIP" | "a") echo "AIP";;                                   
   *) echo "Accepted Entries are :  WowzaHub | h | WowzaAIP | a" 
   esac                                                          
