lappend files .godel/proc.tcl
lappend files .godel/ghtm.tcl
lappend files newnote.tcl
lappend files Makefile

proc help {} {
  upvar where where
  puts $where
  puts kk
}

proc pull {{name ""}} {
  upvar where where

  if {$name eq ""} {
    exec cp -r $where .
  } else {
    exec cp -r $where $name
  }
}
