#!/bin/bash

curl -s 'http://www.namestation.com/services/DomainService.asmx/DoDomainSearch' -H 'Origin: http://www.namestation.com' -H 'Accept-Encoding: gzip,deflate' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.101 Safari/537.36' -H 'Content-Type: application/json; charset=UTF-8' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: http://www.namestation.com/domain-search/random?autosearch=1' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data-binary '{"request":{"Extension":".com","SearchType":"Random","sMin":"6","sMax":"12","keyword":"","keyword2":"","LanguageID":"45"}}' --compressed | json_xs | grep -o -P '"d" : "[a-z]*.com"' | sed 's|"d" : "||' > nicknames.txt
for i in `cat nicknames.txt | grep -o -P "^[a-z]*"`; do
	let A=$RANDOM%2
	if [ "$A" == "1" ]; then
		echo "${i^}"
	else
		echo "${i}"
	fi
done
