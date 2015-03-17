#!/bin/bash
. bin/func.inc
bin/showinv.sh |awk '{print "./bin/recall.sh",$2,$1}'|tr "," " "
