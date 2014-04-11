#!/bin/bash
source config.sh
source utils.sh


[ "$#" -ge 2 ] || die "give node #, and file name in DATA_PATH"

# echo "Copying Docs: "$data_path/$2
# cp $data_path/$2 $solr_path/node$1/exampledocs
# echo "Done copying Docs: "$data_path/$2


echo "Indexing Docs: "$2
java -jar $solr_path/node$1/exampledocs/post.jar $data_path/$2
echo "DONE indexing Docs: "$2

