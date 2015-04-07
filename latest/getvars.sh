#!/bin/sh
. bin/func.inc
mitmdump -r $1.dump.0 "~m post" 2>/dev/null -v|grep " Cookie: SACSID"|tail -n 1|cut -d: -f2|tr -d " " > cookie.txt
mitmdump -r $1.dump.0 "~m post"  2>/dev/null -v|grep "X-XsrfToken"|tail -n 1|cut -d: -f2,3|tr -d " "  > csrftoken.txt
mitmdump -r $1.dump.0 "~m post" 2>/dev/null -v|grep "X-XsrfToken"|tail -n 1|cut -d: -f3|tr -d " "     > knobsyncts.txt

