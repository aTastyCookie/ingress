#!/bin/sh
bin/distance.pl `head -n 1 cur.txt |cut -d, -f1,2` `head -n 1 map.war.txt |cut -d, -f1,2`
