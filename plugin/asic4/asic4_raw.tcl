proc asic4_raw {} {
  upvar env env
  upvar define define
  upvar fout fout
  upvar flow_name flow_name

  puts $fout "<h5>Raw reports/logs <a href=[tbox_cygpath $env(GODEL_ROOT)/plugin/asic4/asic4_raw.tcl] type=text/txt>(script)</a></h5>"
  puts $fout "<TABLE class=table1>"
  puts $fout "<thead>"
  puts $fout "    <tr>"
  puts $fout "        <th scope=\"col\">file</th>"
  puts $fout "        <th scope=\"col\">cook cmd</th>"
  puts $fout "        <th scope=\"col\">from</th>"
  puts $fout "    </tr>"
  puts $fout "</thead>"
  puts $fout "<tbody>"

  set ilist $define($flow_name,filelist)

  foreach ili $ilist {
    set i [lindex $ili 0]
    set from_cmd [lindex $ili 1]
    set cook_cmd [lindex $ili 2]
    if [file exist $i] {
      puts $fout "<tr>"
      puts $fout "<td>"
      puts $fout "<a href=$i type=\"text/txt\"> $i </a>"
      puts $fout "</td>"
      puts $fout "<td><a href=[tbox_cygpath $env(GODEL_ROOT)/plugin/flow/$cook_cmd.tcl] type=text/txt>$cook_cmd</a></td>"
      puts $fout "<td>$from_cmd</td>"
      puts $fout "</tr>"
    } else {
      puts $fout "<tr>"
      puts $fout "<td>$i</td>"
      puts $fout "<td><a href=[tbox_cygpath $env(GODEL_ROOT)/plugin/flow/$cook_cmd.tcl] type=text/txt>$cook_cmd</a></td>"
      puts $fout "<td>$from_cmd</td>"
      puts $fout "</tr>"
    }
  }
  puts $fout "</tbody>"
  puts $fout "</table>"
}
