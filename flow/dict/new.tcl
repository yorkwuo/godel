#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set newword [lindex $argv 0]

set counter [lvars . counter]
incr counter
set rowid [format "%04d" $counter]

asetvar $rowid,name $newword

lsetvar . counter $counter
