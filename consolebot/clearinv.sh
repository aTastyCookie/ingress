#!/bin/bash
bin/proposetorecycle.sh |grep -E "EMITTER_A [1-7]|EMP_BURSTER [1-7]|KEY|MEDIA|POWER_CUBE [1-7]|ULTRA_STRIKE [1-7]|FORCE_AMP|TURRET|LINK_AMPLIFIER 2000|MULTIHACK 4| HEATSINK 2|RES_SHIELD 35"|sh
#R=`cat inventory.txt | grep EMITTER_A,8 -c`;
#if [ $R -gt 200 ]; then
#./bin/recycleall.sh EMITTER_A 8 200;
#fi
#X=`cat inventory.txt | grep CAPS -c`;
#if [ $X -gt 1 ];
#then
#let Y=$X-1;
#bin/multidrop.sh CAPSULE RARE $Y
#fi
