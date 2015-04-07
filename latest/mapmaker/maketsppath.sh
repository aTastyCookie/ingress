#!/bin/bash
cat $1 |awk -F, '{print NR,$1,$2}' > temp.tsp
DIMENSION=`wc -l < temp.tsp`
cat bin/mapmaker/minsk.tsp.tmpl temp.tsp > minsk.tsp
echo EOF >> minsk.tsp
sed -i -e "s/CHANGEME/$DIMENSION/g" minsk.tsp
./bin/mapmaker/linkern -K 2 -I 1  -o minsk.linkern minsk.tsp >/dev/null
cat minsk.linkern|tr " " ","  |tail -n +2 > minsk.linkern.tmp
mv minsk.linkern.tmp minsk.linkern
cat temp.tsp |tr " " "," > temp.tsp.tmp
mv temp.tsp.tmp temp.tsp
cat $1  > minsk.coordswithpgid
./bin/mapmaker/tsppath.pl > curpath.txt
exit 0
#old slow code
for i in `cat minsk.linkern`;do
  from=`echo $i|cut -d, -f1`
  to=`echo $i|cut -d, -f2`
  ((from++))
  ((to++))
  fromcoord=`cat temp.tsp|grep -E "^$from,"|cut -d, -f2,3`
  tocoord=`cat temp.tsp|grep -E "^$to,"|cut -d, -f2,3`
  portalguid=`cat $1|grep $tocoord|grep -o  -E "[0-9a-z]{32}.1[1-6]"`
  distance=`./bin/mapmaker/distance.pl $fromcoord  $tocoord`
  DISTMIN=`echo "scale=0; 70*$distance/1000"|bc`
  echo $tocoord,$DISTMIN,$portalguid
done
