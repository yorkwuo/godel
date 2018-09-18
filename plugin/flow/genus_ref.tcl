proc genus_ref {} {
  upvar vars vars
  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  set infile "ref.rpt"
  if [file exist $infile] {
  } else {
    puts "Error: Not exist.. $infile"
    return
  }
  puts "    genus_ref..."
  set flag 0
  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {Library                   Instances    Area    Instances} $line] {
      set flat 1
    }
    if [regexp {_hn_} $line] {
      set vars(vt,hn_percent) [godel_get_column $line 3] 
      if [regexp {psss_(\S+v)_(\S+c)_ccs} $line whole m1 m2] {
        set vars(V) $m1
        set vars(T) $m2
      }
    }
    if [regexp {_mn_} $line] {
      set vars(vt,mn_percent) [godel_get_column $line 3] 
      if [regexp {psss_(\S+v)_(\S+c)_ccs} $line whole m1 m2] {
        set vars(V) $m1
        set vars(T) $m2
      }
    }
    if [regexp {_nn_} $line] {
      set vars(vt,nn_percent) [godel_get_column $line 3] 
      if [regexp {psss_(\S+v)_(\S+c)_ccs} $line whole m1 m2] {
        set vars(V) $m1
        set vars(T) $m2
      }
    }
  }
  close $fin
  #set vars(wns) "-$vars(wns)"
  godel_array_save vars .godel/vars.tcl
}
