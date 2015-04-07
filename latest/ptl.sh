#!/bin/sh
CAPSULEID=$1
bin/proposetodrop.sh |sed -e 's/dropdrop.sh/loadContainer.sh/g'|awk -v "capsuleid=$CAPSULEID" '{print $0, capsuleid}'
