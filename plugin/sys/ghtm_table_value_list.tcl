proc ghtm_table_value_list {name} {
  upvar env env
  upvar fout fout
  upvar vars vars
  upvar signoff signoff
  upvar flow_name flow_name

  if [file exist .godel/$name.table.ctrl.tcl] {
    source .godel/$name.table.ctrl.tcl
  } else {
    set kout [open .godel/$name.table.ctrl.tcl w]
      puts $kout "# ghtm_table_value_list"
      puts $kout "set columnlist \[list\]"
      if [tbox_procExists ${flow_name}_default_columnlist] {
        ${flow_name}_default_columnlist
      } else {
        asic4_default_columnlist
      }
    close $kout
    source .godel/$name.table.ctrl.tcl
  }

  puts $fout "<table class=table1>"
  puts $fout "<caption style=text-align:left>"
  puts $fout "Name: $name"
  puts $fout "<a type=text/txt href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_table_value_list.tcl]>(script)</a>"
  puts $fout "<a type=text/txt href=.godel/$name.table.ctrl.tcl>(ctrl)</a>"
  puts $fout "</caption>"
  puts $fout "<thead>"
  puts $fout "<tr>"
  foreach i $columnlist {
    if {[lindex $i 1] == ""} {
      set header [lindex $i 0]
    } else {
      set header [lindex $i 1]
    }
    puts $fout "<th> $header </th>"
  }

  puts $fout "</tr>"
  puts $fout "</thead>"

  puts $fout "<tbody>"
    puts $fout "<tr>"
        foreach itm $columnlist {
          set key [lindex $itm 0]
          set value [godel_get_vars $key]
          if {$value == "NA"} {
              puts $fout "<td></td>"
          } else {
            if [info exist signoff($key)] {
              if [expr $signoff($key)] {
                puts $fout "<td bgcolor=lime>$value</td>"
              } else {
                puts $fout "<td bgcolor=yellow>$value</td>"
              }
            } else {
                puts $fout "<td>$value</td>"
            }
          }
        }
    puts $fout "</tr>"
  puts $fout "</tbody>"
  puts $fout "</table>"
}

