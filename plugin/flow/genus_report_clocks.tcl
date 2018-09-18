proc genus_report_clocks {} {
  set infile "report_clocks.rpt"
  upvar define define
  upvar vars vars
  if ![info exist vars(module)] {
    puts "  Error: vars(module) not define..."
    return
  }
  set module $vars(module)
  if [info exist define($module,main_clock)] {
    set main_clock  $define($module,main_clock)
  } else {
    puts "\033\[0;31m            Error: No define($module,main_clock)\033\[0m"
  }
  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  if ![godel_proc_get_ready $infile] { return }
  puts "    genus_report_clocks..."

  set flag 0
  set fin  [open $infile r]

  while {[gets $fin line] >= 0} {
    if [regexp {Setup Uncertainty} $line] {
      set flag 1
    }
    if {$flag} {
      if [regexp "$main_clock " $line] {
        set vars(uncertainty) -[godel_get_column $line 5]
        break
      }
    } else {
      if [regexp " $main_clock " $line] {
        set vars(clock_period) [godel_get_column $line 1]
        set vars(clock_speed)  [format "%.f" [expr 1000000/$vars(clock_period)]]
      }
    }
  }

  close $fin
  godel_array_save vars .godel/vars.tcl
}
