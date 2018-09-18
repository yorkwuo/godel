#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
source $env(GODEL_ROOT)/bin/godel.tcl
set from      [lindex $argv 0]
set to        [lindex $argv 1]
set fromvalue [lindex $argv 2]
set symbol    [lindex $argv 3]
set result    [format "%.f" [money_convert $from $to $fromvalue]]
set 3dresult  [format_3digit $result]
#puts $3dresult
set symbol_result [num_symbol [format_3digit $result] $symbol]
puts "$fromvalue $from = $3dresult"
puts "$fromvalue $from = $symbol_result"
