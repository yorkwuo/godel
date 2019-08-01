#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

# -f
set opt(-f) 0
set idx [lsearch $argv {-f}]
if {$idx != "-1"} {
  set listfile [lindex $argv [expr $idx + 1]]
  set argv [lreplace $argv $idx [expr $idx + 1]]
  set opt(-f) 1
} else {
  set listfile NA
}

# -k (keyword)
set opt(-k) 0
set idx [lsearch $argv {-k}]
if {$idx != "-1"} {
  set key  [lindex $argv [expr $idx + 1]]
  set argv [lreplace $argv $idx [expr $idx + 1]]
  set opt(-k) 1
}
# -v (value)
set opt(-v) 0
set idx [lsearch $argv {-v}]
if {$idx != "-1"} {
  set default_value [lindex $argv [expr $idx + 1]]
  set argv  [lreplace $argv $idx [expr $idx + 1]]
  set opt(-v) 1
}

if {$opt(-k)} {
} else {
  puts "Usage:"
  puts "% gfill.tcl -k foobar -v 999 *"
  return
}

set pattern $argv

if {$opt(-f)} {
  set kin [open $listfile r]
    while {[gets $kin line] >= 0} {
      lappend nlist $line
    }
  close $kin
} else {
  set nlist [glob -nocomplain -type d {*}$pattern]
}

  puts "#/usr/bin/tclsh"
  puts "source \$env(GODEL_ROOT)/bin/godel.tcl"
  foreach page $nlist {
    set value [lvars $page $key]
    if {$value == "NA"} {
      if {$opt(-v)} {
        set value $default_value
      }
    }
    set aux   [lvars $page g:pagename]
    puts [format "lsetvar %-20s %-15s \"%s\" ;# %s" $page $key $value $aux]
  }
