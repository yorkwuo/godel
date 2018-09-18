proc inno_timeDesign {{infile NA}} {
  upvar vars vars
  
  if {$infile == "NA"} {
    set infile timeDesign.rpt
  }

  upvar define define

  if ![godel_proc_get_ready $infile] { return }

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
# wns
    if [regexp {WNS \(ns\):} $line] {
      set wns1 [godel_get_column $line 5]
      set vars(wns) [format "%.f" [expr $wns1 * 1000]]
# nvp
    } elseif [regexp {Violating Paths:} $line] {
      set vars(nvp) [godel_get_column $line 5]
# density
    } elseif [regexp {Density:} $line whole m1] {
      set vars(density) [godel_get_column $line 1]
# overflow
    } elseif [regexp {Routing Overflow:} $line m1] {
      set vars(overflow_h) [godel_get_column $line 2]
      set vars(overflow_v) [godel_get_column $line 5]
    }
  }
  close $fin

  godel_array_save vars .vars.tcl
}
