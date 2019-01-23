#!/usr/bin/tclsh

set pwd [pwd]
set flist [exec find $pwd -mindepth 2 -name ".godel"]
foreach f $flist {
  set where [file dirname $f]
  set fname [file tail [file dirname $f]]
  puts [format "%-45s %s" "set meta($fname,where)" $where]
}
