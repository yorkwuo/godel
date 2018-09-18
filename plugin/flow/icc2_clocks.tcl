proc icc2_clocks {} {
  set infile clocks.rpt

  upvar define define
  upvar vars vars

  if ![godel_proc_get_ready $infile] { return }

  if ![info exist vars(module)] {
    puts "  Error: vars(module) not define..."
    return
  }

# Get main_clock name
  set module $vars(module)
  if [info exist define($module,main_clock)] {
    set main_clock  $define($module,main_clock)
  } else {
    puts "\033\[0;31m            Error: No define($module,main_clock)\033\[0m"
  }

  set fin  [open $infile r]
  set flag 0
  while {[gets $fin line] >= 0} {
    if [regexp {^Clock\s+Period} $line] {
      set flag 1
    }
    if {$flag && [regexp "^$main_clock " $line]} {
# clock_period
      set vars(clock_period) [godel_get_column $line 1]
      set flag 0
    }
  }
  close $fin

  godel_array_save vars .godel/vars.tcl
}
