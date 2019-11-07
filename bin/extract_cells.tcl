#!/usr/bin/tclsh

proc split_by_cell {fname odir} {
  set fin [open $fname r]
  file mkdir $odir
  set num 0
  set process_no 0
  set fout [open $odir/0dummy.kkk w]
  while {[gets $fin line] >= 0} {
    if {[regexp {^\/\* Begin cell: (\S+) } $line -> cellname]} {
      close $fout
      set fout [open $odir/$cellname.lib w]
      puts $fout $line
    } else {
      puts $fout $line
    }
  }
  close $fout
  close $fin
}


set libfile [lindex $argv 0]
set outdir [lindex $argv 1]
if {$outdir == ""} {
  set outdir output
}
if {$libfile == ""} {
  puts "Usage:"
  puts "% extract_cells.tcl foo.lib"
  return
}
split_by_cell $libfile $outdir
