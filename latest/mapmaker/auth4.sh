#!/bin/bash
useragent="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36"
cookie=`cat cookiemap.txt`
URL='http://www.ingress.com/intel/'

curl -k -D curlheaders.txt  -A "$useragent" -X GET \
        -H "Cookie:$cookie" \
        -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
        -H "Accept-Encoding:gzip"  $URL  > login

csrftokencookie=`cat curlheaders.txt |grep Set-Cookie|awk '{print $2}'|tr -d "\n"`
cookie=`cat cookiemap.txt`
echo -n $csrftokencookie > cookiemap.txt
echo -n " " >> cookiemap.txt
echo $cookie >> cookiemap.txt
cat curlheaders.txt |grep Set-Cookie|awk '{print $2}'|cut -d= -f2|sed -e 's/;$//g'|tr -d "\n" > csrftokenmap.txt

