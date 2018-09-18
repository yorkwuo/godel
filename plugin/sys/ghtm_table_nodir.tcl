proc ghtm_table_nodir {tname {use_ctrl 1}} {
# use_ctrl
# 0: upvar
# 1: files
# 2: gtable

  upvar env env
  upvar fout fout
  upvar vars vars
  upvar rowlist rowlist
  upvar columnlist columnlist
  upvar signoff signoff

# value
  if [file exist .godel/$tname.table.value.tcl] {
    source .godel/$tname.table.value.tcl
  } else {
    set kout [open .godel/$tname.table.value.tcl w]
    close $kout
  }
#@>use_ctrl 1
# Use ctrl file to control table
  if {$use_ctrl == "1"} {
    if [file exist .godel/$tname.table.ctrl.tcl] {
      source .godel/$tname.table.ctrl.tcl
    } else {
      ghtm_table_default_ctrl $tname
      source .godel/$tname.table.ctrl.tcl
    }
  }

  puts $fout "<div class=w3-panel>"
  puts $fout "<table class=\"table1\" id=\"$tname\">"

  # caption
  #puts $fout "<caption style=text-align:left >"
  #puts $fout "$tname"
  #puts $fout "<a type=text/txt href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_table_nodir.tcl]>(script)</a>"
  if {$use_ctrl == "1"} {
    puts $fout "<a type=text/txt href=.godel/$tname.table.value.tcl class=w3-text-blue>(value)</a>"
    puts $fout "<a type=text/txt href=.godel/$tname.table.ctrl.tcl class=w3-text-blue>(ctrl)</a>"
  }
  puts $fout "</caption>"
#@>use_ctrl 2
  if {$use_ctrl == "2"} {
    if [info exist vars(gtable,$tname,rowlist)] {
      set rowlist    $vars(gtable,$tname,rowlist)
    } else {
      set rowlist ""
    }
    if [info exist vars(gtable,$tname,columnlist)] {
      set columnlist $vars(gtable,$tname,columnlist)
    } else {
      set columnlist ""
    }
  } else {
    if ![info exist columnlist] {
      set columnlist ""
    }
    if ![info exist rowlist] {
      set rowlist ""
    }
  }

  # Start print the table
  #@>Print table header
  # thead
  puts $fout "<thead>"
  puts $fout "<tr>"
  puts $fout "<th></th>"
  foreach i $columnlist {
    set key    [lindex $i 0]
    # To allow syntax `lappend columnlist name'
    # When you only specify key, take key as column name
    if {[lindex $i 1] == ""} {
      set header [lindex $i 0]
    } else {
      set header [lindex $i 1]
    }
    # if column name is `note'
    if {$key == "note"} {
      puts $fout "<th> $header </th>"
      puts $fout "<th> e </th>"
    # if column name is `note\d'
    } elseif [regexp {note\d} $key] {
      puts $fout "<th> $header </th>"
      puts $fout "<th> e </th>"
    # nornal column
    } else {
      puts $fout "<th> $header </th>"
    }
  }
  puts $fout "</tr>"
  puts $fout "</thead>"

  # tbody
  puts $fout "<tbody>"

#-------------------
#@>foreach rowlist
#-------------------
  foreach row $rowlist {
# rowcolor
    if [info exist vars($row,rowcolor)] {
      puts $fout "<tr style=background-color:$vars($row,rowcolor)>"
    } else {
      puts $fout "<tr>"
    }
#@>Print rowlist
    # To support => feature
    if [regexp {(.*)=>(.*)} $row match val href] {
      set href [tbox_cygpath $href]
      puts $fout "<td><a href=$href class=w3-text-blue>$val</a></td>"
    } else {
      puts $fout "<td>$row</td>"
    }
      regsub {=>.*$} $row {} row

    #-------------------
    #@>foreach columnlist
    #-------------------
    foreach itm $columnlist {
      set key [lindex $itm 0]
      set value [godel_get_vars $row,$key]
      #@>Handle note
      if {$key == "note"} {
        puts $fout "<td>"
          if [file exist .godel/table.$tname/$row.note.txt] {
            set fin [open .godel/table.$tname/$row.note.txt]
              while {[gets $fin line] >= 0} {
                puts $fout $line
              }
            close $fin
          # if note.txt not exist, create it.
          } else {
            file mkdir .godel/table.$tname
            set kout [open .godel/table.$tname/$row.note.txt w]
              puts $kout "<pre>"
              puts $kout "</pre>"
            close $kout
          }
        puts $fout "</td>"
        # edit column
        puts $fout "<td>"
        puts $fout "<a href=.godel/table.$tname/$row.note.txt type=\"text/txt\" class=w3-text-blue> e </a>"
        puts $fout "</td>"
      #@>Handle note2, note3
      } elseif [regexp {note\d} $key] {
        puts $fout "<td>"
          if [file exist .godel/table.$tname/$row.$key.txt] {
            set fin [open .godel/table.$tname/$row.$key.txt]
              while {[gets $fin line] >= 0} {
                puts $fout $line
              }
            close $fin

          # if note2.txt not exist, create it.
          } else {
            file mkdir .godel/table.$tname
            set kout [open .godel/table.$tname/$row.$key.txt w]
              puts $kout "<pre>"
              puts $kout "</pre>"
            close $kout
          }
        puts $fout "</td>"
        # edit
        puts $fout "<td>"
        puts $fout "<a href=.godel/table.$tname/$row.$key.txt type=\"text/txt\" class=w3-text-blue> e </a>"
        puts $fout "</td>"
      #@>Normal column
      } else {
        if {$value == "NA"} {
            puts $fout "<td></td>"
        } else {
#@>Signoff column, color it.
          if [info exist signoff($key)] {
            if [expr $signoff($key)] {
              puts $fout "<td bgcolor=lime>$value</td>"
            } else {
              puts $fout "<td bgcolor=yellow>$value</td>"
            }
          } else {
              if [info exist vars(gtable,$tname,$key,attr)] {
                puts $fout "<td $vars(gtable,$tname,$key,attr)>$value</td>"
              } else {
#@>value with href
                if [regexp {(.*)=>(.*)} $value match val href] {
                  set href [tbox_cygpath $href]
                  puts $fout "<td><a href=$href class=w3-text-blue>$val</a></td>"
                } else {
                  puts $fout "<td>$value</td>"
                }
              }
          }
        }
      }
    }
    puts $fout "</tr>"
  }
  puts $fout "</tbody>"
  puts $fout "</table>"
  puts $fout "</div>"
}
