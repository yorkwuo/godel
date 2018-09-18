#: dc_qor
# {{{
proc dc_qor {{infile NA}} {
  set infile "qor.rpt"
  upvar vars vars
  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }

  if ![godel_proc_get_ready $infile] { return }

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {

    if [regexp {Design  WNS: (\S+)  TNS: (\S+)  Number of Violating Paths: (\S+)} $line whole m1 m2 m3] {
      #puts "$m1 $m2 $m3"
# wns
      set vars(wns) [format "%.3f" $m1]
      #set vars(tns) $m2
# nvp
      set vars(nvp) $m3
# inst
    } elseif [regexp {Leaf Cell Count:\s+(\S+)} $line whole m1] {
      set vars(inst) $m1
    }
  }
  close $fin
  set vars(wns) "-$vars(wns)"
  godel_array_save vars .godel/vars.tcl
}
# }}}
