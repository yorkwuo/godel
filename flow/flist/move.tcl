#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
source at.tcl

set files [at_allrows]

foreach f $files {
  set dir [get_atvar $f,move]
  if {$dir eq "NA"} {
  } else {
    if [file exist $dir] {
    } else {
      file mkdir $dir
    }
    exec mv $f $dir
  }
}
