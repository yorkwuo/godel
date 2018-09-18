#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
source $env(GODEL_ROOT)/bin/godel.tcl
meta_chkin [lindex $argv 0]
