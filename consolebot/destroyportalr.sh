#!/bin/sh
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}
LAT=$1
LON=$2
PGUID=$3
mylevel=$4
X=`cat ap.txt`
LTXT=`cat lvl.txt`
if [ $X -ge 70000 ]  && [ $LTXT -lt 4 ]; then
echo "4">lvl.txt;
bin/verifyLevelUp.sh 53.896226 25.289063 4;
bin/getinventory.sh;
fi
if [ $X -ge 150000 ] && [ $LTXT -lt 5 ]; then
echo "5">lvl.txt;
bin/verifyLevelUp.sh 53.896226 25.289063 5;
bin/getinventory.sh;
fi
if [ $X -ge 300000 ] && [ $LTXT -lt 6 ]; then
echo "6">lvl.txt;
bin/verifyLevelUp.sh 53.896226 25.289063 6;
bin/getinventory.sh;
fi
echo $X

if [ "$mylevel" = "" ]; then
	mylevel=`bin/getmylevel.sh`
fi
[ "$#" -eq 3 ] || [ "$#" -eq 4 ] || die "3 arguments required, $# provided, synopsys: $0 LAT LON PGUID [Max burster]"

./bin/getModifiedEntitiesByGuid.sh $LAT $LON $PGUID
./bin/getObjectsInCells.checkrecharge.pl response/getModifiedEntitiesByGuid $PGUID | grep -E "ENL|NEU"

#./bin/getObjectsInCells.checkrecharge.pl response/getObjectsInCells.0 $PGUID|grep -E "RESISTANCE"
if [ "$?" -eq "0" ]; then
  echo "this is my portal, will not try to destroy it"
  exit 0
fi
#./bin/getObjectsInCells.checkrecharge.pl response/getObjectsInCells.0 $PGUID|grep NEUTRAL
#if [ "$?" -eq "0" ]; then
#  echo "this is neutral portal, will not try to destroy it"
#  exit 0
#fi

if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  exit 1
fi
EXITCODE=2
while [ $EXITCODE -eq 2 ]
do
    itemid=`cat inventory.txt |grep EMP_BURSTER,[1-$mylevel]|sort -rk 2|head -n 1|cut -d, -f3`
    echo $itemid|grep -qE "[a-z0-9]{32}.5"
    if [ "$?" -eq "0" ]; then
      ./bin/fireUntargetedRadialWeapon.sh $LAT $LON $itemid $PGUID
#      ./bin/getObjectsInCellsa.sh $LAT $LON
      cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells
      ./bin/fireUntargetedRadialWeapon.parse.pl response/fireUntargetedRadialWeaponV2  $PGUID
      EXITCODE=$?
	else
		echo "Can't find L$mylevel or lower bursters, try to find it's on ground."
                bin/multipickupcustoml.sh .;
                bin/unlcaps.sh;
		bin/getinventory.sh;
		exit
    fi
done
