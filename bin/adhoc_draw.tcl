#!/bin/sh
# the next line restarts using tclsh \
exec $TCLSH "$0" ${1+"$@"}
source $env(GODEL_ROOT)/bin/godel.tcl
adhoc_draw {*}$argv
