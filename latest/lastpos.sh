#!/bin/bash
. bin/func.inc
[ -f cur.txt ] || exit
lat=`cat cur.txt|cut -d, -f1`
long=`cat cur.txt|cut -d, -f2`
[ "$lat" == "" ] && exit
[ "$long" == "" ] && exit

PROXY=`cat proxy.cfg 2>/dev/null | tr -d "\n" | sed 's|[#;].*||'`
result=`curl $PROXY -s "http://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&sensor=false"`

# "formatted_address" : "Street, City, ... , Country"

function displaytime {
        local T=$1
        local D=$((T/60/60/24))
        local H=$((T/60/60%24))
        local M=$((T/60%60))
        local S=$((T%60))
        [[ $D > 0 ]] && printf '%d days ' $D
        [[ $H > 0 ]] && printf '%d hours ' $H
        [[ $M > 0 ]] && printf '%d minutes ' $M
        [[ $D > 0 || $H > 0 || $M > 0 ]] && printf 'and '
        printf '%d seconds\n' $S
}

addr=`echo $result | grep -o -P '"formatted_address"[^"]*"[^"]*"' | head -n1 | cut -d : -f 2 | sed 's|"||g'`

echo $addr
# needs to touch cur.txt after every operation
MOD=`stat -c %Y cur.txt`
CURRENT=`date +%s`
let DIFF=$CURRENT-$MOD

displaytime $DIFF
