#!/bin/bash
. bin/func.inc
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
  echo "your knbobsyncts is too old, i will not continue"
  touch error.lock
  exit 1
fi

#we need more requests now (max 1000 items each)  
LOOP=1
TIMESTAMP=0
rm list* inventory.txt.tmp
touch list.gz
touch list.unziped
rm -f inventory.txt.tmp
mv -f inventory.txt inventory.txt.bak
PROXY=`cat proxy.cfg 2>/dev/null | tr -d "\n" | sed 's|[#;].*||'`
for LOOP in 1; do 

	echo '{"params":{"lastQueryTimestamp":'$TIMESTAMP'}}' |gzip > payload.gz
	echo '{"params":{"lastQueryTimestamp":'$TIMESTAMP'}}' 
	curl $PROXY -k -D curlheaders.txt -A "$useragent" -X POST \
		-H "Cookie:$cookie" \
		-H "Content-Type:application/json;charset=UTF-8" \
		-H "X-XsrfToken:$token" \
	        -H "Accept-Encoding:gzip" \
		-H "Content-Encoding:gzip" \
	        --data-binary @payload.gz \
		https://m-dot-betaspike.appspot.com/rpc/playerUndecorated/getInventory  > list.gz
cat list.gz > list.$LOOP.gz
TIMESTAMP=$(zcat list.gz | sed 's/.*\"result\"\:\"\([0-9]*\)\".*/\1/')
echo 'got timestamp from response: '$TIMESTAMP
zcat list.gz | ./bin/parseinv.pl >> inventory.txt.tmp

	RESPONSECODE=`cat curlheaders.txt |grep "1.1"|head -n 1|awk '{print $2}'`
	echo $RESPONSECODE
	if [ $RESPONSECODE -eq "200" ]; then
	          echo got inventory part $LOOP
#	          cp list.gz list.backup.gz
	fi
	
done
zcat list.gz > list.unziped
sort -u inventory.txt.tmp > inventory.txt


#cat list.gz |./bin/parseinv.pl |cut -d, -f1,2,3 > inventory.txt
#if [ $1 = "y" -o $1 = "Y" ]; then
#
#echo "Writing inventory.txt"
#
#cat list.unziped |./bin/parseinv.pl > inventory.txt
#fi
