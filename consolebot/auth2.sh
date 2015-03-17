#!/bin/sh
. bin/func.inc
AUTH=`cat authtoken.txt|tr -d "\n\r"`
useragent="Dalvik/1.6.0 (Linux; U; Android 4.2; Nexus 7 Build/JVP15S)"
PROXY=`cat proxy.cfg 2>/dev/null | tr -d "\n" | sed 's|[#;].*||'`
curl $PROXY -k -o response/ahlogin -D curlheaders.txt -A "$useragent" -X GET \
        -H "Accept-Encoding:gzip" \
"https://m-dot-betaspike.appspot.com/_ah/login?continue=https%3A%2F%2Fm-dot-betaspike.appspot.com&auth=$AUTH"
cat curlheaders.txt |grep -qE "HTTP/1.1 302 Found"
if [ "$?" -eq "1" ]; then
  echo "something wrong with auth" > error.lock
fi
if [ "$?" -eq "0" ]; then 
  echo 302, login ok, proceeding to gettoken
  cat curlheaders.txt |grep Cookie|awk '{print $2}'|tr -d ";\r\n" > cookie.txt
fi
