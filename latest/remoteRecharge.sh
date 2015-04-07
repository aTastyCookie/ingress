#!/bin/bash
. bin/func.inc
COUNT=1
KEYS=`cat rechargekeys.txt | grep -F "PORTAL_LINK_KEY"| uniq | sort -R | cut -d , -f 3 | tr '\n' ' '`

#IFS=\n
for i in $KEYS; do
	XM=`cat xm.txt`
	if [ "$XM" -lt "1600" ]; then
		echo "Not enough XM for recharge"
		break
	fi
	let COUNT--
	echo Remote recharging $i
	cat inventory.txt | grep -F "$i" | cut -d , -f 4-
        PGUID=`cat inventory.txt | grep -F "$i" | cut -d , -f 4-|grep -oE "[0-9a-z]{32}.1[1-6]"`
	LAT=`cat cur.txt|cut -d, -f1`
	LON=`cat cur.txt|cut -d, -f2`
        echo $PGUID
	touch cur.txt
        bin/getModifiedEntitiesByGuid.sh $LAT $LON $PGUID
        bin/getModifiedEntitiesByGuid.checkrecharge.pl response/getModifiedEntitiesByGuid $PGUID
        if [ -f "portalcharge.txt" ];then
           echo will remote recharge portal
           ./bin/remoteRechargeResonatorsV2.sh $LAT $LON $i
           cat response/remoteRechargeResonatorsV2 |json_xs|grep RESONATORS_FULLY_CHARGED
           if [ "$?" -eq "0" ]; then
            echo "fully charged this portal, removing it"
            sed -i "/$i/d" rechargekeys.txt
           fi
           rm portalcharge.txt
         else
           echo "alien portal, removing"
           sed -i "/$i/d" rechargekeys.txt
        fi
        if [ -f "portaldelete.txt" ];then
           echo "portal already at max, will remove it"
           sed -i "/$i/d" rechargekeys.txt
           rm portaldelete.txt
        fi
        cat maps/p |gzip > payload.gz  ; bin/postapi.sh getObjectsInCells	
	if [ "$COUNT" -le "0" ]; then
		break
	fi
done
