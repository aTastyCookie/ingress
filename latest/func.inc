#xport VERSION="2014-09-02T18%3A01%3A11Z+09329a540fb0"
#xport VERSION="2014-09-23T00%3A03%3A38Z+3cfbf841cae4"
#xport VERSION="2014-09-30T18%3A10%3A49Z+8c0548b9de8d"
#xport VERSION="2014-10-14T18%3A14%3A33Z+babf119d0803"
#xport VERSION="2014-10-28T18%3A27%3A31Z+0d729eee8629"
#xport VERSION="2014-11-14T07%3A17%3A32Z+e48a76fc0b27"
#xport VERSION="2014-11-25T19%3A22%3A37Z+6522e66c7180"
#xport VERSION="2014-12-16T07%3A21%3A08Z+1555dd99cd68"
#xport VERSION="2015-01-06T18%3A45%3A04Z+52c12c62918a"
#xport VERSION="2015-01-21T23%3A05%3A34Z+48372ede06a1"
#xport VERSION="2015-01-29T22%3A00%3A19Z+6408e4e1cbe6"
#xport VERSION="2015-02-03T19%3A25%3A11Z+d55cbcbb6869"
#xport VERSION="2015-02-20T23%3A44%3A16Z+ac501401a6f3"
#xport VERSION="2015-03-10T03%3A50%3A13Z+e569fd3dc54e"
export VERSION="2015-03-20T23%3A08%3A38Z+533734b10f19"
HEXE6 () {
 printf %08x $1|sed -e 's/ffffffff//g'
}
INNERJOIN () {
 cat $1  > join.left
 cat $2  > join.right
 cat $1 > tmp.tmp.tmp
 cat join.left join.right |sort -n|uniq -c|sort -n|awk '{if ($1==2) print "cat join.left|grep",$2}' |sh > innerjoin
 rm -f join.left join.right
}

LEFTJOIN () {
 cat $1  > join.left
 cat $2  > join.right
 cat $1 > tmp.tmp.tmp
 cat join.left join.left  join.right |sort -n|uniq -c|sort -n|awk '{if ($1==2) print "cat join.left|grep",$2}' |sh > leftjoin
 rm -f join.left join.right
}

