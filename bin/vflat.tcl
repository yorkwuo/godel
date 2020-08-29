#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/ne.tcl

set netlist    [lindex $argv 0]
set top_module [lindex $argv 1]
set ofile      [lindex $argv 2]

if {$top_module eq "" || $netlist eq ""} {
  puts "Usage:"
  puts "     % vflat /path/to/netlist top \[ofile]"
  return
}

read_netlist $netlist

write_flat $ofile

