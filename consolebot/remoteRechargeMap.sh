#!/bin/bash
. bin/func.inc

MAP=$1
COUNT=$2
cat $MAP | cut -d , -f 4 > auto.recharge.txt
KEYS=`cat inventory.txt | grep -F "PORTAL_LINK_KEY"| grep -F -f auto.recharge.txt | uniq | sort -R | cut -d , -f 3 | tr '\n' ' '`

#IFS=\n
for i in $KEYS; do
	XM=`cat xm.txt`
	if [ "$XM" -lt "1600" ]; then
		echo "Not enough XM for recharge"
		exit
	fi
	let COUNT--
	echo Remote recharging $i
	cat inventory.txt | grep -F "$i" | cut -d , -f 4-
	LAT=`cat cur.txt|cut -d, -f1`
	LON=`cat cur.txt|cut -d, -f2`
	touch cur.txt
	
	# TODO: check for portals that need recharge - getObjectsInCells.checkrecharge.pl
	# current recharge is slow
	./bin/remoteRechargeResonatorsV2.sh $LAT $LON $i
	if [ "$COUNT" -le "0" ]; then
		exit
	fi
done

rm -f auto.recharge.txt
