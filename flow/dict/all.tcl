#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

source at.tcl

set type [lvars . type]

set ilist [at_allrows]

set dones   ""
set unreads ""
set ticks   ""
foreach i $ilist {
  set explain [get_atvar $i,explain]
  set tick    [get_atvar $i,tick]
  if {$explain eq "NA"} {
    if {$tick eq "1"} {
      lappend dones $i
    } else {
      lappend unreads $i
    }
  } else {
    lappend dones $i
  }
  if {$tick eq "1"} {
    lappend ticks $i
  }
}
set size_unreads [llength $unreads]
set size_dones   [llength $dones]
set size_ticks   [llength $ticks]
lsetvar . unread $size_unreads
lsetvar . done   $size_dones
lsetvar . tick   $size_ticks

set kout [open "rows.f" w]

puts $type
if {$type eq "unread"} {
  foreach i $unreads {
    puts $kout $i
  }
} elseif {$type eq "tick"} {
  foreach i $ticks {
    puts $kout $i
  }
} elseif {$type eq "all"} {
  foreach i $ilist {
    puts $kout $i
  }
} else {
  foreach i $dones {
    puts $kout $i
  }
}
close $kout

godel_draw
exec xdotool search --name "Mozilla" key ctrl+r
