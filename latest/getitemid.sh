#!/bin/sh
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}
TYPE=$1
LEVEL=$2
AMOUNT=$3
[ "$#" -eq 3 ] || die "3 arguments required, $# provided, synopsys: $0 TYPE LEVEL AMOUNT"
echo $1 | grep -E -q 'EMITTER_A|EMP_BURSTER|POWER_CUBE|SHIELD|LINK_AMPLIFIER|HEATSINK|FORCE_AMP|MULTIHACK|TURRET|FLIP_CARD' || die "EMITTER_A|EMP_BURSTER|POWER_CUBE|SHIELD|LINK_AMPLIFIER|HEATSINK|FORCE_AMP|MULTIHACK|TURRET|FLIP_CARD required, $1 provided"
echo $2 | grep -E -q '^[0-9]+$|^VERY_RARE$|^RARE$|^COMMON$|^ADA$|^JARVIS$' || die "Numeric / COMMON/RARE/VERY_RARE required, $2 provided"
echo $3 | grep -E -q '^[0-9]+$' || die "Numeric argument required, $3 provided"

cat inventory.txt |grep -E "$TYPE,$LEVEL"|head -n $AMOUNT|cut -d, -f3 > tempitemids.txt
NUMITEMS=`wc -l < tempitemids.txt`
if [ "$NUMITEMS" -lt "$AMOUNT" ]; then
        echo "insufficient $TYPE,$LEVEL"
        echo "you want $AMOUNT but there is only $NUMITEMS"
        exit 1
fi
