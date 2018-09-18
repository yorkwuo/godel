#!/bin/csh -f
echo $1 | sed 's/file:\/\/\/C:/\/cygdrive\/c/' > ~/.tmp
set pp=`cat ~/.tmp`
echo "cd `dirname $pp`"

