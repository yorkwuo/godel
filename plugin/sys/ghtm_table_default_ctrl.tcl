proc ghtm_table_default_ctrl {name} {
  #upvar default_row default_row

  set kout [open .godel/$name.table.ctrl.tcl w]
    #puts $kout "set trend1_x        NA"
    puts $kout "set columnlist \[list\]"
    puts $kout "#lappend columnlist \[list what what\]"
    puts $kout "#lappend columnlist \[list note note\]"
    puts $kout "lappend columnlist \[list date date\]"
    puts $kout "lappend columnlist \[list current_speed \"current<br>speed\"\]"
    puts $kout "lappend columnlist \[list uncertainty uncertainty\]"
    puts $kout "#lappend columnlist \[list pdk pdk\]"
    puts $kout "lappend columnlist \[list T T\]"
    puts $kout "#lappend columnlist \[list error error\]"
    puts $kout "lappend columnlist \[list wns \"wns\"\]"
    puts $kout "lappend columnlist \[list nvp \"nvp\"\]"
    puts $kout "lappend columnlist \[list area \"area\"\]"
    puts $kout "lappend columnlist \[list leakage \"leakage\"\]"
    puts $kout "lappend columnlist \[list dynamic \"dynamic\"\]"
    puts $kout "#lappend columnlist \[list stage stage\]"
    #if {$default_row} {
    #  puts $kout "set rowlist  \[list\]"
    #  puts $kout "lappend rowlist nobody"
    #} else {
      puts $kout "#set rowlist  \[list\]"
      puts $kout "#lappend rowlist nobody"
    #}
  close $kout

}
