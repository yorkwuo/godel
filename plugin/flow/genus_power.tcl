proc genus_power {} {
  upvar vars vars
  upvar define define
  upvar module module

  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  set infile "power.rpt"
  if [file exist $infile] {
  } else {
    puts "Error: Not exist.. $infile"
    return
  }
  puts "    genus_power..."

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {leakage} $line] {
      set vars(power,leakage) [godel_get_column $line 3]
      set vars(power,leakage) [format "%.f" [expr $vars(power,leakage)/1000.0]]
      #set vars(leakage,united) [format "%.2f" [expr $vars(power,leakage)/$define($module,base,leakage).0]]
      break;
    }
  }
  close $fin
  #set vars(wns) "-$vars(wns)"
  godel_array_save vars .godel/vars.tcl
}
