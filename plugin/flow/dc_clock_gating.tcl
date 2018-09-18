#: dc_clock_gating
# {{{
proc dc_clock_gating {} {
  set infile "clock_gating.rpt"

  upvar vars vars

  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  if ![godel_proc_get_ready $infile] { return }

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
# num_clock_gating_element
    if [regexp {Number of Clock gating elements\s+\|\s+(\d+)} $line whole matched] {
      set vars(num_clock_gating_element) $matched
    }
# num_gated_registers
    if [regexp {Number of Gated registers\s+\|\s+(\d+ \(\d+\.\d+%\))} $line whole matched] {
      set vars(num_gated_registers) $matched
    }
# num_registers
    if [regexp {Total number of registers\s+\|\s+(\d+)} $line whole matched] {
      set vars(num_registers) $matched
    }
  }
  close $fin
  godel_array_save vars .godel/vars.tcl
}
# }}}
