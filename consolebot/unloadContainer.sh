#!/bin/bash
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}
CAPSULEID=$1
[ "$#" -eq 1 ] || die "1 arguments required, $# provided, synopsys: $0 CAPSULEID"
LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`
LATE6=`echo $LAT*1000000/1|bc`
LONE6=`echo $LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
./bin/updateContainer.pl $HEXLATE6 $HEXLONE6 $CAPSULEID unload |gzip > payload.gz
./bin/postapi.sh updateContainer
./bin/getinventory.sh
