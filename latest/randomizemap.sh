#!/bin/sh
. bin/func.inc
cat $1|cut -d, -f1,2,4|sort -n|uniq > map.tlist
./bin/makepath.pl map.tlist `shuf  -n 1 map.tlist`> map.war.txt.tmp
#./bin/makepath.pl map.tlist 53.871256,27.536251,892316d0689641769737c5bba0efc9a1.16 > map.war.txt.tmp
./bin/mktime.sh map.war.txt.tmp > map.war.txt
rm -f  map.tlist map.war.txt.tmp
echo -n "total warpathtime: "
cat map.war.txt |awk -F, '{sum+=$3} END {print sum}'

