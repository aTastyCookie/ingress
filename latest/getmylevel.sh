#!/bin/bash
. bin/func.inc
X=`cat ap.txt`
if ((0<=X && X<=2499))
then
    echo "1"
elif ((2500<=X && X<=19999))
then
    echo "2"
elif ((20000<=X && X<=69999))
then
    echo "3"
elif ((70000<=X && X<=149999))
then
    echo "4"
elif ((150000<=X && X<=299999))
then
    echo "5"
elif ((300000<=X && X<=599999))
then
    echo "6"
elif ((600000<=X && X<=1199999))
then
    echo "7"
elif ((1200000<=X && X<=100000000))
then
    echo "8"
else
    echo "error"
fi

