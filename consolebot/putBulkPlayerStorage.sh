#!/bin/bash
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}

now=`date +%s`
now1000=$(($now*1000))

if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  exit 1
fi
echo "{\"params\":[{\"game_intro_has_played\":\"true:delim:$now1000:delim:true\"}]}" > payload

./bin/postapiUndecorated.sh putBulkPlayerStorage

sleep 5
now=`date +%s`
now1000=$(($now*1000))

echo "{\"params\":[{\"mission_complete_7\":\"ENDED_BY_PLAYER:delim:$now1000:delim:true\",\"mission_complete_6\":\"ENDED_BY_PLAYER:delim:$now1000:delim:true\",\"mission_complete_5\":\"ENDED_BY_PLAYER:delim:$now1000:delim:true\",\"mission_complete_4\":\"ENDED_BY_PLAYER:delim:$now1000:delim:true\",\"mission_complete_3\":\"ENDED_BY_PLAYER:delim:$now1000:delim:true\",\"mission_complete_0\":\"ENDED_BY_PLAYER:delim:$now1000:delim:true\",\"mission_complete_1\":\"ENDED_BY_PLAYER:delim:$now1000:delim:true\",\"mission_complete_2\":\"ENDED_BY_PLAYER:delim:$now1000:delim:true\"}]}" > payload
./bin/postapiUndecorated.sh putBulkPlayerStorage

