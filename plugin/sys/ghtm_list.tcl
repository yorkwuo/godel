proc ghtm_list {ifile} {
  upvar fout fout
  upvar env  env

  puts $fout "<div class=\"w3-bar w3-blue\"><a href=$ifile type=text/txt>$ifile</a> \
  <a href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_list.tcl] type=text/txt>(script)</a></div>"
  if ![file exist $ifile] {
    godel_touch $ifile
  }

  set ilist [list]
  set fin [open $ifile r]
  while {[gets $fin line] >=0} {
    if [regexp {^$} $line] {
    } elseif [regexp {^\s*$} $line] {
    } else {
      lappend ilist $line
      puts $line
    }
  }
  close $fin

  set prev 0
  set curr 0
  set space "  "
  foreach i $ilist {
    set c [split $i :]
    set num  [lindex $c 0]
    set name [lindex $c 1]
    set href [lindex $c 2]
    regsub {^\s*} $num  {} num
    regsub {^\s*} $name {} name
    regsub {\s*$} $name {} name
    regsub {^\s*} $href {} href
    regsub {\s*$} $href {} href
    #puts $href
    set curr $num
    if {$curr > $prev} {
      puts $fout "<ul>"
      set indent [string repeat $space $curr]
      if [file exist $href] {
        puts $fout "$indent<li><a href=[tbox_cygpath $href]>$name</a></li>"
      } else {
        #puts $fout "$indent<li><a href=$href>$name</a></li>"
        puts $fout "$indent<li>$name</li>"
      }
    } elseif {$curr < $prev} {
      puts $fout "</ul>"
      if {$curr == "0"} {
        set count [expr $prev - $curr]
        if {$count > 1} {
          for {set k 1} {$k < $count} {incr k} {
            puts $fout "</ul>"
          }
        }
      } else {
        set indent [string repeat $space $curr]
        if [file exist $href] {
          puts $fout "$indent<li><a href=[tbox_cygpath $href]>$name</a></li>"
        } else {
          #puts $fout "$indent<li><a href=$href>$name</a></li>"
          puts $fout "$indent<li>$name</li>"
        }
      }
    } elseif {$curr == $prev} {
      if {$curr == "0"} {
      } else {
        set indent [string repeat $space $curr]
        if [file exist $href] {
          puts $fout "$indent<li><a href=[tbox_cygpath $href]>$name</a></li>"
        } else {
          #puts $fout "$indent<li><a href=$href>$name</a></li>"
          puts $fout "$indent<li>$name</li>"
        }
      }
    }
    set prev $num
  }
}

