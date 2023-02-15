#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set dirname [clock format [clock seconds] -format {%Y-%m-%d_%H-%M_%S}]

if [file exist at.tcl] {
} else {
  exec touch at.tcl
}

asetvar $dirname,title ""
asetvar $dirname,id "$dirname"

godel_draw

exec xdotool search --name "Mozilla" key ctrl+r
