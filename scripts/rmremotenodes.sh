#!/bin/bash
source config.sh
source utils.sh

rmlocalnode(){
	[ "$#" -ge 1 ] || die "Give the node number"

 	cd $scripts_path
 	source config.sh
	source utils.sh
 	killsolrnodes
	cd $solr_path
	pwd
	
	echo \"Backing up node$1 xml data files with name \"$dataname_format\"*.xml in the node, if there are any.\"
	ls node$1/exampledocs/\"$dataname_format\"*.xml >/dev/null 2>&1 && mv -i node$1/exampledocs/\"$dataname_format\"*.xml $data_path

	rm -rf node$1

}

rmnodes(){
for i in $(seq 0 $(($node_num-1)));
do
	echo
	echo ".................................................."

	 ssh -l $username -o StrictHostKeyChecking=no ${hosts[$i]} "
	 	cd $scripts_path
		source rmremotenodes.sh
		rmlocalnode $i
		"


	i=$((i+1))	
	sleep 0.3
echo "Removed Solr node $((i-1))"
done
}



rmlocalzk(){
		[ "$#" -ge 1 ] || die "Give the node number"
	 	cd $scripts_path
	 	source config.sh
		source utils.sh	
	 	killzookeepers
	 	cd $zk_data
		rm -rf $base_foldername$1
		rm -rf $zk_home/conf/zoo$1.cfg
}

rmzks(){
for i in $(seq 1 $(($zk_num)));
do
	echo
	echo ".................................................."

	k=$((i-1))

	 ssh -l $username -o StrictHostKeyChecking=no ${zookeepers[$k]} "
	 	cd $scripts_path
	 	source config.sh
		source utils.sh
		source rmremotenodes.sh
		rmlocalzk $i
		"


	i=$((i+1))	
	sleep 0.3
echo "Removed zk node $((i-1))"
done
}


if [[ ! "${BASH_SOURCE[0]}" != "${0}" ]]; then
	rmnodes
	rmzks
else
	 echo "script ${BASH_SOURCE[0]} is being sourced ..."
fi