#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

source $env(GODEL_ROOT)/bin/godel.tcl

# -commit
# {{{
  set opt(-commit) 0
  set idx [lsearch $argv {-commit}]
  if {$idx != "-1"} {
    set argv [lreplace $argv $idx $idx]
    set opt(-commit) 1
  }
# }}}

if {$opt(-commit)} {
  puts kk
}

set size [lindex $argv 0]

for {set i 1} {$i <= $size} {incr i} {
  set dname [format "%02d" $i]
  puts $dname
  if {$opt(-commit)} {
    file mkdir $dname
    godel_draw $dname
  }
}


# vim:fdm=marker
