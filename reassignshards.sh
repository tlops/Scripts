#/bin/bash
# The elasticnode variable contains a list of the nodes the the ES Cluster. The aim
# is to help distribute the UNASSIGNED shards evenly on the nodes. It is controlled
# by the counter that moves across the nodes in the list.
elasticnodes=( node1 node2 node3) 

# The counter set the indices of the elasticnodes array.
count=0
responses="/tmp/es"
# This runs without first checking the UNASSIGNED shards. it execute all on the go
# curl -s localhost:9200/_cat/shards | grep UNASS | while read line ; do \

# UNCOMMENT the line above if you want to run without checking for the reasons.
# COMMENT OUT the line that starts with "cat" 
# The command "curl -s localhost:9200/_cat/shards | grep UNASS" has been run man-
# ually and the result piped to the "unassigned.txt" file. You can comment out this line &
# curl -XGET localhost:9200/_cat/shards?h=index,shard,prirep,state,unassigned.reason| grep UNASSIGNED > unassigned.txt
cat unassigned.txt | while read line ; do \
  read -a fields <<<"$line" ;
     echo $count
     esnode=${elasticnodes[$count]}
curl -XPOST "localhost:9200/_cluster/reroute" -H 'Content-Type: application/json' -d '
{
    "commands" : [
        {
          "allocate_replica" : {
                "index" : "'${fields[0]}'", "shard" : '${fields[1]}',
                "node" : "'$esnode'"
          }
        }
    ]
}
' >$responses


((count++))
echo "${fields[0]} : ${fields[1]} : $esnode"
sleep 5

if [[ $count -eq 3 ]]; then
	count=0
fi

# This part is used for retrying the post in case it falls on a node that already has a copy.
# It retries ones to another node.


errorcatch="$(cat $responses | awk -F '"' '{print $2}')"
if [[ $errorcatch == 'error' ]]; then
	echo "${fields[0]} : ${fields[1]} : failed on node: $esnode"
	esnode=${elasticnodes[$count]}
	echo "FAILED: Trying again on new node: $esnode"
	curl -XPOST "localhost:9200/_cluster/reroute" -H 'Content-Type: application/json' -d '
{
    "commands" : [
        {
          "allocate_replica" : {
                "index" : "'${fields[0]}'", "shard" : '${fields[1]}',
                "node" : "'$esnode'"
          }
        }
    ]
}
'
sleep 5
elif [[ $errorcatch == 'acknowledged' ]]; then
	echo "SUCCESS: index ${fields[0]} with shard ${fields[1]} placed on node $esnode"

else
        echo "UNKNOWN ERROR: ${fields[0]} : ${fields[1]} : $esnode"
        exit 1
fi
done
