#: dc_area
# {{{
proc dc_area {} {
  set infile "area.rpt"

  upvar vars vars

  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  if ![godel_proc_get_ready $infile] { return }

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {Number of sequential cells:\s+(\d+)} $line whole matched] {
# num_seq_cell
      set vars(num_seq_cell) $matched
    }
    if [regexp {Number of macros\/black boxes:\s+(\d+)} $line whole matched] {
# num_macros
      set vars(num_macros) $matched
    }
    if [regexp {Total cell area:\s+(\d+)} $line whole matched] {
# total cell area
      set vars(area) $matched
    }
  }
  close $fin
  godel_array_save vars .godel/vars.tcl
}
# clock_gating
# }}}
