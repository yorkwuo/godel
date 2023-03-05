#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set dirname [clock format [clock seconds] -format {%Y-%m-%d_%H-%M_%S}]

file mkdir $dirname
godel_draw $dirname
lsetvar $dirname g:pagename ""

godel_draw

exec xdotool search --name "Mozilla" key ctrl+r
