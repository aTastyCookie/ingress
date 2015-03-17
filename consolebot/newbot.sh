#!/bin/bash
#$1 - faction R - RES|A - ALIEN
#$2 - type 1 - simple bot, 2- charge,3-shield, 4 -farm. 5-zerg, 6- manabot 7- kill minsk, 8 charge_by ,11 charge brst_work
#$3 - reserved
cd ~/mitm
if [ -e newbot.lock ]; then
  MOD=`stat -c %Y newbot.lock`
  CURRENT=`date +%s`
  let DIFF=$CURRENT-$MOD
  if [ "$DIFF" -lt "3600" ]; then
    echo "another bot is creating right now, try later"
    exit 1
  fi
fi
touch newbot.lock
PX=`cat proxy_http_ip.txt |sort -R|head -n 1`;  
python bin/create_gmail_accV2.py $PX ;
echo "-x $PX" > bin/proxy.cfg;
touch counter 
COUNT=`cat counter`
echo $COUNT|grep -qE "[0-9]+"
if [ "$?" -eq "1" ]; 
 then echo will start from 1
 COUNT=0
fi
let COUNT=COUNT+1
echo $COUNT > counter
echo $COUNT
NAME=`head -n 1 pool.csv|cut -d, -f1`
MAIL=`head -n 1 pool.csv|cut -d, -f2`
PASS=`head -n 1 pool.csv|cut -d, -f3`
if [ "$2" -eq "1" ]; then
TYPE="gen";
echo $TYPE;
elif [ "$2" -eq "2" ]; then
TYPE="charge_minsk";
elif  [ "$2" -eq "3" ]; then
TYPE="shield_minsk";
elif  [ "$2" -eq "4" ]; then
TYPE="farm";
elif  [ "$2" -eq "5" ]; then
TYPE="ZERG";
elif  [ "$2" -eq "6" ]; then
TYPE="MANABOT";
elif  [ "$2" -eq "7" ]; then
TYPE="kill";
elif  [ "$2" -eq "8" ]; then
TYPE="charge_by";
elif [ "$2" -eq "9" ]; then
TYPE="charge_srb"
elif [ "$2" -eq "10" ]; then
TYPE="charge_kolasa"
elif [ "$2" -eq "11" ]; then
TYPE="charge_brstwrk"
elif [ "$2" -eq "12" ]; then 
TYPE="playerstat"
elif [ "$2" -eq "13" ]; then
TYPE="hotpukan"
fi

#NICKNAME=`bin/nicknames.sh | head -n 1`
###sed -i "/$NICKAME/d" nickpool.csv
#echo $NICKNAME|grep -E "[a-z]"
#if [ "$?" -eq "0" ]; then
#  echo "nickname found, will use it"
#  NAME=$NICKNAME
#fi
if [ "$1" -eq "1" ]; then
FACTION="RESISTANCE";
echo $FACTION;
elif [ "$1" -eq "2" ]; then
FACTION="ALIENS";
ECHO $FACTION;
fi

. bin/func.inc
  echo "Creating bot NAME:$NAME MAIL:$MAIL PASS:$PASS CODE:$CODE"
  mkdir $1.$TYPE.$COUNT.$NAME
  cd $1.$TYPE.$COUNT.$NAME
  ln -s ../bin ./bin
  ln -s ../maps ./maps
  ln -s ../drop ./drop
  mkdir response 
  cp bin/config.inc ./
  printf "$MAIL\n$PASS\n"  > config.ini
  echo "visiblelevel=1" >> config.ini
  echo "numitemslimit=1995" >> config.ini
  echo "3">lvl.txt
cat << _EOF > .fetchmailrc
    poll pop.gmail.com
    protocol pop3
    user ${MAIL}
    pass $PASS
    mda "/usr/bin/procmail -m ~/mitm/$COUNT.$NAME/.procmailrc"
_EOF
chmod 600 ~/mitm/$1.$TYPE.$COUNT.$NAME/.fetchmailrc
cat << _EOF > .procmailrc
  :0
  ~/mitm/$1.$TYPE.$COUNT.$NAME/mbox
_EOF
#  fetchmail  --ssl --fetchmailrc ~/mitm/$1.$TYPE.$COUNT.$NAME/.fetchmailrc
#  CODE=`cat mbox |grep -A1 -E "Logo ACTIVATION CODE"|tail -n 1`
#  echo found code $CODE
 
  cat bin/proxy.cfg >  proxy.cfg
  bin/auth.sh
  bin/activate.sh $CODE
  bin/accepttos.sh
  ./bin/intelauth2.sh                                                                                                                                                                      
  ./bin/intelauth3.sh                                                                                                                                                                      
  ./bin/intelauth4.sh         
  scp cookiemap.txt root@185.66.70.13:/opt/intelbot/intel/
  scp csrftokenmap.txt root@185.66.70.13:/opt/intelbot/intel/
  rm error.lock
#  bin/validateNickname.sh $NAME
#  bin/persistNickname.sh $NAME
  bin/putBulkPlayerStorage.sh
  bin/chooseFaction.sh $FACTION
  bin/getinventory.sh
  bin/getplayerstats.sh
  cp maps/m1.txt cur.txt
  bin/getPaginatedPlexts.sh
#  bin/ratemissionbulk.sh
  cd ..
  echo "bot $NAME created"
  rm -f newbot.lock
  sed -i "/$NAME/d" pool.csv
  cd $1.$TYPE.$COUNT.$NAME
  if [ "$2" -eq "1" ];then
    cp maps/m1.txt cur.txt
    screen -S $1.$TYPE.$COUNT.$NAME
  elif [ "$2" -eq "2" ]; then
    screen -mdS $1.$TYPE.$COUNT.$NAME bash --init-file bin/start_minsk_nonstop_charge
  elif [ "$2" -eq "3" ]; then
    bin/persistNickname.sh "axaxa${RANDOM}"
    screen -mdS $1.$TYPE.$COUNT.$NAME bash --init-file bin/start_minsk_nonstop_shield
  elif [ "$2" -eq "4" ]; then
    screen -S $1.$TYPE.$COUNT.$NAME 
  elif [ "$2" -eq "5" ]; then
    screen -mdS $1.$TYPE.$COUNT.$NAME bash --init-file bin/start_mnhnz.sh
  elif [ "$2" -eq "6" ]; then
    pkill -9 -f MANABOT
    screen -mdS $1.$TYPE.$COUNT.$NAME bash --init-file bin/makexm.sh
  elif  [ "$2" -eq "7" ]; then
    screen -mdS minsk.killg.$COUNT.$NAME bash --init-file bin/start_minsk_nonstop_kill_gonly
  elif  [ "$2" -eq "8" ]; then
    screen -mdS $1.$TYPE.$COUNT.$NAME bash --init-file bin/start_by_nonstop_charge
  elif  [ "$2" -eq "9" ]; then
    screen -mdS $1.$TYPE.$COUNT.$NAME bash --init-file bin/start_minsk_nonstop_charge_srbr
  elif  [ "$2" -eq "10" ]; then
    screen -mdS $1.$TYPE.$COUNT.$NAME bash --init-file bin/start_minsk_nonstop_charge_kolasa
  elif  [ "$2" -eq "11" ]; then
    screen -mdS "$1.$TYPE.$COUNT.$NAME" bash --init-file bin/brest_charge_wrk.sh
  elif  [ "$2" -eq "12" ]; then
    screen -mdS "$1.$TYPE.$COUNT.$NAME" bash --init-file bin/getplayerstats.sh
  elif  [ "$2" -eq "13" ]; then
    echo $3 > pukanseq.txt
    screen -mdS "$1.$TYPE.$COUNT.$NAME" bash --init-file bin/hotpukan.sh
  fi
  echo bot $1.$TYPE.$COUNT.$NAME started, type screen -r $1.$TYPE.$COUNT.$NAME to enter it
  exit 0 

