#!/bin/bash
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}
TYPE=$1
LEVEL=$2
AMOUNT=$3
LOCATION=$4
[ "$#" -eq 3 ] || [ "$#" -eq 4 ] || die "3 or 4 arguments required, $# provided, synopsys: $0 TYPE LEVEL AMOUNT [drop file]"

echo $1 | grep -E -q 'EMITTER_A|EMP_BURSTER|PORTAL_LINK_KEY|FLIP_CARD|MEDIA|POWER_CUBE|RES_SHIELD|LINK_AMPLIFIER|HEATSINK|FORCE_AMP|MULTIHACK|TURRET' \
  || die "EMITTER_A|EMP_BURSTER|PORTAL_LINK_KEY|FLIP_CARD|MEDIA|POWER_CUBE|RES_SHIELD|LINK_AMPLIFIER|HEATSINK|FORCE_AMP|MULTIHACK required, $1 provided"

echo $2 | grep -E -q '^[0-9]+$|^VERY_RARE$|^RARE$|^COMMON$|^ADA$|^JARVIS$' || die "Numeric / COMMON/RARE/VERY_RARE required, $2 provided"
echo $3 | grep -E -q '^[0-9]+$' || die "Numeric argument required, $3 provided"

if [ -f error.lock ]; then
	ERROR=`cat error.lock`
	if [ "$ERROR" != "too much items, i will not continue" ]; then
		 echo "error.lock is present, i will not continue"
		exit 1
	fi
	echo "Too much items in inventory. Drop allowed."
fi

if [ "$LOCATION" != "" ]; then
	cat $LOCATION > cur.txt
	touch cur.txt
fi

cat inventory.txt |grep -E "$TYPE,$LEVEL"|head -n $AMOUNT|cut -d, -f3 > tempitemids.txt
NUMITEMS=`wc -l < tempitemids.txt`
if [ "$NUMITEMS" -lt "$AMOUNT" ]; then
        echo "insufficient $TYPE,$LEVEL"
        echo "you want $AMOUNT but there is only $NUMITEMS"
        exit 1
fi

LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`
#DELTALAT=$(($RANDOM%1500-750))
#DELTALON=$(($RANDOM%1500-750))
#sleep 10
#LAT=`echo "($DELTALAT/1000000+$LAT)"|bc -l`
#LON=`echo "($DELTALON/1000000+$LON)"|bc -l`
#echo $LAT,$LON
for itemid in `cat tempitemids.txt`;do 
   ./bin/dropItem.sh $LAT $LON $itemid
   dropid=`cat response/dropItem |json_xs |grep -oE "[0-9a-f]{32}.4"`
   echo $dropid >> maps/itemspile
   echo $dropid > maps/pickpick
   ./bin/removefrominv.sh $itemid
   sleep 2
   rm maps/pickpick
done
