#!/bin/bash
. bin/func.inc

if [ ! -d cells ]; then
    mkdir -p cells/
fi

ID=`echo $1 | grep -P "^[0-9a-b][0-9a-f]{3,3}$"`
ID_VALID=`echo $ID | grep -c -P "^[0-9a-b][0-9a-f]{3,3}$"`

if [ "$ID_VALID" != "1" ]; then
    ID_NAME=`echo $1 | grep -o -P "[A-Z]{2}[0-9]{2}-[A-Z]*-[0-9]{2}"`
    ID=`curl -s "http://ingress-cells.appspot.com/query?cell=$ID_NAME" | grep -F '"s2":' | grep -o -P "[0-9a-f]{4}"`
    ID_VALID=`echo $ID | grep -c -P "^[0-9a-b][0-9a-f]{3,3}$"`
    if [ "$ID_VALID" != "1" ]; then
        echo "Scroe region must be 0001-bfff"
        exit;
    fi
fi


if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  exit 1
fi
echo "{\"params\":[{\"cellIdToken\":\"$ID\"}]}" > payload

./bin/postapiUndecorated.sh getRegionScore

NAME=`cat response/getRegionScore | grep -o -P 'regionName":"[^"]*"' | sed 's|regionName"\:"||' | sed 's|"||'`
if [ "$NAME" != "" ]; then
    echo "Cell $NAME downloaded"
    DT=`date "+%Y-%m-%d-%T"`
    cp response/getRegionScore cells/$NAME-$DT.json
fi

cp response/getRegionScore cells/$ID.json
