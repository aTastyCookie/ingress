#!/bin/bash
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}

if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  exit 1
fi
bin/getInviteInfo.sh
NUMINVITES=`cat response/getInviteInfo |json_xs |grep numAvailableInvites|cut -d: -f2|awk '{print $1}'`
if [ "$NUMINVITES" -gt "0" ]; then
  echo "you have invites, I will try to recuiit new bots"
  NUMPOOLUNINV=`wc -l ../pooluninvited.csv|awk '{print $1}'`
  if [ "$NUMPOOLUNINV" -gt "0" ]; then
    echo "you have uninvited bots, I will try to invite them"
    NICK=`head -n 1 ../pooluninvited.csv|cut -d, -f1`
    EMAIL=`head -n 1 ../pooluninvited.csv|cut -d, -f2`
    PASS=`head -n 1 ../pooluninvited.csv|cut -d, -f3`
    echo "inviting $NICK $EMAIL $PASS"
    bin/inviteViaEmail.sh $EMAIL
    sed -i "/$NICK/d" ../pooluninvited.csv
    echo "$NICK,$EMAIL,$PASS" >> ../pool.csv
  else
    echo "there are no bots in invite pool left"
    echo "there are no bots in invite pool left"|mail -s botmaster_error valery.tereshko@gmail.com
    exit 1
  fi

else
  echo "error, numinvites: $NUMINVITES"
  exit 1
fi
