#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
source $env(GODEL_ROOT)/bin/godel.tcl
#source $env(GODEL_META_CENTER)/gvi_list.tcl

# Files that want to be indexed
set flist [read_file_ret_list $env(GODEL_META_CENTER)/gvi_files]

# Start indexing each file listed in gvi_files
foreach f $flist {
  set fname [file tail $f]
  set dir   [file dirname $f]

  set fin [open $f r]
  set lineno 1
  while {[gets $fin line] >= 0} {
    if {[regexp {^proc\s+(\S+) } $line whole matched]} {
      set name $matched
      set meta($name,file)     $dir/$fname
      set meta($name,keywords) "$fname $name"
      set meta($name,line)     $lineno
    }
    incr lineno
  }
  close $fin

  set meta($fname,file)     $dir/$fname
  set meta($fname,keywords) "$fname self"
  set meta($fname,line)     1
}


godel_array_save meta $env(GODEL_META_CENTER)/gvi_list.tcl
