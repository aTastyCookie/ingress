#!/bin/bash
. bin/func.inc
APIREQUEST="getInviteInfo"
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

PROXY=`cat proxy.cfg 2>/dev/null | tr -d "\n" | sed 's|[#;].*||'`
curl $PROXY -k -D curlheaders.txt   -A "$useragent" -X POST \
        -H "Cookie:$cookie" \
        -H "Content-Type:application/json;charset=UTF-8" \
        -H "Accept-Encoding:gzip" \
        -H "X-XsrfToken:$token" \
        --data-binary @bin/getInviteInfo.payload \
        https://m-dot-betaspike.appspot.com/rpc/playerUndecorated/$APIREQUEST 2>/dev/null |gunzip > response/$APIREQUEST
RESPONSECODE=`cat curlheaders.txt |head -n 1|awk '{print $2}'`
echo $RESPONSECODE
if [ $RESPONSECODE -eq "200" ]; then
	echo request $1 ok
else 
	echo request $1 failed
#	touch error.lock
fi
if [ $RESPONSECODE -eq "302" ]; then
	echo cookie expired > error.lock
  echo > /dev/null
fi
rm -rf /tmp/mitmproxy*
