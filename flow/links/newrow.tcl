#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

if [file exist at.tcl] {
  source at.tcl
}
set rowid [clock format [clock seconds] -format {%Y-%m-%d_%H-%M_%S}]
set atvar($rowid,name) ""
set atvar($rowid,id) $rowid

godel_array_save atvar at.tcl

godel_draw
catch {exec xdotool search --name "Mozilla" key ctrl+r}

