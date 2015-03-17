#!/bin/bash
cd /opt/intelbot/intel
bin/updatemungs.sh
LASTCOMMDATE=`mysql ingress -e "select msgts from syscomm order by msgts desc limit 1;"|grep -v msgts`;
#LASTCOMMDATE=`date -d '3 hours ago' +%s`
NOWDATE=`date +%s`
echo last comm is $LASTCOMMDATE
echo now is $NOWDATE
/opt/intelbot/intel/bin/getPaginatedPlexts.sh  -n 5000   -m $LASTCOMMDATE   -M $NOWDATE -c all 53681128 26685855 54085853 28482120
bin/concantenateplexts.pl  > plext
/opt/intelbot/intel/bin/comm2sql.pl < plext  |sed -e 's/ENLIGHTENED/ALIENS/g' > plext.sql
mysql ingress < plext.sql
