proc genus_qor {} {
  set infile qor.rpt
  upvar vars vars
  upvar define define
  upvar module module

  if ![godel_proc_get_ready $infile] { return }
  puts "    genus_qor..."

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
# runtime
    if [regexp {Elapsed Runtime\s+(\S+)} $line whole m1 m2 m3] {
      set vars(runtime) [format "%.1f" [expr $m1/3600.0]]
# C2C wns
    } elseif [regexp {C2C} $line] {
      set vars(wns) [godel_get_column $line 1]
# inst
    } elseif [regexp {Leaf Instance Count\s+(\S+)} $line whole m1] {
      set vars(inst) $m1
# nvp
    } elseif [regexp {Total\s+\S+\s+(\d+)\s+$} $line whole m1] {
      set vars(nvp) $m1
# area
    } elseif [regexp {Total Area \S+\s+(\d+)\.} $line whole m1] {
      set vars(area) $m1
      #set vars(area,united) [format "%.2f" [expr $m1/$define($module,base,area).0]]
    }
  }
  close $fin
  #set vars(wns) "-$vars(wns)"
  godel_array_save vars .godel/vars.tcl
}
