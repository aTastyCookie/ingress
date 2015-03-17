#!/bin/sh
. bin/func.inc

DEFAULT_TIME=3600
DEFAULT_DROP_TYPE="EMITTER_A\ [1-7]|BURSTER\ [1-7]|KEY|SHIELD\ [1-2]"

if [ -z "$1" ] || [ "$1" -lt "10" ]; then
  	echo "Usage: $0 <time in sec> <hack type>" >&2
	
	#if not set by param or ini file let the default time to initial start position takes 10 min ...
	PAUSE_BETWEEN_NEXT_TURN=$DEFAULT_TIME
else
	PAUSE_BETWEEN_NEXT_TURN=$1
fi

if [ -z "$2" ]; then
	DROP_TYPE=$DEFAULT_DROP_TYPE
else
	DROP_TYPE=$2
fi

echo "Loop time set: $PAUSE_BETWEEN_NEXT_TURN, hack type set to: $DROP_TYPE" 
 


cat << FIGNIA

 while [ 1 ]; do  sleep "$PAUSE_BETWEEN_NEXT_TURN"; proposetorecycle.sh | grep -E "$DROP_TYPE" | sh; done
FIGNIA

while [ 1 ]; do proposetorecycle.sh | grep -E "$DROP_TYPE" | sh; sleep $PAUSE_BETWEEN_NEXT_TURN; done

