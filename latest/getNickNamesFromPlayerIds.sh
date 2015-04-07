#!/bin/bash
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}

guid=$1
[ "$#" -eq 1 ] || die "1 arguments required, $# provided, synopsys: $0 guid"
useragent="Nemesis (gzip)"
cookie=`cat cookie.txt|tr -d "\r\n"`
token=`cat csrftoken.txt|tr -d "\r\n"`
knobsyncts=`cat knobsyncts.txt|tr -d "\r\n"`
if [[ "$knobsyncts" =~ ^[0-9]{13}$ ]]; then
  echo "knobsyncts ok" > /dev/null
else
  echo "bad knobsyncts"
  touch error.lock
  exit 1
fi
now=`date +%s`
now1000=$(($now*1000))
deltatime=`expr $now1000 - $knobsyncts`

if [ "$deltatime" -ge "85000000" ]; then
  echo "your knbobsyncts is too old, i will not continue"
  touch error.lock
  exit 1
fi


if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  exit 1
fi
echo "{\"params\":[[\"$guid\"]]}" > payload
./bin/postapiUndecorated.sh getNickNamesFromPlayerIds

