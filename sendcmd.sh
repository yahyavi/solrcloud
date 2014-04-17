#!/bin/bash

hosts=("host1" "host2" "...")

for host in "${hosts[@]}";
do
	echo
	echo ".................................................."
	echo "Start  $host"

	 ssh -o StrictHostKeyChecking=no user@$host "$@"


	i=$((i+1))	
	sleep 0.3
echo "Done with $host"
done
