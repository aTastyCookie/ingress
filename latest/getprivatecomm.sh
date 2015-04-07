#!/bin/bash
. bin/func.inc
useragent="Nemesis (gzip2)"
cookie=`cat cookie.txt|tr -d "\r\n"`
token=`cat csrftoken.txt|tr -d "\r\n"`
knobsyncts=`cat knobsyncts.txt|tr -d "\r\n"`
PROXY=`cat proxy.cfg 2>/dev/null | tr -d "\n" | sed 's|[#;].*||'`
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


echo '{"params":{"playerLocation":null,"knobSyncTimestamp":null,"cellsAsHex":["46da2d0000000000","46da340000000000","46dbb40000000000","46dbbc0000000000","46dbd00000000000"],"clientBasket":{"clientBlob":null},"energyGlobGuids":null,"desiredNumItems":500,"minTimestampMs":-1,"maxTimestampMs":-1,"categories":2,"factionOnly":false,"ascendingTimestampOrder":false}}' |gzip > plext.gz
	curl $PROXY -k -D curlheaders.txt -A "$useragent" -X POST \
		-H "Cookie:$cookie" \
		-H "Content-Type:application/json;charset=UTF-8" \
		-H "X-XsrfToken:$token" \
	        -H "Accept-Encoding:gzip" \
		-H "Content-Encoding:gzip" \
	        --data-binary @plext.gz \
		https://m-dot-betaspike.appspot.com/rpc/playerUndecorated/getPaginatedPlexts  > response/getPaginatedPlexts
