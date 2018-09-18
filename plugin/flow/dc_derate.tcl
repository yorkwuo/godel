#: dc_derate
# {{{
proc dc_derate {} {
  set infile "derate.rpt"

  upvar vars vars

  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  if ![godel_proc_get_ready $infile] { return }

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {data_cell_delay_max_late\s+(\S+)} $line whole m1] {
      #puts "$m1 $m2 $m3"
      set vars(data_cell_delay_max_late) $m1
      #puts $m1
      break
    }
  }
  close $fin
  godel_array_save vars .godel/vars.tcl
}
# }}}
