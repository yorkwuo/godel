#!/usr/bin/tclsh
set local [lindex $argv 1]
set orig  [lindex $argv 4]
catch {exec tkdiff $local $orig}
