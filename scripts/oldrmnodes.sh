#########################################
#       GNU GPL License v3              #
#       Author: Amir Yahyavi            #
#########################################

#!/bin/bash
source config.sh
source utils.sh

echo "You should use rmremotenodes instead. This one is quick and dirty for quick local tests."
read -p "Continue? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# killall -9 java
killservices

cd $solr_path

for folder in node*;
  do
    echo "Backing up xml data files with name "$dataname_format"*.xml in the node, if there are any."
    ls $folder/exampledocs/"$dataname_format"*.xml >/dev/null 2>&1 && mv -i $folder/exampledocs/"$dataname_format"*.xml $data_path
  done

rm -rf node*

echo "DONE"