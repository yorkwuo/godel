#: dc_vios
# {{{
proc dc_vios {} {
  set infile "vios.rpt"

  upvar vars vars

  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  if ![godel_proc_get_ready $infile] { return }

  godel_ps 001 snsp

  #set fin  [open $infile r]
  #while {[gets $fin line] >= 0} {
  #  if [regexp {clock uncertainty\s+(\S+)} $line whole m1] {
  #    #puts "$m1 $m2 $m3"
  #    set vars(uncertainty) $m1
  #    #puts $m1
  #    break
  #  }
  #}
  #close $fin
  set vars(nvp) $curs(size)
  godel_array_save vars .godel/vars.tcl
}
# }}}
