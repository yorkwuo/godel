# {{{
proc gdraw_asic4_ghtm3 {} {
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name asic4_ghtm3"
    puts $kout "ghtm_top_bar version"

    puts $kout "set kout \[open .godel/version.table.ctrl.tcl w]"
    puts $kout "  puts \$kout \"lappend columnlist \\\[list current_corner \\\"corner\\\"\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list current_speed \\\"current<br>speed\\\"\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list P              P\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list V              V\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list T              T\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list wns            wns\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list nvp            nvp\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list inst           inst\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list num_seq_cell   regs\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list area           area\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list area_normalize \\\"area<br>norm\\\"\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list clock_period  \\\"clock<br>period\\\"\\\]\""
    puts $kout "close \$kout"

    puts $kout "set rowlist \$vars(version_list)"
    puts $kout "ghtm_table_note version .index.htm"
    puts $kout "ghtm_table_line version version nvp"
  close $kout
}
# }}}
