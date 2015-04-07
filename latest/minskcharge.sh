#!/bin/sh
rm -f chargenkill.html
wget http://r.thesuki.org/stats/chargenkill.html
for i in `cat chargenkill.html |grep -B 10000 kill|grep -oE "latE6=[0-9]{1,8}&lngE6=[0-9]{1,8}&z=17&pguid=[0-9a-f]{32,32}.1[1-6]"|awk '{print "http://www.ingress.com/"$0}'`;do bin/converturl2map.sh $i;done > map.war.txt
if [ -s "map.war.txt" ]
then
  echo "there are portals to be charges"
        # do something as file has data
else
  echo "there are no more portals to charge"
fi  
bin/randomizemap.sh map.war.txt
bin/hackonlyrecharge.sh map.war.txt
echo "sleeping for 15 minutes for cooldown"
sleep 900
