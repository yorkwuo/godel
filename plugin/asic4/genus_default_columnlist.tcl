proc genus_default_columnlist {} {
  upvar kout kout
  puts $kout "lappend columnlist \[list date           date\]"
  puts $kout "lappend columnlist \[list current_speed \"current<br>speed\"\]"
  puts $kout "lappend columnlist \[list uncertainty    uncertainty\]"
  puts $kout "lappend columnlist \[list pdk            pdk\]"
  puts $kout "lappend columnlist \[list V              V\]"
  puts $kout "lappend columnlist \[list T              T\]"
  puts $kout "lappend columnlist \[list error          error\]"
  puts $kout "lappend columnlist \[list wns            wns\]"
  puts $kout "lappend columnlist \[list nvp            nvp\]"
  puts $kout "lappend columnlist \[list inst           inst\]"
  puts $kout "lappend columnlist \[list clock_period \"clock<br>period\"\]"
}
