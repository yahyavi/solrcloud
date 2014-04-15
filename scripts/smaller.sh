#########################################
#       GNU GPL License v3              #
#       Author: Amir Yahyavi            #
#########################################

#!/bin/bash
source config.sh
source utils.sh

echo $originaldata_format

cd $data_path

nlines=10000

for file in $originaldata_format*.xml; 
  do
    filename=${file%.*}
    echo $filename 
    name=T-"$filename".xml
    #echo $name
    head -n $nlines $file > $name
    number=`cat -n $name | grep "</doc>" | tail -1 |  cut -f 1 | sed 's/ //g'`
    echo $number
    head -n $number $name > U-"$filename".xml
    echo "</add>" >> U-"$filename".xml
    echo U-"$filename".xml
    rm $name
  done
