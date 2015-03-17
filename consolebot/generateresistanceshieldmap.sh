#!/bin/bash
bin/generateportalslistfromcells.pl response/getObjectsInCells |grep -E "RESISTANCE,[0-3]" |awk -F, '{if ($1>53.83 && $1<53.983 && $2>27.4 && $2<27.7) {print $0} }'  |awk -F, '{print $1","$2",60,"$3}' > maps/resistanceshieldlatest.txt
#bin/generateportalslistfromcells.pl response/getObjectsInCells |grep ALIENS |awk -F, '{if ($1>53.88 && $1<53.93 && $2>27.5 && $2<27.64) {print $0} }' |awk -F, '{print $1","$2",60,"$3}' > maps/alienlatest.txt
