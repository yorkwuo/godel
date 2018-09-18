#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
source $env(GODEL_ROOT)/bin/godel.tcl
tbox_list [lindex $argv 0] [lindex $argv 1] [lindex $argv 2]
