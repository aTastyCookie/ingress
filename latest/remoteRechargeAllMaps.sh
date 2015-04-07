#!/bin/bash
. bin/func.inc

if [ ! -f recharge.cfg ]; then
	exit
fi
MAPS=`cat recharge.cfg | grep -v -P "\s*[;#]"`
for i in $MAPS; do
	echo "Recharging $i"
	./bin/remoteRechargeMap.sh $i $1
done
