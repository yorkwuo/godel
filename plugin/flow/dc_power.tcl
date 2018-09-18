proc dc_power {} {
  set infile power.rpt

  upvar define define
  upvar vars vars

  if ![godel_proc_get_ready $infile] { return }


  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {^Total\s\s\s\s\s} $line] {
      set vars(power_internal)  [format "%.f" [godel_get_column $line 1]]
      set vars(power_switching) [format "%.f" [godel_get_column $line 3]]
      set vars(power_leakage)   [godel_get_column $line 5]
      set vars(power_total)     [format "%.f" [godel_get_column $line 7]]
    }
  }
  close $fin

  godel_array_save vars .godel/vars.tcl
}
