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
if [ "$mylevel" = "" ]; then
	mylevel=`bin/getmylevel.sh`
fi
[ "$#" -eq 3 ] || [ "$#" -eq 4 ] || die "3 arguments required, $# provided, synopsys: $0 LAT LON PGUID [Max burster]"
./bin/getModifiedEntitiesByGuid.sh $1 $2 $PGUID
./bin/getObjectsInCells.checkrecharge.pl response/getModifiedEntitiesByGuid $PGUID|grep -E "RESIS|NEUTR"
if [ "$?" -eq "0" ]; then
  echo "this is my portal, will not try to destroy it"
  exit 0
fi

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
      echo $PGUID
      ./bin/fireUntargetedRadialWeapon.sh $LAT $LON $itemid $PGUID
#      ./bin/getObjectsInCellsa.sh $LAT $LON
      cat maps/p|gzip > payload.gz ; ./bin/postapi.sh getObjectsInCells      
      ./bin/fireUntargetedRadialWeapon.parse.pl response/fireUntargetedRadialWeaponV2  $PGUID
      EXITCODE=$?
      echo exitcode was $exitcode
	else
		echo "Can't find L$mylevel or lower bursters"
		exit
    fi
done
