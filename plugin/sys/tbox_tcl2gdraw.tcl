proc tbox_tcl2gdraw {ifile} {
  set kout [open output.tcl w]
  set fin [open $ifile r]
    while {[gets $fin line] >= 0} {
      #puts $line
      regsub -all {\$} $line {\$} line
      regsub -all {"} $line {\"} line
      regsub -all {\[} $line {\[} line
      regsub -all {\]} $line {\]} line
      puts $kout "puts \$kout \"$line\""
    }
  close $fin
  close $kout
}

