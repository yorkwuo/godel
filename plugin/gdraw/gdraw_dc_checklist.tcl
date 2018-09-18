lappend define(installed_flow)       dc_checklist

proc gdraw_dc_checklist {} {
  set kout [open .godel/ghtm.tcl w]
    puts $kout "set flow_name dc_checklist.tcl"
     puts $kout "ghtm_top_bar detail"
     puts $kout "#ghtm_paragraph p1"
     puts $kout "#ghtm_table_note TableNmae .index.htm"
     puts $kout "ghtm_table_nodir history 0"
     puts $kout "#ghtm_list_files"
  close $kout
}
