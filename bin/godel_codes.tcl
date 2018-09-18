#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
set arg0 [lindex $argv 0]
if {$arg0 == "all"} {
  set kout [open "all.tcl" w]
}

puts "dc_env"
set files [glob -nocomplain $env(GODEL_ROOT)/plugin/dc_env/*.tcl]
foreach i $files {
  puts "gvim $i"
  if {$arg0 == "all"} {
    puts $kout "# file: $i"
    set fin [open $i r]
      while {[gets $fin line] >= 0} {
        puts $kout $line
      }
    close $fin
  }
}

puts "bin"
set files [glob -nocomplain $env(GODEL_ROOT)/bin/*.tcl]
foreach i $files {
  puts "gvim $i"
  if {$arg0 == "all"} {
    puts $kout "# file: $i"
    set fin [open $i r]
      while {[gets $fin line] >= 0} {
        puts $kout $line
      }
    close $fin
  }
}


puts "\nflow"
set files [glob -nocomplain $env(GODEL_ROOT)/plugin/flow/*.tcl]
foreach i $files {
  puts "gvim $i"
  if {$arg0 == "all"} {
    puts $kout "# file: $i"
    set fin [open $i r]
      while {[gets $fin line] >= 0} {
        puts $kout $line
      }
    close $fin
  }
}


puts "\nasic4"
set files [glob -nocomplain $env(GODEL_ROOT)/plugin/asic4/*.tcl]
foreach i $files {
  puts "gvim $i"
  if {$arg0 == "all"} {
    puts $kout "# file: $i"
    set fin [open $i r]
      while {[gets $fin line] >= 0} {
        puts $kout $line
      }
    close $fin
  }
}

#puts "\netc"
#set files [glob -nocomplain $env(GODEL_ROOT)/etc/*/*]
#foreach i $files {
#  puts "gvim $i"
#  if {$arg0 == "all"} {
#    puts $kout "# file: $i"
#    set fin [open $i r]
#      while {[gets $fin line] >= 0} {
#        puts $kout $line
#      }
#    close $fin
#  }
#}

puts "\nsys"
set files [glob -nocomplain $env(GODEL_ROOT)/plugin/sys/*.tcl]
foreach i $files {
  puts "gvim $i"
  if {$arg0 == "all"} {
    puts $kout "# file: $i"
    set fin [open $i r]
      while {[gets $fin line] >= 0} {
        puts $kout $line
      }
    close $fin
  }
}

puts "\ngdraw"
set files [glob -nocomplain $env(GODEL_ROOT)/plugin/gdraw/*.tcl]
foreach i $files {
  puts "gvim $i"
  if {$arg0 == "all"} {
    puts $kout "# file: $i"
    set fin [open $i r]
      while {[gets $fin line] >= 0} {
        puts $kout $line
      }
    close $fin
  }
}

if {$arg0 == "all"} {
  close $kout
}
