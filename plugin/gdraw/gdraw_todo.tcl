lappend define(installed_flow) todo

proc gdraw_todo {} {
  global env
  file copy -force $env(GODEL_ROOT)/etc/md/todo.md .
  set kout [open .godel/ghtm.tcl w]
    puts $kout "ghtm_top_bar"
    puts $kout "gmd todo.md"
    puts $kout ""
  close $kout
}
