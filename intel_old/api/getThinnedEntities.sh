#!/bin/bash
usage() { echo "Usage: $0 [-l <portallevel>]   MINLAT MINLON MAXLAT MAXLON" 1>&2; exit 1; }
portallevel=8
while getopts ":l:" o; do
    case "${o}" in
        l)
            portallevel=${OPTARG}
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
rm -rf tiles/*
api/generatetiles.pl $portallevel $MINLAT $MINLON $MAXLAT $MAXLON
rm -rf tempjsons/*
for i in `ls tiles/`; do 
  cat tiles/$i > payload
  ./api/postrpc.sh getThinnedEntities
  mv response/getThinnedEntities tempjsons/$i
done
./bin/concantenatejsons.pl  > response/getThinnedEntities
#rm -rf tempjsons/*
