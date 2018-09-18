proc icc2_util {} {
  upvar vars vars
  if [file exist .vars.tcl] { source .vars.tcl }
  set infile "util.rpt"
  if [file exist $infile] {
  } else {
    puts "Error: Not exist.. $infile"
    return
  }
  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
# util
    if [regexp {Utilization Ratio:\s+(\S+)} $line whole matched] {
      set vars(util) $matched
    }
  }
  close $fin
  godel_array_save vars .vars.tcl
}

