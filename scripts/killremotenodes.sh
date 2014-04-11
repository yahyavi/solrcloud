#!/bin/bash
source config.sh
source utils.sh

killnodes(){
for i in $(seq 0 $(($node_num-1)));
do
	echo
	echo ".................................................."

	 ssh -l $username -o StrictHostKeyChecking=no ${hosts[$i]} "
 		cd $scripts_path
 		source config.sh
		source utils.sh
 		killsolrnodes
		"


	i=$((i+1))	
	sleep 0.3
echo "Killed Solr node $((i-1))"
done
}

killzks(){
for i in $(seq 1 $(($zk_num)));
do
	echo
	echo ".................................................."

	k=$((i-1))

	 ssh -l $username -o StrictHostKeyChecking=no ${zookeepers[$k]} "
 		cd $scripts_path
 		source config.sh
		source utils.sh
 		killzookeepers
		"


	i=$((i+1))	
	sleep 0.3
echo "Killed zk node $((i-1))"
done
}


if [[ ! "${BASH_SOURCE[0]}" != "${0}" ]]; then
	killnodes
	killzks
else
	 echo "script ${BASH_SOURCE[0]} is being sourced ..."
fi