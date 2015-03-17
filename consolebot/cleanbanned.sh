#!/bin/sh
find . -maxdepth 2 -name error.lock|xargs grep banned|cut -d\/ -f2|awk '{print "mv",$1,"banned/"}'|sh
