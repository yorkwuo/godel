# {{{
proc gdraw_asic4_ghtm2 {} {
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name asic4_ghtm2"
    puts $kout "ghtm_top_bar stage"

    puts $kout "set kout \[open .godel/stage.table.ctrl.tcl w]"
    puts $kout "  puts \$kout \"lappend columnlist \\\[list current_version \\\"version\\\"\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list current_speed \\\"current<br>speed\\\"\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list P              P\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list V              V\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list T              T\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list wns            wns\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list nvp            nvp\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list inst           inst\\\]\""
    puts $kout "  puts \$kout \"lappend columnlist \\\[list clock_period  \\\"clock<br>period\\\"\\\]\""
    puts $kout "close \$kout"


    puts $kout "set rowlist \$vars(stage_list)"
    puts $kout "ghtm_table_note stage .index.htm"
    puts $kout "ghtm_table_bar  stage stage nvp"
  close $kout
}
# }}}
