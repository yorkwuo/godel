#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set pattern [lindex $argv 0]
set ifile   [lindex $argv 1]

set lines [read_as_list $ifile]

foreach f $lines {
    catch {exec grep $pattern $f} result
    if {$result eq "child process exited abnormally"} {
    } else {
      puts "# $f"
      puts $result
    }
}
