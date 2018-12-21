proc icc2_qor {infile} {
    set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {Leaf Cell Count:\s+(\d+)} $line whole matched] {
# inst_count
      lappend elist [list inst_count $matched]
    }
    if [regexp {^Design\s+\(Setup\)\s+(\S+)\s+(\S+)\s+(\S+)} $line whole wns tns nvp] {
      if {$wns == "--"} {
        lappend elist [list wns,setup $wns]]
      } else {
        lappend elist [list wns,setup [format "%.f" $wns]]
      }
      lappend elist [list nvp,setup $nvp]
    }
    if [regexp {^Design\s+\(Hold\)\s+(\S+)\s+(\S+)\s+(\S+)} $line whole wns tns nvp] {
      if {$wns == "--"} {
        lappend elist [list wns,hold $wns]]
      } else {
        lappend elist [list wns,hold [format "%.f" $wns]]
      }
      lappend elist [list nvp,hold $nvp]
    }
  }
  close $fin

  return $elist

}
