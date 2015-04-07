#!/bin/bash
. bin/func.inc
APIREQUEST=$1
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

if [ "$deltatime" -ge "850000000" ]; then
  echo knbobsyncts is getting old, trying to reauth
  bin/auth.sh
  cookie=`cat cookie.txt|tr -d "\r\n"`
  token=`cat csrftoken.txt|tr -d "\r\n"`
  knobsyncts=`cat knobsyncts.txt|tr -d "\r\n"`
  rm error.lock
#  bin/getinventory.sh
fi



if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  sleep 10
  exit 1
fi
touch cur.txt
PROXY=`cat proxy.cfg 2>/dev/null | tr -d "\n" | sed 's|[#;].*||'`
curl $PROXY -k -D curlheaders.txt   -A "$useragent" -X POST \
        -H "Cookie:$cookie" \
        -H "Content-Type:application/json;charset=UTF-8" \
        -H "Accept-Encoding:gzip" \
        -H "X-XsrfToken:$token" \
        -H "Content-Encoding: gzip" \
        --data-binary @payload.gz \
        https://m-dot-betaspike.appspot.com/rpc/gameplay/$APIREQUEST 2>/dev/null |gunzip > response/$APIREQUEST
LOCATION=`cat cur.txt|cut -d, -f1,2`
echo `date` $LOCATION $APIREQUEST >> postapi.log
RESPONSECODE=`cat curlheaders.txt|grep "1.1" |head -n 1|awk '{print $2}'`
#RESPONSECODE=`cat curl.log |grep -oE "< HTTP/1.1 ... "|awk '{print $3}'`
echo $RESPONSECODE
if [ $RESPONSECODE -eq "200" ]; then
	echo request $1 ok
	./bin/checkxm.pl response/$APIREQUEST
else 
	echo request $1 failed
#	touch error.lock
#	./bin/checkxm.pl response/$APIREQUEST
fi
#cat response/$APIREQUEST|json_xs
if [ $RESPONSECODE -eq "302" ]; then
	echo cookie expired > error.lock
  echo > /dev/null
fi
if [ $RESPONSECODE -eq "403" ]; then
        echo banned > error.lock
  echo > /dev/null
fi

numitems=`wc -l < inventory.txt`
echo -e "Items:\033[31m $numitems \e[0m"
#rm -rf /tmp/mitmproxy*
