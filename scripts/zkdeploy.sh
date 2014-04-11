#!/bin/bash
source config.sh
source utils.sh

deployzknodes(){
for i in $(seq 1 $(($zk_num)));
do
	echo
	echo ".................................................."

	k=$((i-1))

	 ssh -l $username -o StrictHostKeyChecking=no ${zookeepers[$k]} "
	 	cd $scripts_path
	 	source newzk.sh
	 	killzookeepers
	 	newzknode $i
		"

	i=$((i+1))	
	sleep 0.3
echo "DEPLOYED"
done
}


startzknodes(){
for i in $(seq 1 $(($zk_num)));
do
	echo
	echo ".................................................."

	k=$((i-1))
# This doesn't kill them. TODO!
	 ssh -l $username -o StrictHostKeyChecking=no ${zookeepers[$k]} "
	 	cd $scripts_path
	 	source newzk.sh
	 	startzknode $i
		"
		
	i=$((i+1))	
	sleep 0.3
# echo "Started"
done
}


if [[ ! "${BASH_SOURCE[0]}" != "${0}" ]]; then
	deployzknodes
	startzknodes
else
	 echo "script ${BASH_SOURCE[0]} is being sourced ..."
fi
