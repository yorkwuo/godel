#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
source ~/godel.tcl
mindex .godel/lmeta.tcl
