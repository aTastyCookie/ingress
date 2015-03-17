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
echo "{\"params\":[\"$1\"]}" > payload

./bin/postapiUndecorated.sh redeemReward
./bin/responseparser.pl response/redeemReward
