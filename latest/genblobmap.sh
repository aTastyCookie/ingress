#!/bin/sh
cat $1|cut -d, -f4 > list.all
ls maps/portalhackblobs/ > list.blobs
cat $1 > tmp.tmp.tmp
cat list.all list.blobs |sort -n|uniq -c|sort -n|awk '{if ($1==2) print "cat tmp.tmp.tmp|grep",$2}' |sh > $1
rm -f list.all list.all
