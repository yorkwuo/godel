source $env(GODEL_ROOT)/bin/godel.tcl

catch {exec xdotool getwindowfocus} wid

newgpage

exec godel_draw.tcl
catch {exec xdotool key ctrl+r $wid}


