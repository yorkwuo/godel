proc dc_clocks {} {
  set infile "clocks.rpt"

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
  } else {
    puts "\033\[0;31m            Error: No define($module,main_clock). Use default clock name: clk\033\[0m"
    set define($module,main_clock) clk
  }
    set main_clock  $define($module,main_clock)
    set lines [list]
    set fin  [open $infile r]
    while {[gets $fin line] >= 0} {
    if [regexp "^$main_clock " $line] {
# clock_period
      set vars(clock_period) [godel_get_column $line 1]
    }
      lappend lines $line
    }
    close $fin

    set index [lgrep_index $lines "Clock          Period   Waveform"]
    set hitno [lgrep_index $lines "^$main_clock" $index]
    set vars(clock_period) [lindex [lindex $lines $hitno] 1]


  godel_array_save vars .godel/vars.tcl
}
