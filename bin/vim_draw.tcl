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

puts $pp

cd $pp

exec godel_draw.tcl

catch {exec xdotool search --name "Mozilla" key ctrl+r}
