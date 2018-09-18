proc icc2_power {} {
  upvar vars vars
  if [file exist .vars.tcl] { source .vars.tcl }
  set infile "power.rpt"
  if [file exist $infile] {
  } else {
    puts "Error: Not exist.. $infile"
    return
  }
  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {^Total     } $line] {
      set vars(power_internal)  [godel_get_column $line 1]
      set vars(power_switching) [godel_get_column $line 3]
      set vars(power_leakage)   [godel_get_column $line 5]
      set vars(power_total)     [godel_get_column $line 7]
    }
  }
  close $fin
  godel_array_save vars .vars.tcl
}

