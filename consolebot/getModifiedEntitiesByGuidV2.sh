#!/bin/bash
. bin/func.inc
LAT=$1
LON=$2
PORTALGUIDLIST=$3
#DELTALAT=$(($RANDOM%200-100))
#DELTALON=$(($RANDOM%200-100))
DELTALAT=0
DELTALON=0
LATE6=`echo $DELTALAT+$LAT*1000000/1|bc`
LONE6=`echo $DELTALON+$LON*1000000/1|bc`
HEXLATE6=`HEXE6   $LATE6`
HEXLONE6=`HEXE6   $LONE6`
#check input for regmatch
rm -rf mapres
mkdir mapres
cat $PORTALGUIDLIST|grep -qvE "^[a-f0-9]{32}.1[1-6]"
if [ "$?" -eq "1" ]; then
  echo will check portal $PORTALGUID
  echo "$LAT,$LON" > cur.txt
  numline=0
  rm -f entitiesToCheck
  while read line;do
        echo "$line" >> entitiesToCheck
        ((numline++))
        if [ $numline -ge "100" ]; then
          ./bin/getModifiedEntitiesByGuidV2.pl $HEXLATE6 $HEXLONE6 entitiesToCheck|gzip > payload.gz
          ./bin/postapi.sh getModifiedEntitiesByGuid
          cp response/getModifiedEntitiesByGuid mapres/`date +%s`
          numline=0
          rm -f entitiesToCheck
        fi
  done < $PORTALGUIDLIST
         if [ -f entitiesToCheck ]; then
          ./bin/getModifiedEntitiesByGuidV2.pl $HEXLATE6 $HEXLONE6 entitiesToCheck|gzip > payload.gz
          ./bin/postapi.sh getModifiedEntitiesByGuid
          cp response/getModifiedEntitiesByGuid mapres/`date +%s`
        fi
  exit 0
fi
echo "bad guidslist file"
exit 1
