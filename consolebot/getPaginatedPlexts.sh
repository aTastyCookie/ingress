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
MAXTS=`mysql ingresscaptures -e "select msgts-1 from syscomm  order by msgts desc limit 1;"|grep -v msgts`
MAXTS="$MAXTS"000
#MAXTS=1402140898000
MINTS=-1
cells="
\"46c3000000000000\",                                                                                                                                                                    
\"46c5000000000000\",                                                                                                                                                                    
\"46cf400000000000\",                                                                                                                                                                    
\"46cfc00000000000\",                                                                                                                                                                    
\"46ce400000000000\",                                                                                                                                                                    
\"46e0c00000000000\",                                                                                                                                                                    
\"46e0400000000000\",                                                                                                                                                                    
\"46dc000000000000\",                                                                                                                                                                    
\"46d4000000000000\",                                                                                                                                                                    
\"412b400000000000\",                                                                                                                                                                    
\"4721000000000000\",                                                                                                                                                                    
\"4727000000000000\",                                                                                                                                                                    
\"472a400000000000\",                                                                                                                                                                    
\"472ac00000000000\",                                                                                                                                                                    
\"4723c00000000000\"              
"
echo "{\"params\":
         {\"playerLocation\":null,
          \"knobSyncTimestamp\":null,
          \"cellsAsHex\":[$cells],
          \"clientBasket\":
            {\"clientBlob\":null},
             \"energyGlobGuids\":null,
             \"desiredNumItems\":1000,
             \"minTimestampMs\":$MAXTS,
             \"maxTimestampMs\":$MINTS,
             \"categories\":-1,
             \"factionOnly\":false,
             \"ascendingTimestampOrder\":true}}" |gzip > plext.gz
#echo '{"params":{"playerLocation":null,"knobSyncTimestamp":null,"cellsAsHex":["46da2d0000000000","46da340000000000","46dbb40000000000","46dbbc0000000000","46dbd00000000000"],"clientBasket":{"clientBlob":null},"energyGlobGuids":null,"desiredNumItems":100,"minTimestampMs":1402140898000,"maxTimestampMs":-1,"categories":-1,"factionOnly":false,"ascendingTimestampOrder":true}}' |gzip > plext.gz
	curl $PROXY -k -s -D curlheaders.txt -A "$useragent" -X POST \
		-H "Cookie:$cookie" \
		-H "Content-Type:application/json;charset=UTF-8" \
		-H "X-XsrfToken:$token" \
	        -H "Accept-Encoding:gzip" \
		-H "Content-Encoding:gzip" \
	        --data-binary @plext.gz \
		https://m-dot-betaspike.appspot.com/rpc/playerUndecorated/getPaginatedPlexts  > response/getPaginatedPlexts
zcat response/getPaginatedPlexts > temp        
bin/parsecomm.pl  < temp|grep captured|mysql ingresscaptures
zcat response/getPaginatedPlexts |json_xs | bin/detectbiglf.pl
