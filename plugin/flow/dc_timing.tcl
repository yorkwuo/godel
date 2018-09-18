proc dc_timing {} {
  set infile timing.rpt
  upvar vars vars
  upvar define define

  if ![godel_proc_get_ready $infile] { return }

#  set fin  [open $infile r]
#  while {[gets $fin line] >= 0} {
## uncertainty
#    if [regexp {WNS \(ns\):} $line] {
#      set wns1 [godel_get_column $line 5]
#      set vars(wns) [format "%.f" [expr $wns1 * 1000]]
#    }
#  }
#  close $fin

  godel_array_save vars .godel/vars.tcl
}
