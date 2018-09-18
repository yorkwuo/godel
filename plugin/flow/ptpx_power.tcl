proc ptpx_power {} {
  set infile power.rpt

  upvar define define
  upvar vars vars

  if ![godel_proc_get_ready $infile] { return }


  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
# clock_network
    if [regexp {^clock_network} $line] {
      set vars(power_clock_network)     [format "%.3f" [godel_get_column $line 4]]
    } elseif [regexp {^register} $line] {
      set vars(power_register)          [format "%.3f" [godel_get_column $line 4]]
    } elseif [regexp {^combinational} $line] {
      set vars(power_combo)          [format "%.3f" [godel_get_column $line 4]]
    } elseif [regexp {^sequential} $line] {
      set vars(power_seq)          [format "%.3f" [godel_get_column $line 4]]
    } elseif [regexp {^memory} $line] {
      set vars(power_mem)          [format "%.3f" [godel_get_column $line 4]]
    } elseif [regexp {^io_pad} $line] {
      set vars(power_iopad)          [format "%.3f" [godel_get_column $line 4]]
    } elseif [regexp {^black_box} $line] {
      set vars(power_bb)          [format "%.3f" [godel_get_column $line 4]]
    } elseif [regexp {^Total Power} $line] {
      set vars(power_total)          [format "%.3f" [godel_get_column $line 3]]
    } elseif [regexp {Net Switching Power} $line] {
      set vars(power_net_switching)  [format "%.3f" [godel_get_column $line 4]]
    } elseif [regexp {Cell Internal Power} $line] {
      set vars(power_internal)  [format "%.3f" [godel_get_column $line 4]]
    } elseif [regexp {Cell Leakage Power} $line] {
      set vars(power_leakage)  [format "%.3f" [godel_get_column $line 4]]
    }
  }
  close $fin

  godel_array_save vars .godel/vars.tcl
}
