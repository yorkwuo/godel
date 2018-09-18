#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
source $env(GODEL_ROOT)/bin/gsh_cmds.tcl
source $env(GODEL_ROOT)/bin/godel.tcl
source .godel/vars.tcl
list_keys
