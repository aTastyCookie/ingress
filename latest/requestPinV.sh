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
NUMBER=$1
echo "{\"params\":[{\"mode\":\"VOICE\",\"locale\":\"ru_RU\",\"phoneNumber\":\"$NUMBER\"}]}" > payload

./bin/postapiUndecorated.sh requestPin
./bin/responseparser.pl response/requestPin
