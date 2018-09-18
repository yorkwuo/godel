#: dc_mbff
# {{{
proc dc_mbff {} {
  set infile "mbff.rpt"

  upvar vars vars

  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  if ![godel_proc_get_ready $infile] { return }

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {Flip-Flop cells banking ratio  \(\(C\) \/ \(A \+ C\)\):\s+(\S+)%} $line whole m1] {
      set vars(mbff) $m1
    }
  }
  close $fin
  godel_array_save vars .godel/vars.tcl
}
# }}}
