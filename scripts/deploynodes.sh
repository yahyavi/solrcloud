#!/bin/bash
source config.sh
source utils.sh


# [ "$#" -ge 2 ] || die -e "Give the ${RED} number of nodes${NC}, and ${RED}number of shards${NC}."
prompt(){
	[ $# -ge 4 ] && die -e "Too many parameters. Provide #nodes, #shards, (usezookeepers?1=yes)"
	[ $# -ge 1 ] && echo -e "${YEL}It's better to change the parameters in config.sh, otherwise genprop.sh won't generate the right property files for your SolrJ applications. This is only for quick testing of the script. ${NC}"

	echo 
	echo "==============================================================================="
	echo
	node_num=${1:-$node_num}
	shard_num=${2:-$shard_num}
	zk_standalone=${3:-$zk_standalone}
	echo -e "Solr Path: ${RED} $solr_path"${NC}
	echo -e "Number of nodes: ${RED} $node_num"${NC}
	echo -e "Number of shards: ${RED} $shard_num"${NC}
	echo -e "Standalone zookeepers?(yes=1): ${RED} $zk_standalone"${NC}
	echo
	echo -e "Make sure config.sh reflects your setup. ${YEL}This script will remove any existing nodes named: node*. ${NC}This script will try to start with having ${RED}$node_num ${NC}nodes, and ${RED}$shard_num ${NC}shards. They are named ${RED} node0-...-node$(($node_num-1)) ${NC}in solr path: ${RED}$solr_path${NC}, with ${RED}$dataname_format#.xml ${NC}data files inside the ${RED}$data_path ${NC}folder. This script also assumes that you have the same setup on every machines listed in hosts parameter. Whether there are standalone zookeepers should be configured in the config.sh file. Make sure you setup your private/public key on the servers, otherwise you end up inputing your password a lot!"

	# if [[ $# -eq 3 ]]
	# then
	#     zk_standalone=$3
	#     echo -e "Use standalone zookeepers?=${YEL}$3${NC}"
	# fi
	echo
	echo "==============================================================================="
	echo


	read -p "Continue? (y/n)" -n 1 -r
	echo    # (optional) move to a new line
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
	    exit 1
	fi
}




buildzkcmd(){
	zookeeper_address="localhost:$localzookeeperport"
	zk_cmd="-DzkRun"

	if [ "$zk_standalone" -eq 1 ]; then
		./zkdeploy.sh
		echo
		echo "Sleep to allow for Quorom to be setup"
		sleep $sleep_time
		zookeeper_address=${zookeepers[0]}:$(($zk_baseclientport+1))
		
		for i in $(seq 2 $zk_number);
			do
				zookeeper_address=$zookeeper_address,${zookeepers[$j]}:$(($zk_baseclientport+$i))
			done
		zk_cmd="-DzkHost="$zookeeper_address
		echo $zk_cmd
	fi
}

deploynodes(){

	buildzkcmd

	cd $solr_path
	i=0
	# for host in "${hosts[@]}";
	for i in $(seq 0 $(($node_num-1)));
	do
		echo
		echo "------------------------------------------------"
	    if [ "$i" -eq 0 ];  
	    	then
	    		# Easier to just copy the conf files right now rather than change the config folder
	    		params="-Djetty.port=$(($jettyport+$i)) $zk_cmd -DnumShards=$shard_num -Dbootstrap_confdir=./solr/collection1/conf -Dcollection.configName=$config_name"
	    		
	    		# echo $params
	    		if [[ ! "$zk_standalone" -eq 1 ]]; then
		  				echo ${hosts[$i]} "is the zookeeper."
		  			else
		  				echo ${hosts[$i]} "is a normal node."
		  		fi
		  		# echo ${datafiles[$i]}

		  		ssh -l $username -o StrictHostKeyChecking=no ${hosts[$i]} "cd $scripts_path; ./newnode.sh $i $params; echo Sleep to allow time for bootup; sleep $sleep_time; exit 1;"  

		  		# echo $i
			else
	    		params="-Djetty.port="$(($jettyport+$i))" -DzkHost=$zookeeper_address"
		  		echo ${hosts[$i]} "is a normal node"
		  		# echo ${datafiles[$i]}

		  		ssh -l $username -o StrictHostKeyChecking=no ${hosts[$i]} "cd $scripts_path; ./newnode.sh $i $params; echo Sleep to allow time for bootup; sleep $sleep_time; exit 1;" 
		fi

		i=$((i+1))	
		sleep 0.3
	    # This is necessary since some machines (or ISPs?) (mine at home) do not like when many connections
	    # are spawned in a short time interval (i've heard something about 'n' new max connections per
	    # second). Without this some connections are not properly established...
	    # sleep 0.3

	done
	echo
	echo
}

startnodes(){

	buildzkcmd

	cd $solr_path
	i=0
	# for host in "${hosts[@]}";
	for i in $(seq 0 $(($node_num-1)));
	do
		echo
		echo "------------------------------------------------"
	    if [ "$i" -eq 0 ];  
	    	then
	    		# Easier to just copy the conf files right now rather than change the config folder
	    		params="-Djetty.port=$(($jettyport+$i)) $zk_cmd -DnumShards=$shard_num -Dbootstrap_confdir=./solr/collection1/conf -Dcollection.configName=$config_name"
	    		
	    		# echo $params
	    		if [[ ! "$zk_standalone" -eq 1 ]]; then
		  				echo ${hosts[$i]} "is the zookeeper."
		  			else
		  				echo ${hosts[$i]} "is a normal node."
		  		fi
		  		# echo ${datafiles[$i]}

		  		ssh -l $username -o StrictHostKeyChecking=no ${hosts[$i]} "cd $scripts_path; source newnode.sh; startnode $i $params; echo Sleep to allow time for bootup; sleep $sleep_time; exit 1;"  

		  		# echo $i
			else
	    		params="-Djetty.port="$(($jettyport+$i))" -DzkHost=$zookeeper_address"
		  		echo ${hosts[$i]} "is a normal node"
		  		# echo ${datafiles[$i]}
		  		ssh -l $username -o StrictHostKeyChecking=no ${hosts[$i]} "cd $scripts_path; source newnode.sh; startnode $i $params; echo Sleep to allow time for bootup; sleep $sleep_time; exit 1;" 
		fi

		i=$((i+1))	
		sleep 0.3
	    # This is necessary since some machines (or ISPs?) (mine at home) do not like when many connections
	    # are spawned in a short time interval (i've heard something about 'n' new max connections per
	    # second). Without this some connections are not properly established...
	    # sleep 0.3

	done
	echo
	echo
}



indexnodes(){

	echo "INDEXING data."
	# TODO: This should be max of node_num, and datafile array size.
	for i in $(seq 0 $(($node_num-1)));
	do
		echo
		echo ".................................................."
		echo ${datafiles[$i]}

		#Using curl. This might be slower but I'm not sure.
		# ssh -l $username -o StrictHostKeyChecking=no ${hosts[$i]} "curl http://localhost:$(($jettyport+$i))/solr/update?commit=true -H \"Content-Type: text/xml\" -d \"@${datafiles[$i]}\";" 

		 ssh -l $username -o StrictHostKeyChecking=no ${hosts[$i]} "java -Durl=http://localhost:$(($jettyport+$i))/solr/update  -Dtype=text/xml -jar $solr_path/node$i/exampledocs/post.jar ${datafiles[$i]}; exit"
		i=$((i+1))	
		sleep 0.3

	done

		# ./index.sh $i ${datafiles[$i]}
		# java -Durl=http://localhost:8983/solr/update/extract -Dparams=literal.id=a -Dtype=application/pdf -jar post.jar a.pdf 
}


if [[ ! "${BASH_SOURCE[0]}" != "${0}" ]]; then
	
	prompt "$@"
	./rmremotenodes.sh
	deploynodes

	read -p "Index the default data in config file? (y/n)" -n 1 -r
	echo    # (optional) move to a new line
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
    	exit 1
	fi
	indexnodes

else
	 echo "script ${BASH_SOURCE[0]} is being sourced ..."
fi