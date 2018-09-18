proc tbox_col2array {ifile arrayname keyindex valindex} {
  upvar $arrayname $arrayname

  set fin [open $ifile r]
    while {[gets $fin line] >= 0} {
      set key [godel_get_column $line $keyindex]
      set value [godel_get_column $line $valindex]
      set ${arrayname}($key) $value
    }
  close $fin
}
