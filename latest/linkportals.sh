#!/bin/bash
. bin/func.inc

PORTAL1=$1
PORTAL2=$2

# Find key

K1C=`cat inventory.txt | grep -c -F "$PORTAL1"`
K2C=`cat inventory.txt | grep -c -F "$PORTAL2"`

if [ "$K2C" -gt "$K1C" ]; then
	# Link from Portal1
	echo "" > /dev/null
fi


KEY1=`cat inventory.txt | grep -F "$PORTAL1"`
KEY2=`cat inventory.txt | grep -F "$PORTAL2"`

if [ "$KEY1" != "" ]; then
	# Move to Portal2 position
	SOURCE=`cat maps/*.txt | grep -F "$PORTAL2" | head -n1`
	DEST=`cat maps/*.txt | grep -F "$PORTAL1" | head -n1`
	KEY="$KEY1"
fi

if [ "$KEY2" != "" ]; then
	# Move to Portal1 position
	SOURCE=`cat maps/*.txt | grep -F "$PORTAL1" | head -n1`
	DEST=`cat maps/*.txt | grep -F "$PORTAL2" | head -n1`
	KEY="$KEY2"
fi

if [ "$KEY" == "" ]; then
	echo "No available key"
	exit 1
fi

if [ "$SOURCE" == "" ]; then
	echo "Couldn\'t find source portal"
	exit 1
fi

if [ "$DEST" == "" ]; then
	echo "Couldn\'t find destination portal"
	exit 1
fi

KEYID=`echo $KEY | cut -d , -f 3`
LAT=`echo $SOURCE | cut -d , -f 1`
LON=`echo $SOURCE | cut -d , -f 2`
SRCID=`echo $SOURCE | cut -d , -f 4`
DSTID=`echo $DEST | cut -d , -f 4`

echo KEY: $KEYID
echo POS: $LAT , $LON
echo SOURCE: $SRCID
echo DESTINATION $DSTID

LINKING=`./bin/getLinkabilityImpediment.sh $LAT $LON $KEYID $SRCID`
cat response/getLinkabilityImpediment |json_xs|grep -E "[0-9a-z]{32}.5"|cut -d: -f2
if [ "$LINKING" == "" ]; then
        echo "linking possible"
	./bin/createLink.sh $LAT $LON $KEYID $SRCID $DSTID
        cat response/createLink |json_xs|grep apTrigger
	./bin/removefrominv.sh $KEYID
fi






