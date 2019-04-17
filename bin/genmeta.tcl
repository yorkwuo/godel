#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

set pwd [pwd]
#set flist [exec find $pwd -mindepth 2 -name ".godel"]
set flist [glob -nocomplain */.godel]
if {$flist == ""} {
} else {
  foreach f $flist {
    set where [file dirname $f]
    set fname [file tail [file dirname $f]]
    puts [format "%-45s %s" "set meta($fname,where)" $pwd/$where]
  }
}
