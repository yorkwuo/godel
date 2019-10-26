#!/usr/bin/tclsh

# Create $cmdlist from file 'cmd.list'
# You edit 'cmd.list' to add new cmd
set kin [open "cmd.list" r]
  while {[gets $kin line] >= 0} {
    if {$line != ""} {
      lappend cmdlist $line
    }
  }
close $kin
set kin [open "string.list" r]
  while {[gets $kin line] >= 0} {
    if {$line != ""} {
      lappend stringlist $line
    }
  }
close $kin

# Open new.cmd.list. The new.cmd.list will be a sorted file
# You might want to overwrite cmd.list with new.cmd.list
set kout [open "new.cmd.list" w]
  foreach i [lsort -unique $cmdlist] {
    puts $kout $i
  }
close $kout
set kout [open "new.string.list" w]
  foreach i [lsort -unique $stringlist] {
    puts $kout $i
  }
close $kout

set kin  [open "org.tcl.vim" r]
set kout [open "tcl.vim" w]

  puts $kout "syn keyword DCCommand $cmdlist"
  puts $kout "syn keyword tclString $stringlist"

  while {[gets $kin line] >= 0} {
    puts $kout $line
  }

close $kout
close $kin
