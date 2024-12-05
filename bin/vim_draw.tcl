#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

if [info exist env(GONSOLE)] {
  set title [lvars $env(GONSOLE) firefox_title]
} else {
  set title NA
}
puts $title
if {$title eq "NA" || $title eq ""} {
  exec xdotool search --name "Mozilla" windowactivate --sync key Alt+d
} else {
  exec xdotool search --name "$title.*Moz" windowactivate --sync key Alt+d
}
after 100
exec xdotool key Ctrl+c
after 100
exec xdotool key F6

catch {exec xclip -o} pp
puts $pp

regsub {file:\/\/} $pp {} pp
set pp [file dirname $pp]

puts $pp

cd $pp

exec godel_draw.tcl

catch {exec xdotool search --name "Mozilla" key ctrl+r}
