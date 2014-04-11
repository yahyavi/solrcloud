#!/bin/bash
source config.sh
source utils.sh



newnode(){
[ "$#" -ge 1 ] || die "Give the node number"
echo "Creating a new node: node"$1 
echo "solr path is $solr_path"
pwd
cp -r $solr_path/example $solr_path/node$1
cp $config_path/schema.xml $solr_path/node$1/solr/collection1/conf
cp $config_path/solrconfig.xml $solr_path/node$1/solr/collection1/conf
# cp $data_path/"$dataname_format""$1".xml $solr_path/node$1/exampledocs

echo "DONE deploying new node: node"$1
}

startnode(){
[ "$#" -ge 1 ] || die "Give the node number"

echo "Starting Simple Solr, with params(not mandatory): "
echo "${@:2}"
cd $solr_path/node$1/
java  "${@:2}" -jar start.jar  &> $solr_path/node$1/node$1.log &
echo "Started simple solr (check the log if you want to make sure an exception didn't occur)"
}


# 	 -Djetty.port=8983 -DzkRun -DnumShards=1 -Dbootstrap_confdir=$configs_path -Dcollection.configName=solrconfig
# It's easier to copy config files instead of changing the config dir.

if [[ ! "${BASH_SOURCE[0]}" != "${0}" ]]; then
	[ "$#" -ge 1 ] || die "Give the node number"
	newnode $1
	startnode "$@"
else
	 echo "script ${BASH_SOURCE[0]} is being sourced ..."
fi