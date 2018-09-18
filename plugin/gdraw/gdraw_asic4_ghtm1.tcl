# {{{
proc gdraw_asic4_ghtm1 {} {
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name asic4_ghtm1"
    puts $kout "ghtm_top_bar module"

    puts $kout "set kout \[open .godel/module.table.ctrl.tcl w]"
    puts $kout "  puts \$kout \"lappend columnlist \\\[list current_stage \\\"stage\\\"\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list current_speed \\\"current<br>speed\\\"\\\]\""
    #puts $kout "  puts \$kout \"lappend columnlist \\\[list P              P\\\]\""
    #puts $kout "  puts \$kout \"lappend columnlist \\\[list V              V\\\]\""
    #puts $kout "  puts \$kout \"lappend columnlist \\\[list T              T\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list wns            wns\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list nvp            nvp\\\]\""
    #puts $kout "  puts \$kout \"lappend columnlist \\\[list inst           inst\\\]\""
    #puts $kout "  puts \$kout \"lappend columnlist \\\[list clock_period  \\\"clock<br>period\\\"\\\]\""
    puts $kout "close \$kout"

    puts $kout "set rowlist \$vars(module_list)"
    puts $kout "ghtm_table_note module .index.htm"
    puts $kout "ghtm_table_bar  module module nvp"
  close $kout
}
# }}}
