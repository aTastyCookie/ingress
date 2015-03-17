#!/bin/bash
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}
TYPE=$1
LEVEL=$2
AMOUNT=$3
CAPSULEID=$4
[ "$#" -eq 4 ] || die "4 arguments required, $# provided, synopsys: $0 TYPE LEVEL AMOUNT CAPSULEID"
echo $1 | grep -E -q 'EXTRA_SHIELD|CAPSULE|ULTRA_STRIKE|EMITTER_A|EMP_BURSTER|PORTAL_LINK_KEY|MEDIA|POWER_CUBE|RES_SHIELD|HEATSINK|FORCE_AMP|MULTIHACK|TURRET|LINK_AMPLIFIER|FLIP_CARD' || die "EMITTER_A|EMP_BURSTER|POWER_CUBE|RES_SHIELD|HEATSINK|FORCE_AMP|MULTIHACK|TURRET|LINK_AMPLIFIER required, $1 provided"
echo $2 | grep -E -q '^[0-9]+$|^VERY_RARE$|^RARE$|^COMMON$|^JARVIS$|^ADA$' || die "Numeric / COMMON/RARE/VERY_RARE required, $2 provided"
echo $3 | grep -E -q '^[0-9]+$' || die "Numeric argument required, $3 provided"
LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`
LATE6=`echo $LAT*1000000/1|bc`
LONE6=`echo $LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
cat inventory.txt |grep -E "$TYPE,$LEVEL"|head -n $AMOUNT|cut -d, -f3 > tempitemids.txt
NUMITEMS=`wc -l < tempitemids.txt`
if [ "$NUMITEMS" -lt "$AMOUNT" ]; then
        echo "insufficient $TYPE,$LEVEL"
        echo "you want $AMOUNT but there is only $NUMITEMS"
        exit 1
fi
./bin/updateContainer.pl $HEXLATE6 $HEXLONE6 $CAPSULEID load |gzip > payload.gz
./bin/postapi.sh updateContainer
./bin/getinventory.sh
