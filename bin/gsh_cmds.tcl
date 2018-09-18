#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
proc redirect {ofile cmd} {
  #puts $ofile
  #puts $cmd
  close stdout
  set pout [open $ofile w]
  set stdout $pout
    puts $pout [eval $cmd]
  close $pout
  open /dev/tty "w"
  #open /dev/pty0 w
}

proc filter {key condition} {
  upvar vars vars
  foreach i [array names vars *,$condition] {
    if [regexp {,.*,} $i] {
    } else {
      puts $i
    }
  }
}
proc remove_keys {pattern} {
  upvar vars vars
  array unset vars $pattern
}
proc pvar {name} {
  upvar vars vars
  puts $vars($name)
}
proc gcd {dir} {
  upvar vars vars
  cd $dir
  load_vars
  list_ver
}
proc load_vars {} {
  upvar vars vars
  if [info exist vars] {
    unset vars
  }
  source .godel/vars.tcl
}
proc all_columns {} {
  upvar vars vars
  foreach i [all_keys] {
    puts "lappend columnlist \[list $i $i\]"
  }
}
proc all_keys {{pattern *}} {
  upvar vars vars
  set ilist [list]
  foreach i [array names vars *,$pattern] {
    #regexp {(\S+?),} $i whole m1
    #lappend ilist $m1
    if [regexp {,.*,} $i] {
    } else {
      regexp {\S+,(\S+)} $i whole m1
      lappend ilist $m1
    }
  }
  return [lsort -unique $ilist]
}
proc list_keys {{pattern *}} {
  upvar vars vars
  plist [all_keys]
}
proc list_ver {{pattern *}} {
  upvar vars vars
  set ilist [list]
  foreach i [array names vars $pattern,*] {
    regexp {(\S+?),} $i whole m1
    lappend ilist $m1
  }
  plist [lsort -unique $ilist]
}
# Not version
proc list_nver {} {
  upvar vars vars
  set ilist [list]
  foreach i [array names vars *] {
    if [regexp {(\w+?),} $i] {
    } else {
      lappend ilist $i
    }
  }
  plist $ilist
}
