#!/usr/bin/wish
set infile [lindex $argv 0]
if {$infile == ""} {
  puts "Error: No input file."
  return
}

set paths [list]
set kin [open $infile r]
  while {[gets $kin line] >= 0} {
    lappend paths $line
  }
close $kin

# up
proc up {} {
  global col
  global tinfo
  
  set width [.r0.c$col cget -width]
  incr width 2

  for {set i 0} {$i <= $tinfo(row_size)} {incr i} {
    if [winfo exist .r$i.c$col] {
      .r$i.c$col configure -width $width
    }
  }
}
# down
proc down {} {
  global col
  global tinfo
  
  set width [.r0.c$col cget -width]
  incr width -2

  for {set i 0} {$i <= $tinfo(row_size)} {incr i} {
    if [winfo exist .r$i.c$col] {
      .r$i.c$col configure -width $width
    }
  }
}
# grab
proc grab {} {
  global col
  global tinfo

  set items [list]
  for {set i 1} {$i <= $tinfo(row_size)} {incr i} {
    if [winfo exist .r$i.c$col] {
      set tt [.r$i.c$col get 1.0 end]
      regsub {\n} $tt {} tt
      puts $tt
      lappend items $tt
    }
  }
  clipboard clear
  clipboard append $items
}
# save
proc save {} {
  global col
  global tinfo



  set items [list]
  for {set i 1} {$i <= $tinfo(row_size)} {incr i} {
    if [winfo exist .r$i.c$col] {
      set tt [.r$i.c$col get 1.0 end]
      regsub {\n} $tt {} tt
      puts $tt
      lappend items $tt
    }
  }

  puts "Save to...o$col.tcl"
  set kout [open "o$col.tcl" w]
  puts $kout "#!/usr/bin/tclsh"
  puts $kout "set ilist {$items}"
  puts $kout "foreach i \$ilist {"
  puts $kout "  puts \$i"
  puts $kout "}"
  close $kout
  exec chmod +x "o$col.tcl"
}


frame .ctrl
entry .ctrl.e -textvar col -relief sunken
pack .ctrl.e -side left -anchor sw
button .ctrl.b1 -text up -height 1 -command up
button .ctrl.b2 -text down -height 1 -command down
button .ctrl.b3 -text grab -height 1 -command grab
button .ctrl.b4 -text save -height 1 -command save
pack .ctrl.b1 .ctrl.b2 .ctrl.b3 .ctrl.b4 -side left -anchor sw
pack .ctrl -side top -anchor sw


set row 1
# Label row
frame .r0
label .r0.c0 -width 4 -height 1 -borderwidth 2 -relief sunken
pack .r0.c0 -side left
foreach i {1 2 3 4 5 6 7 8 9 10 } {
  text .r0.c$i -width 20 -height 1
  .r0.c$i insert 1.0 $i
  pack .r0.c$i -side left
}
pack .r0 -side top -anchor sw

set tinfo(row_size) [llength $paths]
# Draw the table
foreach path $paths {
  set ilist [lrange [file split $path] 1 end]
  set ilist [concat [lindex $ilist end] $ilist]

# .r1
  frame .r$row
  label .r$row.c0 -text $row -width 4 -height 1 -borderwidth 2 -relief sunken
  pack .r$row.c0 -side left
  set column 1
  foreach i $ilist {
# r1.c1
    text .r$row.c$column -width 20 -height 1
    .r$row.c$column insert 1.0 $i
    pack .r$row.c$column -side left
    incr column
  }
  pack .r$row -side top -anchor sw
  incr row
}

#puts [winfo wid .r1.c0]
# Bind
bind . q exit

