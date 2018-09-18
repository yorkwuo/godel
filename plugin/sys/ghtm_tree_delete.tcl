proc ghtm_tree_delete {fname} {
  set fin [open $fname r]
  while {[gets $fin line] >= 0} {
    if [regexp "^d" $line] {
      puts $line
      regsub -all {\s+} $line "+" line
      set c [split $line +]
      set tobe_deleted [lindex $c end]
      file delete -force -- $tobe_deleted
    }
  }
}

