proc ghtm_table_edit {width} {
  upvar env env
  upvar fout fout
  upvar vars vars
  source .godel/vars.tcl


# Create table.txt if not exist
  set lines [list]
  set fname ".godel/table.txt"
  if [file exist $fname] {
    set kout [open $fname r]
      while {[gets $kout line] >= 0} {
        lappend lines $line
      }
    close $kout
  } else {
    set kout [open $fname w]
    close $kout
  }

  set headline [lindex $lines 0]
  set columnlist [lassign $headline 0]

  set kout [open $fname w]

  set     disp [format "%${width}s" "#"]
  foreach head $columnlist {
    append disp [format " %${width}s" $head]
  }
  puts $kout $disp

  foreach line $lines {
    if {[regexp "#" $line]} {
    } elseif {[regexp {^\s*$} $line]} {
    } else {
      set rowname [lindex $line 0]
      set disp [format "%${width}s" $rowname]
      set wback [format "%${width}s" "\{$rowname\}"]
      set count 1
      foreach c $columnlist {
        # Update vars from value in text table
        if [info exist vars($rowname,$c)] {
          if {[lindex $line $count] == $vars($rowname,$c)} {
            set value             [lindex $line $count]
          } else {
            if {[lindex $line $count] == "."} {
              set value $vars($rowname,$c)
            } elseif {[lindex $line $count] == ""} {
              set value $vars($rowname,$c)
            } else {
              set vars($rowname,$c) [lindex $line $count]
              set value             [lindex $line $count]
            }
          }
        # if vars not exist, display it with .
        } else {
          if {[lindex $line $count] == "."} {
            set value .
          } elseif {[lindex $line $count] == ""} {
            set value .
          } else {
            set vars($rowname,$c) [lindex $line $count]
            set value             [lindex $line $count]
          }
        }
        #
        append disp  [format " %${width}s"   $value]
        append wback [format " %${width}s" "\{$value\}"]
        incr count
      }
      puts $disp
      puts $kout $wback
    }
  }
  close $kout


# href link to table.txt
  puts $fout "<span class=\"w3-tag\"><a href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_table_edit.tcl] type=text/txt>(script)</a>\
  <a href=.godel/table.txt type=text/txt>edit</a></span>"


# print to page
  puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"

  set fin [open .godel/table.txt]
    puts $fout "<pre>"
    while {[gets $fin line] >= 0} {
      puts $fout $line
    }
    puts $fout "</pre>"
  close $fin

  puts $fout "</div>"

  #godel_array_save vars vv.tcl
  godel_array_save vars .godel/vars.tcl
}
