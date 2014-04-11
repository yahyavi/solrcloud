#!/bin/bash
source config.sh
source utils.sh
initLimit=5
syncLimit=2
base_foldername=""

newzknode(){
	[ "$#" -ge 1 ] || die "Give the zk number"
	cd $zk_data
	rm -rf $base_foldername$1
	mkdir $zk_data/$base_foldername$1 
	echo $1 > $zk_data/$base_foldername$1/myid
	echo dataDir=$zk_data/$1 > $zk_home/conf/zoo$1.cfg
	echo clientPort=$(($zk_baseclientport+$1)) >> $zk_home/conf/zoo$1.cfg
	echo initLimit=$initLimit >> $zk_home/conf/zoo$1.cfg
	echo syncLimit=$syncLimit >> $zk_home/conf/zoo$1.cfg
	for j in $(seq 1 $zk_num);
		do
			echo server.$j=${zookeepers[$((j-1))]}:$(($zk_baseport+$j)):$(($zk_baseport+$j+1000)) >> $zk_home/conf/zoo$1.cfg
		done
}

startzknode(){
	[ "$#" -ge 1 ] || die "Give the zk number"
	cd $zk_home
	pwd
	rm -rf zk$1.log
	bin/zkServer.sh start zoo$1.cfg &> zk$1.log 
	sleep 0.3
	cat zk$1.log
}

if [[ ! "${BASH_SOURCE[0]}" != "${0}" ]]; then

	[ "$#" -ge 1 ] || die "Give the zk number"
	killzookeepers

	newzknode $1
	startzknode $1
else
	 echo "script ${BASH_SOURCE[0]} is being sourced ..."
fi