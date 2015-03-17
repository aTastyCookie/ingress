#!/bin/bash
usage() { echo "Usage: $0 [-n <numitems>]  MINLAT MINLON MAXLAT MAXLON" 1>&2; exit 1; }
mints=-1
maxts=-1
numitems=10
chat="all"
while getopts ":n:m:M:c:" o; do
    case "${o}" in
        n)
            numitems=${OPTARG}
            ((numitems > 0 )) || usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
MINLAT=51.26
MINLON=23.17
MAXLAT=56.17
MAXLON=32.78
MINLAT=$1
MINLON=$2
MAXLAT=$3
MAXLON=$4
#check input for regmatch
rm -f checked.list
rm -f list2check.csv
MINLATE6=`echo $MINLAT*1000000|bc`
MAXLATE6=`echo $MAXLAT*1000000|bc`
MINLONE6=`echo $MINLON*1000000|bc`
MAXLONE6=`echo $MAXLON*1000000|bc`

CENTERLAT=`echo "($MINLAT+$MAXLAT)/2"|bc -l`
CENTERLON=`echo "($MINLON+$MAXLON)/2"|bc -l`
#generate coverage list to list2check.csv
NUMITERATIONSLAT=`echo "($MAXLATE6-($MINLATE6))/10000"|bc`
NUMITERATIONSLON=`echo "($MAXLONE6-($MINLONE6))/20000"|bc`
echo $NUMITERATIONSLAT,$NUMITERATIONSLON
for ilat in `seq 0 $NUMITERATIONSLAT`;do
  CURLAT=`echo "($MINLATE6+$ilat*10000)/1000000"|bc -l`
  for ilon in `seq 0 $NUMITERATIONSLON`;do
    CURLON=`echo "($MINLONE6+$ilon*20000)/1000000"|bc -l`
    echo $CURLAT,$CURLON,chainstart >> list2check.csv
  done
done
NUM2CHECK=`wc -l list2check.csv|awk '{print $1}'`
while [ "$NUM2CHECK" -gt "0" ]; do
  PORTAL2CHECK=`cat list2check.csv |sort -R|head -n 1`
  PGUID2CHECK=`echo $PORTAL2CHECK|cut -d, -f3`
  LAT2CHECK=`echo $PORTAL2CHECK|cut -d, -f1`
  LON2CHECK=`echo $PORTAL2CHECK|cut -d, -f2`
  echo $LAT2CHECK,$LON2CHECK,$PGUID2CHECK |grep -v chainstart>> checked.list
  sed -i "/$LAT2CHECK,$LON2CHECK,$PGUID2CHECK/d" list2check.csv
  bin/findNearbyPortals.sh $LAT2CHECK $LON2CHECK 100
  cp response/findNearbyPortals mapres/findNearbyPortals.$LAT2CHECK-$LON2CHECK.json
#need to optimize grep -vf since it takes TOO much time when checked.csv is big
  bin/generateportalslistfromnearby.pl response/findNearbyPortals | awk -v "latmin=$MINLAT" -v "latmax=$MAXLAT" -v "lonmin=$MINLON" -v "lonmax=$MAXLON" -F, '{if ($1>latmin && $1<latmax && $2>lonmin && $2<lonmax) {print $0} }' |grep -vf checked.list >> list2check.csv
  cat list2check.csv|sort -n|uniq > list2check.tmp
  mv list2check.tmp list2check.csv
  NUM2CHECK=`wc -l list2check.csv|awk '{print $1}'`
  echo left $NUM2CHECK to check
done




