#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl


set counter 0

set words [read_as_list wlist]

foreach word $words {
  incr counter
  set rowid [format "%04d" $counter]
  puts "$rowid,name $word"
  set atvar($rowid,name) $word
}

godel_array_save atvar at.tcl
#asetvar $rowid,name $newword

#puts $counter
#lsetvar . counter $counter
