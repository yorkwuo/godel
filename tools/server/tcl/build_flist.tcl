
source $env(GODEL_ROOT)/bin/godel.tcl

build_flist

exec godel_draw.tcl
exec xdotool search --name "Mozilla" key ctrl+r


