#!/bin/bash
bin/generateportalslistfromcells.pl response/getObjectsInCells |grep -E "RESISTANCE,.,1" |awk -F, '{if ($1>53.83 && $1<53.96 && $2>27.4 && $2<27.72) {print $0} }'  |awk -F, '{print $1","$2",60,"$3}' > maps/resistancerechargelatest.txt
