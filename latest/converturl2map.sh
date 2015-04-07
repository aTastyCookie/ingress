#!/bin/sh
echo "$1"|tr "&" "="|cut -d= -f2,4,8|awk -F= '{print $1","$2",3,"$3}'
