proc tempus_se_pairs {} {
  godel_proc_get_ready cc.tcl
  source cc.tcl

  set kout [open se_pairs.tcl w]
  puts $kout "set se_pairs \[list\]"
  for {set i 1} {$i <= $curs(size)} {incr i} {
    puts $kout "lappend se_pairs \"$curs($i,startpoint):$curs($i,endpoint)\""
  }
  close $kout
}
