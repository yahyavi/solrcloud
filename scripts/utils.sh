#!/bin/bash

RED='\e[1;31m'
NC='\e[0m' # No Color
YEL='\e[1;33m'

die () {
    echo >&2 "$@"
    exit 1
}

killzookeepers(){
	ps aux | grep "java -Dzoo" | awk '{print $2}' | xargs kill
	echo "Existing zookeeper services KILLED on "`uname -n`;
}

killsolrnodes(){
	ps aux | grep "java -jar start.jar" | awk '{print $2}' | xargs kill
	ps aux | grep "java -Djetty" | awk '{print $2}' | xargs kill
	echo "Existing solrnode services KILLED on "`uname -n`;
}

killservices(){
	killzookeepers
	sleep 0.5
	killsolrnodes
}

if [[ -z "$configed" ]]; then
	die -e "${RED} Make sure config.sh is included before utils.sh (source config.sh)${NC}"
fi

if [ "$configed" -ne 1 ]; then
	die -e "${RED}Edit config.sh file first to reflect your setup. After you are done, change the configed value to 1. ${NC}"
fi
