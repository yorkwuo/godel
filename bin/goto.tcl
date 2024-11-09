#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

exec xdotool search --name "Mozilla" windowactivate --sync key Alt+d
after 100
exec xdotool key Ctrl+c
after 100
#exec xdotool key Tab

catch {exec xclip -o} pp

regsub {file:\/\/} $pp {} pp
set pp [file dirname $pp]

set cmd "cd $pp"

exec echo $cmd | xclip &


