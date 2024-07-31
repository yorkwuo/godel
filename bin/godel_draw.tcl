#!/bin/sh
# the next line restarts using tclsh \
exec $TCLSH "$0" ${1+"$@"}
source $env(GODEL_ROOT)/bin/godel.tcl
#set flow [lindex $argv 0]
#godel_draw $flow [lindex $argv 1]
godel_draw {*}$argv
