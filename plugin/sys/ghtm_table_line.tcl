
proc ghtm_table_line {tname xcolumn args} {
# Ex: ghtm_table_line version_list speed
  upvar rowlist rowlist
  upvar env  env
  upvar fout fout
  upvar attr attr

  puts $fout "<a type=text/txt href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_table_line.tcl]>(script)</a>"
  set colors [list blue green orange crimson maroon cyan ]
# Default attribute: attr(ghtm_table_line,size)
  if ![info exist attr(ghtm_table_line,size)] {
    set attr(ghtm_table_line,size) 50%
  }

# Get rowlist
  #source .godel/$tname.table.ctrl.tcl
  #source .godel/$tname.table.value.tcl
  source .godel/vars.tcl
  #puts $rowlist

# line_dset.js (data sets)
# {{{
  set kout [open ".godel/$tname.line_dset.js" w]
  puts $kout "var line_dset = {"
    foreach i $rowlist {
      lappend rows   "\"$vars($i,$xcolumn)\""
    }
    set x_axis   [join $rows   ,]

    puts $kout "        labels: \[$x_axis\],"
    puts $kout "        datasets: \["

    set counter 0
    foreach column $args {
      #puts $column
      set values [list]
      set rows   [list]
      foreach i $rowlist {
        if {$vars($i,$column) == "NA"} {
          lappend values ""
        } elseif [info exist vars($i,$column)] {
          lappend values $vars($i,$column)
        } else {
          lappend values ""
        }
        lappend rows   "\"$i\""
      }
      set y_axis   [join $values ,]
      puts $kout "        {"
      puts $kout "            label: \"$column\","
      puts $kout "            borderColor: '[lindex $colors $counter]',"
      puts $kout "            data: \[$y_axis\],"
      puts $kout "            fill: false,"
      puts $kout "            lineTension: 0,"
      puts $kout "            spanGaps: true,"
      puts $kout "        },"

      incr counter
    }
  puts $kout "       \]"
  puts $kout "    };"
  close $kout
# }}}
# line_cmd.js (command file)
# {{{
  set kout [open ".godel/$tname.line_cmd.js" w]
  puts $kout "var ctx = document.getElementById('myChart').getContext('2d');"
  puts $kout ""
  puts $kout "var chart = new Chart(ctx, {"
  puts $kout "    type: 'line',"
  puts $kout "    data: line_dset,"
  puts $kout "    options: {"
  puts $kout "        scales: {"
  puts $kout "            yAxes: \[{"
  puts $kout "                ticks: {"
  puts $kout "                    beginAtZero: true"
  puts $kout "                }"
  puts $kout "            }]"
  puts $kout "        }"
  puts $kout "    }"
  puts $kout "});"
  close $kout
# }}}

  puts $fout "<div style=\"width:$attr(ghtm_table_line,size);\">"
  puts $fout "<canvas id=\"myChart\"></canvas>"
  puts $fout "</div>"
  puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/chartjs/Chart.js]></script>"
  puts $fout "<script src=.godel/$tname.line_dset.js></script>"
  puts $fout "<script src=.godel/$tname.line_cmd.js></script>"

}

# vim:fdm=marker
