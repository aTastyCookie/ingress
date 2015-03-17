#!/bin/bash
. bin/func.inc
die () {
    echo >&2 "$@"
    exit 1
}

faction=$1
[ "$#" -eq 1 ] || die "1 arguments required, $# provided, synopsys: $0 ALIENS|RESISTANCE"
echo $1 | grep -E -q '^RESISTANCE$|^ALIENS$' || die "synopsys: $0 ALIENS|RESISTANCE"
if [ -f error.lock ]; then
  echo "error.lock is present, i will not continue"
  exit 1
fi
echo "{\"params\":[\"$faction\"]}" > payload
./bin/postapiUndecorated.sh chooseFaction
sleep 5
