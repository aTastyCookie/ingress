#!/bin/bash
. bin/func.inc
  PROXYIP=`cat proxy.cfg|grep -v -P "^;"|awk '{print $2}'`
  python bin/auth.py $PROXYIP;
  sleep 2
  ./bin/auth2.sh
  sleep 2
  ./bin/auth3.sh
  sleep 2
  grep -q Disabled response/ahlogin
  if [ "$?" -eq "0" ]; then
    echo Disabled
    echo Disabled > error.lock
    sleep 3
    kill -9 `ps --pid $$ -oppid=`; exit
  fi
  #./bin/getinventory.sh
