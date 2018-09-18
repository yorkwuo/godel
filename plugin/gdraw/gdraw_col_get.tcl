lappend define(installed_flow) col_get
proc gdraw_col_get {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set infile column.rpt"
    puts $kout "set want_column \[list\]"
    puts $kout "lappend  want_column  \[list 1 40\]"
    puts $kout "lappend  want_column  \[list 3 20\]"
    puts $kout "lappend  want_column  \[list 5 20\]"
    puts $kout ""
    puts $kout "#==========="
    puts $kout "set flow_name col_get"
    puts $kout "ghtm_top_bar"
    puts $kout ""
    puts $kout "# Demo. Make it work"
    puts $kout "if !\[file exist column.rpt\] {"
    puts $kout "  file copy \$env(GODEL_ROOT)/demo/raw/column.rpt ."
    puts $kout "}"
    puts $kout ""
    puts $kout "set fin \[open \$infile r\]"
    puts $kout "while {\[gets \$fin line\] >= 0} {"
    puts $kout "  set print \"\""
    puts $kout "  foreach want \$want_column {"
    puts $kout "    set index \[lindex \$want 0\]"
    puts $kout "    set width \[lindex \$want 1\]"
    puts $kout "    incr index -1"
    puts $kout "    set txt \[godel_get_column \$line \$index\]"
    puts $kout "    append print \[format \"%-\${width}s\" \$txt\]"
    puts $kout "  }"
    puts $kout "  puts \$print"
    puts $kout "}"
    puts $kout "close \$fin"
  close $kout
}
