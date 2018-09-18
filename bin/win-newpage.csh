#!/bin/tcsh
set pp = `cat /dev/clipboard`
cd `cygpath -u $pp`
newpage .
#eval `cat /dev/clipboard`
echo "Press Enter...:"
set input = $<
