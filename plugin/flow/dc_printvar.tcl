#: dc_printvar
# {{{
proc dc_printvar {} {
  set infile "printvar.rpt"

  upvar vars vars

  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  if ![godel_proc_get_ready $infile] { return }


  set dc_options [lmap i [array names signoff dc,options,*] {regsub "dc,options," $i ""}]

  set kout [open options_chk.rpt w]

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {^(\S+)\s+= \"(\S+)\"} $line whole option_name option_value] {
      if {[lsearch $dc_options $option_name] < 0} {
# Not found
      } else {
# Found
        if {$signoff(dc,options,$option_name) == $option_value} {
          #Pass
        } else {
          # Fail
          puts $kout "$option_name : $option_value ...should be... $signoff(dc,options,$option_name)"
        }
      }
    }
  }
  close $fin
  close $kout
  godel_array_save vars .godel/vars.tcl
}
# }}}
