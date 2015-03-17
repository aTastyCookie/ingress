#!/bin/bash
cd ~/mitm
mkdir $1 
cd $1
ln -s ../bin bin
ln -s ../maps maps
mkdir response
echo $2 > config.ini
echo $3 >> config.ini
echo visiblelevel=1 >> config.ini
cp bin/proxy.cfg ./
cp maps/m1.txt cur.txt
cp bin/config.inc ./
screen -S $1
