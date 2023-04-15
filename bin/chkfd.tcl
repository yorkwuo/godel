#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl


  # -co
# {{{
  set opt(-co) 0
  set idx [lsearch $argv {-co}]
  if {$idx != "-1"} {
    set argv [lreplace $argv $idx $idx]
    set opt(-co) 1
  }
# }}}

  # -d (depth)
# {{{
  set opt(-d) 0
  set idx [lsearch $argv {-d}]
  if {$idx != "-1"} {
    set depth [lindex $argv [expr $idx + 1]]
    set argv [lreplace $argv $idx [expr $idx + 1]]
    set opt(-d) 1
  } else {
    set depth 1
  }
# }}}


set dp [expr $depth + 1]
catch "exec find -maxdepth $dp -name \".godel\"" dirs

set cwd [pwd]
foreach i $dirs {
  set dir [file dirname $i]

  set srcpath [ldyvars $dir srcpath]
  if {$srcpath eq "NA"} {continue}
  if {$srcpath eq ""}   {continue}

  set pdepth [pdepth $dir]
  if {$pdepth <= $depth} {
    puts "# $dir"
    cd $dir
    if {$opt(-co) eq "1"} {
      gget . fdiff co
    } else {
      gget . fdiff
    }
    cd $cwd
  }
}

