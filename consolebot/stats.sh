#!/bin/bash
. bin/func.inc
for i in `cat botlist.ini`;do 
	cd ~/mitm/$i; 
	LVL=`./bin/getmylevel.sh`
	echo L$LVL $i;
	echo -n "AP: ";
	cat ap.txt;
	./bin/lastpos.sh;
	./bin/showinv.sh|grep total;
	cat knobsyncts.txt;
	echo "-----";
done
