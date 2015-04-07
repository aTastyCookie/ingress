#!/bin/sh
while true;do
  if [ -f error.lock ]; then
    echo "error.lock is present, i will not continue"
    exit 1
  fi
#  bin/auths.sh;
#  bin/getinventory.sh;
#  cp map.war.txt map.war.txt.tmp
#  bin/mktime.sh map.war.txt.tmp > map.war.txt
    bin/hackwgl.sh maps/vilniuslatest.txt ;
    bin/clearinv.sh;
    sleep 500;
done



