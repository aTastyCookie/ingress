#!/bin/sh
. bin/func.inc

./bin/remoteRechargeAllMaps.sh 10

for i in `seq 1 4`; do
        echo > /dev/null
	#./bin/recycle_limit.sh 30
	#./bin/remoteRechargeAllMaps.sh 10
done

./bin/proposetodrop.sh |grep -E "EMITTER_A [1-3]|EMP_BURSTER [1-5]|RES_SHIELD 10|KEY|MEDIA"|sh
