#!/bin/sh
bin/generateportalslistfromcells.pl response/getObjectsInCells  |awk -F, '{if ($1>53.87 && $1<53.915 && $2>27.535 && $2<27.60) {print $0} }' |awk -F, '{print $1","$2",60,"$3}' > maps/center.txt
