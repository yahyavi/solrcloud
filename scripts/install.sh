#########################################
#       GNU GPL License v3              #
#       Author: Amir Yahyavi            #
#########################################

#!/bin/bash
source config.sh
source utils.sh

echo "This will download and extract solr and zookeeper. To the parent folder of this folder. "
echo "MAKE SURE config.sh is setup correctly, and you root_path is correct (containing the: scripts, solr, configs, data, zookeeper folders). schema.xml, and solrconfig.xml files need to be in the config folder. data files need to follow the config.sh name format and be in the data folder."

read -p "Continue? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

cd ..

[ -f solr-4.7.2.tgz ] || wget -c "http://apache.mirrors.pair.com/lucene/solr/4.7.2/solr-4.7.2.tgz"
[ -f zookeeper-3.4.6.tar.gz ] || wget -c "http://www.bizdirusa.com/mirrors/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz"

[ -d solr-4.7.2 ] || tar -zxvf solr-4.7.0.tgz
[ -d zookeeper-3.4.6 ] || tar -zxvf zookeeper-3.4.6.tar.gz

echo
echo "Now you can use deploynodes, or newnode to start new instances. "
