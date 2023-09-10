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
  set nums [gen_random_num 7 0 $size_unreads]
  foreach i $nums {
    set name [lindex $unreads $i]
    puts $kout $name
  }
} elseif {$type eq "tick"} {
  set nums [gen_random_num 7 0 $size_ticks]
  foreach i $nums {
    set name [lindex $ticks $i]
    puts $kout $name
  }
} elseif {$type eq "all"} {
  set nums [gen_random_num 7 0 [llength $ilist]]
  foreach i $nums {
    set name [lindex $ilist $i]
    puts $kout $name
  }
} else {
  set nums [gen_random_num 7 0 $size_dones]
  foreach i $nums {
    set name [lindex $dones $i]
    puts $name
    puts $kout $name
  }
}
close $kout

godel_draw
exec xdotool search --name "Mozilla" key ctrl+r
