#########################################
#       GNU GPL License v3              #
#       Author: Amir Yahyavi            #
#########################################

#!/bin/bash
source config.sh
source utils.sh

cd $data_path

[ "$#" -ge 2 ] || die "give the filename and split number"


# Configuration stuff

fspec=$1
num_files=$2

# Work out lines per file.

total_lines=$(cat ${fspec} | wc -l)
((lines_per_file = (total_lines + num_files - 1) / num_files))

# Split the actual file, maintaining lines.

split --lines=${lines_per_file} ${fspec} splitsolrn.

# Debug information

echo "Total lines     = ${total_lines}"
echo "Lines  per file = ${lines_per_file}"    
wc -l splitsolrn.*

i=0;
for file in splitsolrn.*;
  do

    filename=${file%.*}
    echo $filename 
    name=solrn"$i".xml
    echo $name
#    number=`cat -n $file | grep "</doc>" | tail -1 |  cut -f 1 | sed 's/ //g'`
#    echo $number
#    head -n $number $file > $name
     mv $file $name
     i=$((i+1));
  done

