#!/bin/sh
while true; do
for i in `seq 1 40`;do
cp maps/checklater.payload.gz payload.gz ;
cp maps/j.payload.gz payload.gz
bin/postapi.sh getObjectsInCells ; 
cat response/getObjectsInCells|json_xs |grep -oE "\"[0-9a-z]{32}.6\"," > xmguids.txt
cat > maps/p << _EOF
{
     "params" : {
           "energyGlobGuids" : [
_EOF
cat xmguids.txt >>  maps/p
cat maps/xmguids  |sort -R|head -n 50 >> maps/p
echo '"46dbcfb736b00000000871b10000002a.6"' >> maps/p
cat >> maps/p << _EOF
      ],
      "knobSyncTimestamp" : "0",
      "cells" : null,
      "clientBasket" : {
         "clientBlob" : null
      },
      "dates" : [
      ],
      "playerLocation" : "00000000,00000000",
      "cellsAsHex" : [
      ]
   }
}
_EOF
sleep 1800
done
done
           
