
source $env(GODEL_ROOT)/bin/godel.tcl


#catch {exec xdotool getwindowfocus} wid

gtcl_commit

exec godel_draw.tcl
#catch {exec xdotool key ctrl+r $wid}
catch {exec xdotool search --name "Mozilla" key ctrl+r}

