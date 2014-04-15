#########################################
#       GNU GPL License v3              #
#       Author: Amir Yahyavi            #
#########################################

#!/bin/bash
source config.sh
source utils.sh

cat $1 | sed 's/<add overwrite=\"true\">//g' | sed 's/<\/add>//g' | sed 's/\ &\ //g' > $2

echo '<add overwrite="true">' | cat - $2 > temp 
echo '</add>' >> temp 

iconv -f utf-8 -t utf-8 -c temp > temp2
# iconv -c -f utf8 -t ascii temp > temp2
tr -cd '\11\12\15\40-\176' < temp2 > $2
dos2unix $2

# cat temp2 | tr -d '[:cntrl:]' | tr -c -d '[:print:]' > $2
 
# rm temp temp2
