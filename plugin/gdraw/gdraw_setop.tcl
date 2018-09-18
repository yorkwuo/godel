lappend define(installed_flow) setop
proc gdraw_setop {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name default"
    puts $kout "ghtm_top_bar"
    puts $kout "set a \"a/a/a:b/k/k  b/b/b:c/c/c\""
    puts $kout "set b \"d/d/d:k/k/k  b/b/b:c/c/c\""
    puts $kout ""
    puts $kout "cputs \"# solely in a\""
    puts $kout "plist \[setop_restrict \$a \$b\]"
    puts $kout "cputs \"# solely in b\""
    puts $kout "plist \[setop_restrict \$b \$a\]"
    puts $kout "cputs \"# Intersectino\""
    puts $kout "plist \[setop_intersection \$a \$b\]"
    puts $kout "cputs \"# union\""
    puts $kout "plist \[setop_union \$a \$b\]"
    puts $kout ""
  close $kout
}
