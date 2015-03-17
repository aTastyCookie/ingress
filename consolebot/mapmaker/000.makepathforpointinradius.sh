#!/bin/bash
TEMPFILENAME=`date +%s`
TEMPFILENAME=1371055649
LAT=$1
LON=$2
RADIUS=$3
FILENAME=$4
DELTALAT=`echo "($RADIUS/6378)*(180/3.1415)"|bc -l`
DELTALON=`echo "($RADIUS/6378)*(180/3.1415)/c($LAT/180*3.1415)"|bc -l`
LAT1=`echo "($LAT-$DELTALAT)"|bc`
LON1=`echo "($LON-$DELTALON)"|bc`
LAT2=`echo "($LAT+$DELTALAT)"|bc`
LON2=`echo "($LON+$DELTALON)"|bc`
./bin/mapmaker/01.fetchjsoninradius.sh $LAT $LON $RADIUS 0
mv list $TEMPFILENAME.json
./bin/mapmaker/generateportalslist.pl $TEMPFILENAME.json > $TEMPFILENAME.plist
cat $TEMPFILENAME.plist| awk -v "latmin=$LAT1" -v "latmax=$LAT2" -v "lonmin=$LON1" -v "lonmax=$LON2" -F, '{if ($1>latmin && $1<latmax && $2>lonmin && $2<lonmax) {print $0} }' > $TEMPFILENAME.tlist
./bin/mapmaker/maketsppath.sh $TEMPFILENAME.tlist
mv curpath.txt $FILENAME.txt
echo -n "total pathtime: "
cat $FILENAME.txt |awk -F, '{sum+=$3} END {print sum}'
perl -C ./bin/mapmaker/02.makeall.pl  < $TEMPFILENAME.json  > tmp.tmp
cat bin/mapmaker/htmlheader.inc|sed -e "s/CENTLAT/$LAT/g" |sed -e "s/CENTLON/$LON/g"|sed -e "s/MINLAT/$LAT1/g"|sed -e "s/MAXLAT/$LAT2/g"|sed -e "s/MINLON/$LON1/g"|sed -e "s/MAXLON/$LON2/g" > $FILENAME.html
cat  tmp.tmp bin/mapmaker/htmlfooter.inc  >> $FILENAME.html
./bin/mapmaker/makepath.pl $TEMPFILENAME.tlist `head -n 1 $TEMPFILENAME.tlist`> $FILENAME.war.txt.tmp
./bin/mapmaker/mktime.sh $FILENAME.war.txt.tmp > $FILENAME.war.txt
#rm -f $TEMPFILENAME.json $TEMPFILENAME.plist $TEMPFILENAME.tlist $FILENAME.war.txt.tmp
echo -n "total warpathtime: "
cat $FILENAME.war.txt |awk -F, '{sum+=$3} END {print sum}'
