#!/bin/bash
cookie=`cat cookiemap.txt`
token=`cat csrftokenmap.txt`
useragent="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36"
referer="http://www.ingress.com/intel"
LAT=$1
LON=$2
DIST=$3
ZOOM=$4

DELTALAT=`echo "($DIST/6378)*(180/3.1415)"|bc -l`
DELTALON=`echo "($DIST/6378)*(180/3.1415)/c($LAT/180*3.1415)"|bc -l`
echo userused $playerid
echo deltaLAT $DELTALAT
echo deltaLON $DELTALON

LAT1=`echo "($LAT-$DELTALAT)"|bc`
LON1=`echo "($LON-$DELTALON)"|bc`
LAT2=`echo "($LAT+$DELTALAT)"|bc`
LON2=`echo "($LON+$DELTALON)"|bc`
LAT1=`echo $LAT1*100-1|bc|awk '{printf("%d\n",$1 + 0.5)}'`
LAT2=`echo $LAT2*100+1|bc|awk '{printf("%d\n",$1 + 0.5)}'`
LON1=`echo $LON1*100-1|bc|awk '{printf("%d\n",$1 + 0.5)}'`
LON2=`echo $LON2*100+1|bc|awk '{printf("%d\n",$1 + 0.5)}'`
echo MIN $LAT1,$LON1
echo MAX $LAT2,$LON2
echo ZOOM $ZOOM
qk=`echo ${LAT1}${LON1}${LAT2}${LON2}|tr -d "-"`
echo QK $qk
echo "{\"zoom\":${ZOOM},\"boundsParamsList\":[{\"id\":\"0"${qk}"\",\"minLatE6\":"${LAT1}"0000,\"minLngE6\":"${LON1}"0000,\"maxLatE6\":"${LAT2}"0000,\"maxLngE6\":"${LON2}"0000,\"qk\":\""${qk}"\"}],\"method\":\"dashboard.getThinnedEntitiesV2\"}" > ingress_payload
echo '{"zoom":8,"boundsParamsList":[{"id":"8_147_82","minLatE6":53330873,"minLngE6":26718750,"maxLatE6":54162434,"maxLngE6":28125000,"qk":"8_147_82"}],"method":"dashboard.getThinnedEntitiesV3"}' > ingress_payload
curl -k -v -s -D curlheaders.txt -A "$useragent" -X POST -H "Referer:$referer" -H "Cookie:$cookie" -H "X-CSRFToken:$token" --data @ingress_payload http://www.ingress.com/rpc/dashboard.getThinnedEntitiesV3 > list 
exit 0
