#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

exec rm -rf */

file mkdir foo bar
exec godel_draw.tcl foo
exec godel_draw.tcl bar

godel_draw
