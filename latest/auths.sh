#!/bin/bash
. bin/func.inc
MOD=`stat -c %Y authtoken.txt`
CURRENT=`date +%s`
let DIFF=$CURRENT-$MOD
if [ "$DIFF" -ge "75000" ]; then
  bin/auth.sh
else 
  echo "it seems you should not auth yet" > /dev/null
fi
