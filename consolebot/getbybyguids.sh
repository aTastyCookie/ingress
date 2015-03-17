#!/bin/bash
bin/auths.sh
echo 53.900228,27.564707 > cur.txt
LAT="53.900228"
LON="27.564707"
rm -f /tmp/rb
mysql ingresscaptures -e "select distinct portalgid from syscomm into outfile '/tmp/rb';"
cat /tmp/rb maps/byallguids.txt|sort -n|uniq |grep -E '^[0-9a-f]{32}.1[1-6]' > /tmp/rb2
mv /tmp/rb2 maps/byallguids.txt
rm -f /tmp/rb
bin/getModifiedEntitiesByGuidV2.sh $LAT $LON maps/byallguids.txt
find mapres/ -type f -size 0|xargs rm
bin/concantenatejsonsclient.pl  > response/getObjectsInCells
scp response/getObjectsInCells root@185.66.70.13:/var/www/thesuki.org/ingress/stats/by/temp/list
ssh root@185.66.70.13 /var/www/thesuki.org/ingress/stats/by/00.generateall.sh
