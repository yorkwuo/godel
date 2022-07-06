#!/usr/bin/wish

# update
# {{{
proc update {} {
  upvar types types

  set wlist [winfo children .]
  foreach w $wlist {
    if [regexp {\.b} $w] {
      destroy $w
    }
  }
  list_wins
  frame .bfr
  pack .bfr -pady 10
}
# }}}
# wl
# {{{
proc wl {} {
  exec gvim $::env(GODEL_ROOT)/bin/wl.tcl &
}
# }}}
# exec_cl2
# {{{
proc exec_cl2 {} {
  exec $::env(OPENFLOW_ROOT)/yorkenv/bin/cl2 &
}
# }}}
# cl2
# {{{
proc cl2 {} {
  exec gvim $::env(OPENFLOW_ROOT)/yorkenv/bin/cl2 &
}
# }}}
# dio
# {{{
proc dio {} {
  exec gvim $::env(OPENFLOW_ROOT)/yorkenv/dio.tcl &
}
# }}}
# list_wins
# {{{
proc list_wins {} {
  upvar types types
  set count 0
  foreach type $types {
    set pids {}
    set rows {}
    catch "exec xdotool search --onlyvisible --class $type" ids
    if {$ids eq {}} {
    } elseif {[regexp {child process} $ids]} {
    } else {
      set pids [concat $pids $ids]
    }
  
    if {$pids eq {}} {
      #puts "No pids..."
      continue
    } else {
      foreach pid $pids {
        #puts $pid
        set name [exec xdotool getwindowname $pid]
        if {$name eq "rses.csh"} {
        } elseif {$name eq "Firefox"} {
        } elseif [regexp {Verdi} $name] {
          lappend rows [list $pid "$type"]
        } else {
          lappend rows [list $pid "$type - $name"]
        }
      }
      
      set rows [lsort -index 1 $rows]
      
      
      foreach row $rows {
        set id   [lindex $row 0]
        set name [lindex $row 1]
        regsub {gnome-terminal} $name {gterm} name
        button .b$count -text "$name" -anchor w -command "exec xdotool windowactivate $id"
       .b$count configure -background lightblue
      
        pack .b$count -anchor sw -fill x
      
        incr count
      }
    }
  
  }
}
# }}}
proc down {} {
  wm attribute . -topmost 0
}
proc up {} {
  wm attribute . -topmost 1
}

lappend types firefox
lappend types gnome-terminal
lappend types rtm
lappend types xterm
lappend types vim
lappend types inkscape
lappend types IC
lappend types novas


wm attribute . -topmost 1

#font create mynewfont -family Clean -size 24
font create mynewfont -family Clean -size 16
#font create mynewfont -family Clean -size 12
#font create mynewfont -family Clean -size 10
option add *font mynewfont

frame .fr
pack .fr
#
button .fr.exec_cl2 -text "exec_cl2" -command {exec_cl2}
pack .fr.exec_cl2 -side left
button .fr.update -text "Update" -command {update}
pack .fr.update -side left
button .fr.wl -text "wl" -command {wl}
pack .fr.wl -side left
button .fr.cl2 -text "cl2" -command {cl2}
pack .fr.cl2 -side left
button .fr.dio -text "dio" -command {dio}
pack .fr.dio -side left
#button .fr.down -text "Down" -command {down}
#pack .fr.down -side left
#button .fr.up -text "Up" -command {up}
#pack .fr.up -side left

list_wins

#frame .bfr
#pack .bfr -pady 10

bind . q exit
bind . u update

# vim:fdm=marker
