#!/bin/bash
usage() { echo "Usage: $0 [-n <numitems>] [-m <minTimestampMs>] [-M <maxTimestampMs>] [-c <all|faction|alerts>]  MINLAT MINLON MAXLAT MAXLON" 1>&2; exit 1; }
mints=-1
maxts=-1
numitems=5000
chat="all"
ascorder="false"
while getopts ":a:n:m:M:c:" o; do
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
        a)
            ascorder=${OPTARG}
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
. mungs.inc
echo "{
      \"${desiredNumItems}\":$numitems,\
      \"${minLatE6}\":$MINLAT,\
      \"${minLatE6}\":$MINLAT,\
      \"${minLngE6}\":$MINLON,\
      \"${maxLatE6}\":$MAXLAT,\
      \"${maxLngE6}\":$MAXLON,\
      \"${minTimestampMs}\":$mints,\
      \"${maxTimestampMs}\":$maxts,\
      \"${version}\":\"${version_parameter}\",\
      \"${chatTab}\":\"${chat}\"}" > payload
./api/postrpc.sh getPaginatedPlexts
