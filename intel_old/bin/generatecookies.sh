#!/bin/sh
cookieSID=`cat /var/www/thesuki.org/ingress/casper2/cookie.jar |grep -oE "=([0-9a-zA-Z\_\-]){500,}"`
CSRFTOKEN=`cat /var/www/thesuki.org/ingress/casper2/log.log |grep Cookie|tail -n 1|cut -d: -f2- |grep -oE "=([0-9a-zA-Z\-\_]){32};"|tr -d "=;"`
echo "GOOGAPPUID=388; ACSID$cookieSID; csrftoken=$CSRFTOKEN; __utma=24037858.1217958745.1393793379.1393793379.1393793379.1; __utmb=24037858.4.9.1393793384125; __utmc=24037858; __utmz=24037858.1393793379.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); ingress.intelmap.lat=28.91586278844249; ingress.intelmap.lng=-2.63671875; ingress.intelmap.zoom=2" > cookiemap.txt
echo $CSRFTOKEN > csrftokenmap.txt 
