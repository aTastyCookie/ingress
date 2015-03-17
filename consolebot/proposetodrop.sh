#!/bin/bash
. bin/func.inc
./bin/proposetorecycle.sh|sed -e 's/recycleall/dropdrop/g'
