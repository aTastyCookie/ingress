#!/bin/bash
. bin/func.inc
LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`
PGUID=`cat cur.txt|cut -d, -f3`

PORTAL_IDS=`cat inventory.txt | grep -F "PORTAL_LINK_KEY" | sed 's|.*,||g' | sort | uniq`

# TODO - slow, original client probably checks multiple keys at once (getLinkabilityImpediment supports array)
# check how many keys are passed in single request

for i in $PORTAL_IDS; do
	KEY=`cat inventory.txt | grep -F "$i" | head -n1`
	
	KEY_ID=`echo $KEY | cut -d, -f 3`
	PORTAL_NAME=`echo $KEY | cut -d, -f 4- | sed 's|,[^,]*$||'`
	#echo "Portal $i Key: $KEY_ID Name: $PORTAL_NAME"
	
	LINKING=`./bin/getLinkabilityImpediment.sh $LAT $LON $KEY_ID $PGUID`
	
	echo $PORTAL_NAME: $LINKING with key $KEY_ID
	
done
