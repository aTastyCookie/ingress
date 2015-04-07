#!/bin/bash
. bin/func.inc
while true ; do 
  cat inventory.txt|grep CAPSULE|grep -vE ",0/100"
  if [ "$?" -eq "1" ]; then
    exit 1
  fi
 for i in `cat inventory.txt|grep CAPSULE|grep -vE ",0/100"|cut -d, -f3`;do bin/unloadContainer.sh $i;done
done
