#!/bin/bash
. bin/func.inc
#changet to this to have it working for any regular user, no mater how deep his bot dir is, bot should not be run by root ;)
for i in $(find ~/mitm/ -name cur.txt -mmin -30  -maxdepth 2 -a ! -path \*banned\* |grep $1 | sed 's/^\(.*\)\/cur.txt/\1/');do 
dir=$i;
  echo $dir;
  cd $dir; 
  $dir/bin/showinv.sh;
  echo -n "ap: ";
  cat ap.txt;
#  cat knobsyncts.txt;
  echo "-----";
done
