#!/bin/bash
. bin/func.inc
bin/showinv.sh |awk '{print "./bin/recycleall.sh",$2,$1}'|tr "," " "
