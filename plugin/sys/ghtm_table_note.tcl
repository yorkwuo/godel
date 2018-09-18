proc ghtm_table_note {name {uplevel_index .index.htm}} {
  upvar flow_name flow_name
  upvar env env
  upvar fout fout
  upvar vars vars
  upvar rowlist rowlist
  upvar signoff signoff
  upvar nickname nickname
  if ![info exist nickname] {
    set nickname 0
  }
  godel_init_vars ghtm_conf,decreasing 0

# value
  if [file exist .godel/$name.table.value.tcl] {
    source .godel/$name.table.value.tcl
  } else {
    set kout [open .godel/$name.table.value.tcl w]
    close $kout
  }
# ctrl
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

  #puts $fout "<table>"
  #puts $fout "<table class=\"w3-table-all w3-hoverable w3-small\">"
  puts $fout "<table class=\"table1\" id=$name>"
  #puts $fout "<table class=\"timecard\">"

  # caption
  puts $fout "<caption style=text-align:right >"
  puts $fout "$name"
  puts $fout "<a type=text/txt href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_table_note.tcl]>(script)</a>"
  puts $fout "<a type=text/txt href=.godel/$name.table.value.tcl>(value)</a>"
  puts $fout "<a type=text/txt href=.godel/$name.table.ctrl.tcl>(ctrl)</a>"
  puts $fout "</caption>"

  # thead
  puts $fout "<thead>"
  puts $fout "<tr>"
  puts $fout "<th></th>"
  foreach i $columnlist {
    set key    [lindex $i 0]
    if {[lindex $i 1] != ""} {
      set header [lindex $i 1]
    } else {
      set header $key
    }
    if {$key == "note"} {
      puts $fout "<th> $header </th>"
      puts $fout "<th> e </th>"
    } elseif [regexp {note\d} $key] {
      puts $fout "<th> $header </th>"
      puts $fout "<th> e </th>"
    } else {
      puts $fout "<th> $header </th>"
    }
  }
  puts $fout "</tr>"
  puts $fout "</thead>"

  # tbody
  puts $fout "<tbody>"

  if ![info exist rowlist] {
    set rowlist [list]
  }

# Sort the row
  if {$vars(ghtm_conf,decreasing)} {
    set rowlist [lsort -index 0 -decreasing $rowlist]
  }

  foreach rowcombo $rowlist {
    set row          [lindex $rowcombo 0]
    set row_nickname [lindex $rowcombo 1]
    regsub -all {,} $row {/} pathrow
    if [info exist vars($row,rowcolor)] {
      puts $fout "<tr style=background-color:$vars($row,rowcolor)>"
    } else {
      puts $fout "<tr>"
    }

# rowlist
    if {$nickname} {
      puts $fout "<td><a href=$pathrow/$uplevel_index>$row_nickname</a></td>"
    } else {
#@>Skip corner level
      #if [file exist $pathrow/all/$uplevel_index] {
      #  puts $fout "<td><a href=$pathrow/all/$uplevel_index style=color:blue>$row</a></td>"
      #} elseif [file exist $pathrow/$uplevel_index] {
      #  puts $fout "<td><a href=$pathrow/$uplevel_index style=color:blue>$row</a></td>"
      #} else {
      #  puts $fout "<td>$row</a></td>"
      #}
      if [file exist $pathrow/$uplevel_index] {
        puts $fout "<td><a href=$pathrow/$uplevel_index class=w3-text-blue>$row</a></td>"
      } else {
        puts $fout "<td>$row</a></td>"
      }
    }
# columnlist
    foreach itm $columnlist {
      set key [lindex $itm 0]
      set value [godel_get_vars $row,$key]
      if {$key == "note"} {
        # note
        puts $fout "<td>"
          if [file exist $pathrow/note.txt] {
            set fin [open $pathrow/note.txt]
              while {[gets $fin line] >= 0} {
                puts $fout $line
              }
            close $fin
# if note.txt not exist, create it.
          } else {
            file mkdir $row
            set kout [open $row/note.txt w]
              puts $kout "<pre>"
              puts $kout "</pre>"
            close $kout
          }
        puts $fout "</td>"
        # edit
        puts $fout "<td>"
        puts $fout "<a href=$pathrow/note.txt type=\"text/txt\"> e </a>"
        puts $fout "</td>"
      } elseif [regexp {note\d} $key] {
        # note
# if note2.txt exist, print it.
        puts $fout "<td>"
          if [file exist $pathrow/$key.txt] {
            set fin [open $pathrow/$key.txt]
              while {[gets $fin line] >= 0} {
                puts $fout $line
              }
            close $fin
# if note2.txt not exist, create it.
          } else {
            file mkdir $pathrow
            set kout [open $pathrow/$key.txt w]
              puts $kout "<pre>"
              puts $kout "</pre>"
            close $kout
          }
        puts $fout "</td>"
        # edit
        puts $fout "<td>"
        puts $fout "<a href=$pathrow/$key.txt type=\"text/txt\"> e </a>"
        puts $fout "</td>"
      } else {
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
    }
    puts $fout "</tr>"
  }
  puts $fout "</tbody>"
  puts $fout "</table>"
}
