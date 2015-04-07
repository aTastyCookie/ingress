#!/bin/bash
PORTALGUID=`cat  maps/vc4.txt |cut -d, -f3|sort -R|head -n 1`
while true; do
cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells
  ./bin/upgradeportalmod.sh 0 0 $PORTALGUID
  ./bin/rechargeResonatorsV2.sh 0 0 $PORTALGUID
  ./bin/rechargeResonatorsV2.sh 0 0 $PORTALGUID
  ./bin/rechargeResonatorsV2.sh 0 0 $PORTALGUID
  ./bin/upgradeportalmod.sh 0 0 $PORTALGUID
  if [ -f maps/vcl5.txt ]; then
    echo "WAR HAS BEGUN"
    bin/vwar5.sh
  fi 
done
