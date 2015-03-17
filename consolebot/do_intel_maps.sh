bin/auth.sh
DATEPREV=`date +%s/32000|bc`
while true; do
  DATE=`date +%s/32000|bc`
  if [ "$DATE" -gt "$DATEPREV" ]; then
    bin/auth.sh;
    DATEPREV=$DATE
  fi
#broken  bin/getmap.sh 53.900228 27.564707 0.19;
bin/getPaginatedPlexts.sh
  #scp response/getPaginatedPlexts root@thesuki.org:/tmp/
  cp response/getPaginatedPlexts /tmp/
  bin/getminskbyguids.sh
  #ssh root@thesuki.org 'cat /tmp/getObjectsInCells > /tmp/getObjectsInCells.prev'
  #scp response/getObjectsInCells root@thesuki.org:/tmp/;
  cat /tmp/getObjectsInCells > /tmp/getObjectsInCells.prev
  cp response/getObjectsInCells /tmp/
  /var/www/thesuki.org/ingress/iitc-post/run.sh
  /var/www/thesuki.org/ingress/stats/00runstats.sh
  /var/www/thesuki.org/ingress/stats/minskintel/00.mkminskmap_g.sh
  bin/generatealienmap.sh;
  bin/generateresistancemap.sh;
  bin/generateresistanceshieldmap.sh;
  bin/generateresistancechargemap.sh; 
  bin/generaterechargeguids.sh;
  bin/generatecenter.sh;
  sleep 10
done
