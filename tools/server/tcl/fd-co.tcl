#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

exec gget . fdiff co

exec godel_draw.tcl
catch {exec xdotool search --name "Mozilla" key ctrl+r}

