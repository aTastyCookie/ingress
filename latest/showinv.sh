#!/bin/sh
. bin/func.inc
if [ "$1" ]; then
  if [ "$1" -eq "1" ]; then
   cat list.unziped | json_xs |bin/parseinvV2.pl
   exit 0
  else 
  echo total: `wc -l < inventory.txt`
  cat inventory.txt |cut -d, -f1,2|sort -n|uniq -c
 fi
 else
  echo total: `wc -l < inventory.txt`
  cat inventory.txt |cut -d, -f1,2|sort -n|uniq -c
fi
