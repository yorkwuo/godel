proc ptpx_calc {} {
  upvar vars vars
  upvar define define

  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  puts "Working on.. ptpx_calc"

# calculate current_speed
  godel_init_vars wns          NA
  godel_init_vars uncertainty  NA
  godel_init_vars clock_period NA

  if {$vars(wns) != "NA" && $vars(uncertainty) != "NA" && $vars(clock_period) != "NA"} {
    set clk_period $vars(clock_period)
    set vars(current_speed) [format "%.f" [expr 1/($clk_period.0 - $vars(wns) + $vars(uncertainty)) * 1000000]]
  } else {
    puts "wns: $vars(wns)"
    puts "uncertainty: $vars(uncertainty)"
    puts "clock_period: $vars(clock_period)"
  }

}
