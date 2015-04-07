#!/bin/bash
useragent="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36"
PROXY=`cat proxy.cfg 2>/dev/null | tr -d "\n" | sed 's|[#;].*||'`
cookie="__utma=24037858.1955343653.1371138467.1371138467.1371138467.1; __utmb=24037858.2.9.1371138479563; __utmc=24037858; __utmz=24037858.1371138467.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)"
URL=`cat curlheaders.txt |grep Location|awk '{print $2}'`
curl $PROXY  -k -D curlheaders.txt  -A "$useragent" -X GET \
        -c cookie.jar -b cookie.jar \
        -H "Content-Type:application/json;charset=UTF-8" \
        -H "Accept-Encoding:gzip"  $URL  > login


echo $cookie > cookiemap.txt
echo "; " >> cookiemap.txt
cat curlheaders.txt |grep Set-Cookie|awk '{print $2}' >> cookiemap.txt
cat cookiemap.txt|tr -d "\n" |sed -e 's/;$//g' > temp.cookiemap.txt
mv temp.cookiemap.txt cookiemap.txt
