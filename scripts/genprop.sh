#########################################
#       GNU GPL License v3              #
#       Author: Amir Yahyavi            #
#########################################

#!/bin/bash
source config.sh
source utils.sh

set -o xtrace
source config.sh &> config.properties
set +o xtrace

tail -n +2 config.properties > temp.txt; mv temp.txt config.properties

cat config.properties  | sed s/+//g | sed -e 's/^[ \t]*//' > temp.txt ; mv temp.txt config.properties
head -n -1 config.properties > temp.txt ; mv temp.txt config.properties
echo "datafiles=(${datafiles[@]})" >> config.properties


cat config.properties
mv config.properties $solrj_path