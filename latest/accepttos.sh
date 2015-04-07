#!/bin/bash
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}

useragent="Nemesis (gzip)"
cookie=`cat cookie.txt|tr -d "\r\n"`

#RL="https://m-dot-betaspike.appspot.com/handshake?json=%7B%22nemesisSoftwareVersion%22%3A%222013-06-07T16%3A49%3A41Z+63e36378f5e8+opt%22%2C%22deviceSoftwareVersion%22%3A%224.2%22%2C%22tosAccepted%22%3A%221%22%7D"
#RL="https://m-dot-betaspike.appspot.com/handshake?json=%7B%22nemesisSoftwareVersion%22%3A%222013-06-28T23%3A28%3A27Z+760a7a8ffc90+opt%22%2C%22deviceSoftwareVersion%22%3A%224.2%22%2C%22tosAccepted%22%3A%221%22%7D"
#RL="https://m-dot-betaspike.appspot.com/handshake?json=%7B%22nemesisSoftwareVersion%22%3A%222013-07-29T18%3A57%3A27Z+7af0d9a744b7+opt%22%2C%22deviceSoftwareVersion%22%3A%224.2%22%2C%22tosAccepted%22%3A%221%22%7D"
#RL="https://m-dot-betaspike.appspot.com/handshake?json=%7B%22nemesisSoftwareVersion%22%3A%222013-08-07T00%3A06%3A39Z+a52083df5202+opt%22%2C%22deviceSoftwareVersion%22%3A%224.2%22%2C%22tosAccepted%22%3A%221%22%7D"
URL="https://m-dot-betaspike.appspot.com/handshake?json=%7B%22nemesisSoftwareVersion%22%3A%22$VERSION+opt%22%2C%22deviceSoftwareVersion%22%3A%224.2%22%2C%22tosAccepted%22%3A%221%22%7D"
PROXY=`cat proxy.cfg 2>/dev/null | tr -d "\n" | sed 's|[#;].*||'`
curl $PROXY -k -D curlheaders.txt  -A "$useragent" -X GET \
        -H "Cookie:$cookie" \
        -H "Content-Type:application/json;charset=UTF-8" \
        -H "Accept-Encoding:gzip"  $URL |gunzip > response/handshake


cat curlheaders.txt |grep -qE "HTTP/1.1 200 OK"
if [ "$?" -eq "1" ]; then
  echo "something wrong with handshake" > error.lock
fi
if [ "$?" -eq "0" ]; then 
  echo 200, login ok, proceeding to gettoken
fi
sed -i -e 's/while(1);//g' response/handshake
tail -n 1 response/handshake > response/handshake.tmp
mv response/handshake.tmp response/handshake
cat response/handshake |json_xs |grep xsrf|cut -d: -f2,3|awk -F\" '{print $2}' > csrftoken.txt
cat response/handshake |json_xs |grep xsrf|cut -d: -f2,3|awk -F\" '{print $2}'|cut -d: -f2 > knobsyncts.txt 
STATUS=`cat response/handshake|json_xs |grep -E '"action"'|cut -d: -f2|tr -d '",'|awk '{print $1}'`
sleep 5
if [ "$STATUS" == "NO_ACTIONS_REQUIRED" ]; then 
  echo "please validate your nickname - bin/validateNickname.sh NICKNAME"
  exit 0
fi

if [ "$STATUS" == "USER_REQUIRES_ACTIVATION" ]; then
  echo "your account requires activation"
  echo "please get activation code and run bin/activate.sh CODE"
  exit 1
fi

if [ "$STATUS" == "USER_MUST_ACCEPT_TOS" ]; then
  echo "your account must accept TOS"
  echo "please run bin/accepttos.sh"
  exit 1
fi

