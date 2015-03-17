#!/bin/bash
APIREQUEST=$1
APIMETHOD=`cat mungs.inc|grep $1|cut -d= -f2`
useragent="User-Agent: Mozilla/5.0 (Windows NT 5.2) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31"
referer="https://www.ingress.com/intel"
cookie=`cat cookiemap.txt|tr -d "\r\n"`
token=`cat csrftokenmap.txt|tr -d "\r\n"`
PROXY=`cat proxy.cfg 2>/dev/null | tr -d "\n" | sed 's|[#;].*||'`
curl $PROXY  -s -k  -D curlheaders.txt  \
        -A "$useragent" \
        -X "POST" \
        -H "Cookie: $cookie" \
        -H "Content-Type: application/json;charset=UTF-8" \
        -H "Accept-Encoding: gzip" \
        -H "X-CSRFToken: $token" \
        -H "Referer:$referer" \
        --data-binary @payload \
        https://www.ingress.com/r/${APIMETHOD}  |gunzip > response/$APIREQUEST
RESPONSECODE=`cat curlheaders.txt |head -n 1|awk '{print $2}'`
#RESPONSECODE=`cat curl.log |grep -oE "< HTTP/1.1 ... "|awk '{print $3}'`
#echo $RESPONSECODE
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
