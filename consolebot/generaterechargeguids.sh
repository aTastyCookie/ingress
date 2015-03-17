#!/bin/bash
bin/generateportalslistfromcells.pl response/getObjectsInCells |grep -E "RESISTANCE,.,1"|cut -d, -f3 > maps/rechargeguids.txt
