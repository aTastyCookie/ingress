#!/bin/sh
cat bf.header > $1.html
cat portals.html.temp >> $1.html
cat links.html.temp >> $1.html 
cat bf.footer >> $1.html
