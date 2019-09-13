#!/usr/bin/tclsh
set pages [exec find ./ -mindepth 2 -maxdepth 2 -name ".godel" ]
foreach page $pages {
  regsub {\.\/} $page {} page
  regsub {\/\.godel} $page {} page
  puts [exec meta_chkin.tcl $page]
}
