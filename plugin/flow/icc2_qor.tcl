#: icc2_qor
# {{{
proc icc2_qor {} {
  upvar vars vars
  if [file exist .vars.tcl] { source .vars.tcl }
  set infile "qor.rpt"
  if [file exist $infile] {
  } else {
    puts "Error: Not exist.. $infile"
    return
  }
  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {Timing Path Group  '(\S+)'} $line whole m1] {
      set cur_path_group $m1
    } elseif [regexp {Critical Path Slack:\s+(\S+)} $line whole m1] {
      set vars($cur_path_group,wns) $m1
    } elseif [regexp {No. of Violating Paths:\s+(\S+)} $line whole m1] {
      set vars($cur_path_group,nvp) $m1
    }
    if [regexp {Cell Area \(netlist\):\s+(\d+)} $line whole matched] {
# total cell area
      set vars(area) $matched
    }
  }
  close $fin
  if [info exist vars(reg2reg,wns)] {
    set vars(wns) $vars(reg2reg,wns)
  }
  if [info exist vars(reg2reg,nvp)] {
    set vars(nvp) $vars(reg2reg,nvp)
  }
  godel_array_save vars .vars.tcl
}
# }}}

