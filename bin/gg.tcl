#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
set pp [lindex $argv 0]
source $env(GODEL_ROOT)/bin/godel.tcl
set gopath [file dirname [tbox_cyg2unix $pp]]
puts "godel_draw..."
puts $gopath
cd $gopath
godel_draw

