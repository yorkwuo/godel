#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set dirs [glob -type d *]

set roots ""
set people ""

foreach dir $dirs {
  set id    [lvars $dir id]
  set rptto [lvars $dir rptto]

  if {$rptto eq "NA" || $rptto eq ""} {
    lappend roots $id
    set arr($id,rptto) NA
  } else {
    set arr($id,rptto) $rptto
  }

  set arr($id,dir) $dir
  lappend people $id
}


proc find_child {parent people indent level} {
  upvar arr arr
  foreach p $people {
    if {$arr($p,rptto) eq $parent} {
      puts ${indent}$arr($p,dir)
      #puts ${indent}$p
      lsetvar $arr($p,dir) level $level
      set people [lremove $people $p]
      find_child $p $people "$indent  " [expr $level + 1]
    }
  }
}


foreach root $roots {
  puts $arr($root,dir)
  lsetvar $arr($root,dir) level 1
  find_child $root $people "  " 2
}


