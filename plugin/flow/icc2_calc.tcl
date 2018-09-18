proc icc2_calc {} {
  upvar vars vars
  upvar define define

  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  puts "Working on.. dc_calc"

# calculate current_speed
  godel_init_vars wns          NA
  godel_init_vars uncertainty  NA
  godel_init_vars clock_period NA

  if {$vars(wns) != "NA" && $vars(uncertainty) != "NA" && $vars(clock_period) != "NA"} {
    set clk_period [expr double($vars(clock_period))]
    set vars(current_speed) [format "%.f" [expr 1/($clk_period - $vars(wns) + $vars(uncertainty)) * 1000000]]
    if [info exist vars(unit_adjust)] {
      set vars(current_speed) [format "%.f" [expr $vars(current_speed) * $vars(unit_adjust)]]
    }
  } else {
    puts "wns: $vars(wns)"
    puts "uncertainty: $vars(uncertainty)"
    puts "clock_period: $vars(clock_period)"
  }

# area_normalize
  set module $vars(module)
  if [info exist define($vars(module),unit_area)] {
    set unit [expr double($define($vars(module),unit_area))]
    set vars(area_normalize) [format "%.2f" [expr $vars(area)/$unit]]
  } else {
    puts "Error: No \$define($vars(module),unit_area)"
  }
# power efficiency
  if {[info exist vars(current_speed)] && [info exist vars(power_total)]} {
    if {$vars(current_speed) != "NA"} {
      set speed [expr double($vars(current_speed))]
      set vars(PE) [format "%.3f" [expr $vars(power_total)/$speed]]
    }
  }
}
