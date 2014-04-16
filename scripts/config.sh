#########################################
#       GNU GPL License v3              #
#       Author: Amir Yahyavi            #
#########################################

#!/bin/bash

if [[ -z "$root_path" ]]; then
	root_path="$HOME/solrcloud"
fi


configed=1
jettyport=8983 #default=8983
node_num=2
shard_num=2
zk_standalone=1

username="amir"
# zookeeper="localhost" easier to have the first one become the zookeeper
solr_path="$root_path/solr-4.7.2"
solrj_path="$root_path/solrj"
config_path="$root_path/configs"
data_path="$root_path/data"
scripts_path="$root_path/scripts"
config_name="amirsolrconfig"
originaldata_format="$data_path/solrn"
dataname_format="$data_path/solrn"
samplequery_file="$data_path/q.txt"
# dataname_format="$data_path/U-solrn"
sleep_time=25

#if zk_standalone!=1 use this port
localzookeeperport=9983

#if zk_standalone==1 this config and  the zkdeploy is used
zk_home="$root_path/zookeeper-3.4.6"
zk_data="$root_path/zk/data"
zk_num=3
# reduced by 1 since they are added in the for
zk_baseclientport=2180
zk_baseport=2887
num_query_threads=2

zookeepers=(  "localhost" "localhost" "localhost")

hosts=("localhost" "localhost" "localhost" "localhost" "localhost" "localhost" "localhost" "localhost" "localhost" "localhost" "localhost" "localhost")
#For 2 nodes, eqaully split between nodes
datafiles=("$dataname_format"0.xml" $dataname_format"1.xml" $dataname_format"2.xml" $dataname_format"3.xml" $dataname_format"4.xml" $dataname_format"5.xml"" "$dataname_format"6.xml" $dataname_format"7.xml" $dataname_format"8.xml" $dataname_format"9.xml" $dataname_format"10.xml" $dataname_format"11.xml"")

# For up to 12 nodes
# datafiles=("$dataname_format""0.xml" "$dataname_format""1.xml" "$dataname_format""2.xml" "$dataname_format""3.xml" "$dataname_format""4.xml" "$dataname_format""5.xml" "$dataname_format""6.xml" "$dataname_format""7.xml" "$dataname_format""8.xml" "$dataname_format""9.xml" "$dataname_format""10.xml" "$dataname_format""11.xml" )
