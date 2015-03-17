#!/bin/sh
. bin/func.inc

DEFAULT_TIME=600
DEFAULT_HACK_TYPE="hacknr"
DEFAULT_LOOP_COUNT=999
POS_TO_DROP_GOOD=""
POS_TO_DROP_BAD=""
if [ -z "$2" ] || [ "$2" -lt "1" ]; then
  	echo "Usage: $0 <loop count> <time in sec> <hack type>" >&2
	
	#if not set by param or ini file let the default time to initial start position takes 10 min ...
	PAUSE_BETWEEN_NEXT_TURN=$DEFAULT_TIME
else
	PAUSE_BETWEEN_NEXT_TURN=$2
fi

if [ -z "$3" ]; then
	HACK_TYPE=$DEFAULT_HACK_TYPE
else
	HACK_TYPE=$3
fi
if [ -z "$1" ]; then
	LOOP_COUNT=$DEFAULT_LOOP_COUNT
else
	LOOP_COUNT=$1
fi



echo "Loop time set: $PAUSE_BETWEEN_NEXT_TURN, hack type set to: $HACK_TYPE , LOOPS: $LOOP_COUNT" 
 

echo "while [ LOOP_COUNT -gt 0 ]; do bin/auth.sh; bin/$HACK_TYPE.sh map.txt ;sleep $PAUSE_BETWEEN_NEXT_TURN; LOOP_COUNT=LOOP_COUNT-1; done"

#map.txt must be symbolic link or file in bot home dir.

#while [ 1 ]; do bin/auth.sh; bin/$HACK_TYPE.sh map.txt ;   sleep $PAUSE_BETWEEN_NEXT_TURN; done
#while [ LOOP_COUNT -gt 0 ]; do bin/auth.sh; bin/$HACK_TYPE.sh map.txt ;sleep $PAUSE_BETWEEN_NEXT_TURN; LOOP_COUNT=LOOP_COUNT-1; done
while [ $LOOP_COUNT -gt 0 ]; do echo "Going loop: $LOOP_COUNT";bin/auth.sh; bin/$HACK_TYPE.sh map.txt ;sleep $PAUSE_BETWEEN_NEXT_TURN; LOOP_COUNT=`expr $LOOP_COUNT - 1`; done
