#!/bin/sh
. bin/func.inc
ITEMID=$1
sed -i "/$ITEMID/d" inventory.txt
#sed -i "/$ITEMID/d" hack.log
