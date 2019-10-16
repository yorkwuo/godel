#!/usr/bin/tclsh
proc split_proc {fname odir} {
  split_by_proc $fname
  file mkdir $odir

  set ofile_name kkk
  set count $curs(size)
  for {set i 1} {$i <= $count} {incr i} {
    foreach line $curs($i,all) {
      if [regexp {^cell\s+\(\"(\w+)\"\) } $line whole matched] {
        set ofile_name $matched
        puts $ofile_name
        break
      }
    }

    set fout [open "$odir/$ofile_name.lib" w]
      foreach line $curs($i,all) {
        puts $fout $line
      }
    close $fout
  }
}
proc split_by_proc {afile} {
  upvar curs curs
  array unset curs *
  set fin [open $afile r]
  set num 0
  set process_no 0
  while {[gets $fin line] >= 0} {
    if {[regexp {^cell} $line]} {
      incr num
    }

    if [regexp {^#: } $line] {
    } elseif [regexp {^# \{\{\{} $line] {
    } elseif [regexp {^# \}\}\}} $line] {
    } elseif [regexp {^# vim} $line] {
    } else {
      lappend curs($num,all) $line
    }
  }
  close $fin
  set curs(size) $num
  #unset curs(0,all)
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
split_proc $libfile $outdir
