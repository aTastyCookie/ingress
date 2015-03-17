#!/bin/bash
usage() { echo "Usage: $0 [-n <numitems>] [-m <minTimestampMs>] [-M <maxTimestampMs>] [-c <all|faction|alerts>]  MINLAT MINLON MAXLAT MAXLON" 1>&2; exit 1; }
mints=-1
maxts=-1
numitems=50
chat="all"
while getopts ":n:m:M:c:" o; do
    case "${o}" in
        n)
            numitems=${OPTARG}
            ((numitems > 0 )) || usage
            ;;
        m)
            mints=${OPTARG}
            ;;
        M)
            maxts=${OPTARG}
            ;;
        c)
            chat=${OPTARG}
#            [ [ "$c" == "all" ] ||  [ "$c" == "faction" ]  || [ "$c" == "alerts" ] ] || usage
            ;;

        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
MINLAT=$1
MINLON=$2
MAXLAT=$3
MAXLON=$4
#check input for regmatch
rm -rf plexts
mkdir plexts
tempts=$maxts
TIMEMIN=$mints"000"
TIMEMAX=$maxts"000"
TEMPTS=$tempts"000"
TIMEMIN=-1
while [ "$tempts" -ge "$mints" ]; do
  /opt/intelbot/intel/api/getPaginatedPlexts.sh -n $numitems -a true -m $TIMEMIN -M $TEMPTS -c all $MINLAT $MINLON $MAXLAT $MAXLON
  tempts=`cat response/getPaginatedPlexts |
        json_xs |grep -oE "[0-9]{13},"|sort -n|
        cut -d, -f1|awk '{printf "%u\n", $1/1000}'|
        head -n 1`
  TEMPTS=`echo $tempts"000"-1000|bc -l`
#  delta=`echo $maxts-$tempts|bc`
#  if [ "$delta" -le 1800 ]; then
#    fsize=`stat response/getPaginatedPlexts |grep Size|awk '{print $2}'`
#    if [ "$fsize" -le 15000 ]; then
#      echo I will finish here
#      tempts=9000000000000
#    fi
#  fi
  mv response/getPaginatedPlexts plexts/plext"$TEMPTS"_"$TIMEMAX"_"$MINLAT"_"$MINLON"_"$MAXLAT"_"$MAXLON".json
done
