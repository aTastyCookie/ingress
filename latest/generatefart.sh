#!/bin/bash
LAT=`cat cur.txt|cut -d, -f1`
LON=`cat cur.txt|cut -d, -f2`
FILE=$1
tac $FILE |tr ";" ","|sed -e 's@^,@0,@g'|sed -e 's@,\r@,0@g'|sed -e 's/,,/,0,/g'|sed -e 's/,,/,0,/g'> /tmp/FART
X=0
for x in `cat /tmp/FART`;do
  let X=X+1
  for y in `seq 1 56`;do
    POINT=`echo $x|cut -d, -f$y`
    if [ "$POINT" -eq "1" ]; then
      DELTALAT=`echo "scale=6;($X/6378)*(180/3.1415)/1000"|bc -l`
      DELTALON=`echo "scale=6;($y/6378)*(180/3.1415)/c($LAT/180*3.1415)/1000"|bc -l`
      LAT2=`echo "($LAT+$DELTALAT*$2)"|bc`
      LON2=`echo "($LON+$DELTALON*$2)"|bc`
      echo $LAT2,$LON2,1
    fi
  done
done
