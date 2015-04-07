#!/bin/sh
. bin/func.inc
#(c)2013, Helicopter club INC
sed 's/\[\"\([a-z0-9.]*\).*\"level\"\:\([0-9]\).*resourceType\"\:\"\([A-Z_]*\)\".*/\3,\2,\1/g' hack.log | sed 's/\[\"\([a-z0-9.]*\).*resourceType\"\:\"\([A-Z_]*\)\".*/\2,0,\1/g' | sort -u
#sed 's/\[\"\([a-z0-9]*\.[0-9]\).*\"level\"\:\([0-9]\).*resourceType\"\:\"\([A-Z_]*\)\".*/\3,\2,\1/g' hack.log | sed 's/\[\"\([a-z0-9]*\.[0-9]\).*resourceType\"\:\"\([A-Z_]*\)\".*/\2,0,\1/g' | sort -u
#sed 's/\[\"\([[:alpha:][:digit:]]*\.[[:digit:]]\).*\"level\"\:\([0-9]\).*resourceType\"\:\"\([A-Z_]*\)\".*/\3,\2,\1/g' hack.log | sed 's/\[\"\([[:alpha:][:digit:]]*\.[[:digit:]]\).*resourceType\"\:\"\([A-Z_]*\)\".*/\2,0,\1/g' | sort -u

