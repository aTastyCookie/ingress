#!/bin/bash
#run manually#bin/generatepointsforintelfetch.pl 8 51.16 23.11 56.10 30.5 > maps.byall.txt
# mkdir mapres
count=0
total=`wc -l maps.byall.txt|awk '{print $1}'`
for i in `cat maps.byall.txt`;do 
  let count++
  echo $count of $total
  lat=`echo $i|cut -d, -f1`
  lon=`echo $i|cut -d, -f2`
  bin/getmap.sh $lat $lon 0.3
  cat response/getObjectsInCells | grep -q result
  if [ "$?" -eq "1" ]; then
    bin/getmap.sh $lat $lon 0.2
  fi
  cp response/getObjectsInCells mapres/$i
done
bin/concantenatejsonsclient.pl  > json.result
