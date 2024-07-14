
source $env(GODEL_ROOT)/bin/godel.tcl

new_link

exec godel_draw.tcl
exec xdotool search --name "Mozilla" key ctrl+r
