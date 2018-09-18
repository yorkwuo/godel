#!/usr/local/bin/tclsh
package ifneeded tclreadline 2.2 \
    [list source [file join $dir tclreadlineInit.tcl]]
