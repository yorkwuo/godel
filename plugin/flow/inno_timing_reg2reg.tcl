proc inno_timing_reg2reg {} {
  upvar vars vars
  set infile timing_reg2reg.rpt

  upvar define define
  if ![godel_proc_get_ready $infile] { return }

  set fin [open $infile r]
  while {[gets $fin line] >= 0} {
    # clock_period
    if [regexp {Phase Shift} $line whole m1 m2 m3] {
      set vars(clock_period) [format "%.f" [godel_get_column $line 4]]
    # uncertainty
    } elseif [regexp {Uncertainty} $line] {
      set vars(uncertainty)  [format "-%.f" [godel_get_column $line 2]]
      break
    }
  }
  close $fin
  godel_array_save vars .vars.tcl
}
