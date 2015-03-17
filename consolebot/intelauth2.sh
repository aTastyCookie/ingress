#!/bin/sh
AUTH=`cat authtoken.txt|tr -d "\n\r"`
PROXY=`cat proxy.cfg 2>/dev/null | tr -d "\n" | sed 's|[#;].*||'`
useragent="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36"
curl $PROXY -k -c cookie.jar -b cookie.jar -o /dev/null -D curlheaders.txt -A "$useragent" -X GET \
        -H "Accept-Encoding:gzip" \
"https://appengine.google.com/_ah/conflogin?continue=https%3A%2F%2Fwww.ingress.com%2Fintel%2F&auth=$AUTH&authuser=0"
cat curlheaders.txt |grep -qE "HTTP/1.1 302 Found"
if [ "$?" -eq "1" ]; then
  echo "something wrong with auth" > error.lock
fi
if [ "$?" -eq "0" ]; then 
  echo 302, login ok, proceeding to gettoken
  cat curlheaders.txt |grep Cookie|awk '{print $2}'|tr -d ";\r\n" > cookiemap.txt
fi
