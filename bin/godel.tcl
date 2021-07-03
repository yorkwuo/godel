# auto_kw_button
# {{{
proc auto_kw_button {} {
  upvar fout fout
  set dirs [glob -type d *-*]
  
  set names ""
  foreach dir $dirs {
    regexp {(\w*)-} $dir whole name
    lappend names $name
  }
  set names [lsort -unique $names]
  
  foreach nn $names {
    ghtm_keyword_button tbl 5 $nn
  }
}
# }}}
# ss2hhmmss
# {{{
proc ss2hhmmss {sec} {
  set hh [expr int([expr $sec/3600])]
  set mm [expr int([expr $sec/60]) % 60]
  set ss [expr int([expr $sec % 60])]

  return "${hh}h:${mm}m:${ss}s"
}
# }}}
# ss2ddhhmm
# {{{
proc ss2ddhhmm {sec} {
  set dd [expr int([expr $sec/86400])]
  set hh [expr int([expr $sec/3600]) % 24]
  set mm [expr int([expr $sec/60]) % 60]

  return "${dd}d:${hh}h:${mm}m"
}
# }}}
# ltbl_chkbox
# {{{
proc ltbl_chkbox {} {
  upvar celltxt celltxt
  upvar row     row

  set celltxt "<td gname=$row colname=chkbox><input type=checkbox id=cb_$row></td>"
}
# }}}
# bton_set
# {{{
proc bton_set {args} {
  upvar fout fout
  # -key 
# {{{
  set opt(-key) 0
  set idx [lsearch $args {-key}]
  if {$idx != "-1"} {
    set key [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-key) 1
  }
# }}}
  # -name 
# {{{
  set opt(-name) 0
  set idx [lsearch $args {-name}]
  if {$idx != "-1"} {
    set name [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-name) 1
  }
# }}}
  # -value 
# {{{
  set opt(-value) 0
  set idx [lsearch $args {-value}]
  if {$idx != "-1"} {
    set value [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-value) 1
  }
# }}}

  set exefile ".set_$name.gtcl"

  #if [file exist $exefile] {
  #    puts $fout "<a href=$exefile class=\"w3-btn w3-teal\" type=text/gtcl><b>$name</b></a><a class=\"w3-button w3-lime\" href=$exefile type=text/txt>cmd</a>"
  #} else {
      #puts $fout "<a href=$exefile class=\"w3-btn w3-teal\" type=text/gtcl><b>$name</b></a><a class=\"w3-button w3-lime\" href=$exefile type=text/txt>cmd</a>"
      puts $fout "<a href=$exefile class=\"w3-btn w3-teal\" type=text/gtcl><b>$name</b></a>"
    set kout [open "$exefile" w]
      puts $kout "set pagepath \[file dirname \[info script]]"
      puts $kout "cd \$pagepath"
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "lsetvar . $key \"$value\""
      puts $kout "godel_draw"
      puts $kout "exec xdotool search --name \"Mozilla\" key ctrl+r"
    close $kout
  #}
  
}
# }}}
# godel_csv
# {{{
proc godel_csv {args} {
  global fout

  # -delim (delimiter)
# {{{
  set opt(-delim) 0
  set idx [lsearch $args {-delim}]
  if {$idx != "-1"} {
    set delim [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-delim) 1
  } else {
    set delim {,}
    #set delim {:}
  }
# }}}
  # -file
# {{{
  set opt(-file) 0
  set idx [lsearch $args {-file}]
  if {$idx != "-1"} {
    set fname [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-file) 1
  }
# }}}
  # -procs (proc to execute)
# {{{
  set opt(-procs) 0
  set idx [lsearch $args {-procs}]
  if {$idx != "-1"} {
    set procs [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-procs) 1
  }
# }}}

  if {$opt(-file)} {
    if [file exist $fname] {
      set kin [open $fname r]
        set content [read $kin]
      close $kin
    } else {
      return
    }
  } else {
    set content [lindex $args 0]
  }
  set lines [split $content \n]
  set lines [lreplace $lines end end]

  set hline [lindex $lines 0]
  set header_names [split $hline $delim]
  set num 0
  foreach header_name $header_names {
    set colindex($header_name) $num
    incr num
  }


  set namelist [lvars . namelist]

  set lines [lreplace $lines 0 0]

  puts $fout "<table class=table1 id=tbl>"

  puts -nonewline $fout "<tr>"
  foreach h $namelist {
    puts -nonewline $fout "<th>$h</th>"
  }
  puts $fout "</tr>"

  foreach line $lines {
    set cols [split $line $delim]
    puts -nonewline $fout "<tr>"

    foreach i $namelist {
      if [info exist colindex($i)] {
        set coldata [lindex $cols $colindex($i)]
        puts $fout "<td>$coldata</td>"
      } else {
        puts $fout "<td></td>"
      }
    }

    puts $fout "</tr>"
  }
  puts $fout "</table>"
}
# }}}
# bton_note_onoff
# {{{
proc bton_note_onoff {} {
  upvar fout fout

  if [file exist .note_onoff.gtcl] {
  } else {
    set kout [open ".note_onoff.gtcl" w]
      puts $kout "#!/usr/bin/tclsh"
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "set pagepath \[file dirname \[info script]]"
      puts $kout "cd \$pagepath"
      puts $kout ""
      puts $kout "set note_state \[lvars . note_state]"
      puts $kout ""
      puts $kout "if {\$note_state eq \"1\"} {"
      puts $kout "  lsetvar . note_state 0"
      puts $kout "} else {"
      puts $kout "  lsetvar . note_state 1"
      puts $kout "}"
      puts $kout ""
      puts $kout "godel_draw"
      puts $kout "exec xdotool search --name \"Mozilla\" key ctrl+r"
    close $kout

  }

  puts $fout "<a href=.note_onoff.gtcl class=\"w3-btn w3-teal\" type=text/gtcl><b>note on/off</b></a>"
}
# }}}
# insert_note_column
# {{{
proc insert_note_column {} {
  upvar cols cols
  set note_state [lvars . note_state]
  if {$note_state eq "1"} {
    lappend cols "md:note;Note"
    lappend cols "ed:note.md;E"
  }
}
# }}}
# ltbl_play
# {{{
proc ltbl_play {} {
  upvar celltxt celltxt
  upvar row     row

  if [file exist $row/.1play.gtcl] {
  } else {
    set kout [open $row/.1play.gtcl w]
      puts $kout "#!/usr/bin/tclsh"
      puts $kout "set pagepath \[file dirname \[info script]]"
      puts $kout "cd \$pagepath"
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout ""
      puts $kout "set hit \[lvars . hit]"
      puts $kout ""
      puts $kout "if {\$hit eq \"1\"} {"
      puts $kout "  catch {exec mpv --playlist=playlist.f}"
      puts $kout "  set views \[lvars . views]"
      puts $kout "  if {\$views eq \"NA\"} {"
      puts $kout "    set views 1"
      puts $kout "  } else {"
      puts $kout "    incr views"
      puts $kout "  }"
      puts $kout "  lsetvar . views \$views"
      puts $kout "  set timestamp \[clock format \[clock seconds] -format {%Y-%m-%d}]"
      puts $kout "  lsetvar . last \$timestamp"
      puts $kout "} else {"
      puts $kout "  exec xterm -hold -e \"echo Not exist... \$pfile\""
      puts $kout "}"
    close $kout
  }

  if [file exist $row/.1play.gtcl] {
    set celltxt "<td><a href=$row/.1play.gtcl type=text/gtcl>Play</a></td>"
  } else {
    set celltxt "<td></td>"
  }
}
# }}}
# ltbl_hit
# {{{
proc ltbl_hit {dispcol} {
  upvar celltxt celltxt
  upvar row row
  set code $row

  set hit  [lvars $code hit]
  set tick [lvars $code tick_status]
  set disp [lvars $code $dispcol]

  if {$hit eq "NA"} {
    set hit 0
  }

  if {$hit} {
    if {$tick eq "1"} {
      set celltxt "<td bgcolor=lightgreen>$disp</td>"
    } else {
      set celltxt "<td>$disp</td>"
    }
  } else {
    set celltxt "<td bgcolor=lightgray>$disp</td>"
  }
}
# }}}
# ltbl_iname
# {{{
proc ltbl_iname {dispcol} {
  upvar celltxt celltxt
  upvar row     row

  #set iname [lvars $row g:iname]
  set tick_status [lvars $row tick_status]
  set disp [lvars $row $dispcol]

  #regsub {^\d\d\d\d-} $iname {} iname
  #regsub {_\d\d\-\d\d_\d\d} $iname {} iname

  
  if {$tick_status eq "1"} {
    set celltxt "<td bgcolor=palegreen><a href=$row/.index.htm>$disp</a></td>"
  } else {
    set celltxt "<td><a href=$row/.index.htm>$disp</a></td>"
  }
}
# }}}
# ghtm_panel_begin
# {{{
proc ghtm_panel_begin {args} {
  upvar fout fout
  # -title
# {{{
  set opt(-title) 0
  set idx [lsearch $args {-title}]
  if {$idx != "-1"} {
    set title [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-title) 1
  } else {
    set title NA
  }
# }}}
  # -bg
# {{{
  set opt(-bg) 0
  set idx [lsearch $args {-bg}]
  if {$idx != "-1"} {
    set bgcolor [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-bg) 1
  } else {
    set bgcolor NA
  }
# }}}

  if {$opt(-bg)} {
    puts $fout "<div class=\"w3-panel w3-$bgcolor w3-leftbar\">"
  } else {
    puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar\">"
  }
  if {$opt(-title)} {
    puts $fout "<p>$title</p>"
  }
}
# }}}
# ghtm_panel_end
# {{{
proc ghtm_panel_end {} {
  upvar fout fout
  puts $fout "</div>"
}
# }}}
# bton_move
# {{{
proc bton_move {pathto {name ""}} {
  upvar celltxt celltxt
  upvar row     row

  #if [file exist $row/.move.gtcl] {
  #} else {
    set kout [open $row/.move.gtcl w]
      puts $kout "set pagepath \[file dirname \[file dirname \[info script]]]"
      puts $kout "cd \$pagepath"
      puts $kout "exec mv $row $pathto"
      puts $kout "exec godel_draw.tcl"
      puts $kout "exec xdotool search --name \"${name}Mozilla Firefox\" key ctrl+r"
    close $kout
  #}

  if [file exist "$row/.move.gtcl"] {
    set celltxt "<td><a href=$row/.move.gtcl class=\"w3-btn w3-teal w3-round\" type=text/gtcl>M</a></td>"
  } else {
    set celltxt "<td></td>"
  }
}
# }}}
# bton_delete
# {{{
proc bton_delete {{name ""}} {
  upvar celltxt celltxt
  upvar row     row

  if [file exist $row/.delete.gtcl] {
  } else {
    set kout [open $row/.delete.gtcl w]
      puts $kout "set pagepath \[file dirname \[file dirname \[info script]]]"
      puts $kout "cd \$pagepath"
      puts $kout "exec xterm -e \"rm -rf $row\""
      puts $kout "exec godel_draw.tcl"
      puts $kout "exec xdotool search --name \"${name}Mozilla Firefox\" key ctrl+r"
    close $kout
  }

  if [file exist "$row/.delete.gtcl"] {
    set celltxt "<td><a href=$row/.delete.gtcl class=\"w3-btn w3-teal w3-round\" type=text/gtcl>D</a></td>"
  } else {
    set celltxt "<td></td>"
  }
}
# }}}
# bton_tick
# {{{
proc bton_tick {{name ""}} {
  upvar celltxt celltxt
  upvar row     row

  if [file exist $row/.tick.gtcl] {
  } else {
    set kout [open $row/.tick.gtcl w]
      puts $kout "set pagepath \[file dirname \[file dirname \[info script]]]"
      puts $kout "cd \$pagepath"
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "set tick_status \[lvars $row tick_status]"
      puts $kout "if {\$tick_status eq \"\" | \$tick_status eq \"1\"} {"
      puts $kout "  lsetvar $row tick_status 0"
      puts $kout "} else {"
      puts $kout "  lsetvar $row tick_status 1"
      puts $kout "}"
      puts $kout "exec godel_draw.tcl"
      puts $kout "exec xdotool search --name \"${name}Mozilla Firefox\" key ctrl+r"
    close $kout
  }

  if [file exist "$row/.tick.gtcl"] {
    set celltxt "<td><a href=$row/.tick.gtcl class=\"w3-btn w3-teal w3-round\" type=text/gtcl>T</a></td>"
  } else {
    set celltxt "<td></td>"
  }
}
# }}}
# glize
# {{{
proc glize {args} {
  # -l (level)
# {{{
  set opt(-l) 0
  set idx [lsearch $args {-l}]
  if {$idx != "-1"} {
    set level [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-l) 1
  } else {
    set level NA
  }
# }}}
  # -r (recursive)
# {{{
  set opt(-r) 0
  set idx [lsearch $args {-r}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-r) 1
  }
# }}}
  # -gd (godelize)
# {{{
  set opt(-gd) 0
  set idx [lsearch $args {-gd}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-gd) 1
  }
# }}}
  
  if {$opt(-r)} {
    catch {exec tree -f -i -d} result
  } elseif ($opt(-l)) {
    puts $level
    catch {exec tree -f -i -d -L $level} result
  }

  set lines [split $result \n]
  foreach line $lines {
    if [regexp " directories" $line] {
    } elseif [regexp {^$} $line] {
    } elseif [regexp {^\.$} $line] {
    } else {
      puts $line
      if {$opt(-gd)} {
        godel_draw $line
      }
    }
  }
}
# }}}
# gexe_button
# {{{
proc gexe_button {args} {
  upvar fout fout
  # -nowin
# {{{
  set opt(-nowin) 0
  set idx [lsearch $args {-nowin}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-nowin) 1
  }
# }}}
  # -nocmd
# {{{
  set opt(-nocmd) 0
  set idx [lsearch $args {-nocmd}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-nocmd) 1
  }
# }}}
  # -name 
# {{{
  set opt(-name) 0
  set idx [lsearch $args {-name}]
  if {$idx != "-1"} {
    set name [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-name) 1
  }
# }}}
  set exefile [lindex $args 0]
  if {$opt(-name)} {
  } else {
    set name $exefile
  }

  if [file exist $exefile] {
    exec chmod +x $exefile
    if {$opt(-nocmd)} {
      puts $fout "<a href=.$exefile.gtcl class=\"w3-btn w3-teal\" type=text/gtcl><b>$name</b></a>"
    } else {
      puts $fout "<a href=.$exefile.gtcl class=\"w3-btn w3-teal\" type=text/gtcl><b>$name</b></a><a class=\"w3-button w3-lime\" href=$exefile type=text/txt>cmd</a>"
    }
    set kout [open ".$exefile.gtcl" w]
      puts $kout "set pagepath \[file dirname \[info script]]"
      puts $kout "cd \$pagepath"
      if {$opt(-nowin)} {
        puts $kout "exec ./$exefile"
      } else {
        #puts $kout "exec xterm -e \"./$exefile;sleep 0.5\""
        puts $kout "exec xterm -e \"./$exefile\""
      }
    close $kout
  } else {
    #puts "Error: gexe_button: file not exist... $exefile"
  }
}
# }}}
# list_svg
# {{{
proc list_svg {args} {
  upvar fout fout
  # -title
# {{{
  set opt(-title) 0
  set idx [lsearch $args {-title}]
  if {$idx != "-1"} {
    set title [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-title) 1
  } else {
    set title NA
  }
# }}}

  set fname [lindex $args 0]

  if ![file exist $fname] {
    set kout [open $fname w]
      puts $kout "<svg>"
      puts $kout "</svg>"
    close $kout
  }
  puts $fout "<div class=\"w3-panel w3-light-gray w3-leftbar \">"
  if {$opt(-title)} {
    puts $fout "<p>$title <a href=$fname type=text/svg>$fname</a></p>"
  } else {
    puts $fout "<p><a href=$fname type=text/svg>$fname</a></p>"
  }
  puts $fout "</div>"

  set kin [open $fname r]
  set content [read $kin]
  puts $fout $content
  close $kin
}
# }}}
# ghtm_js_input
# {{{
# Ex: ghtm_js_input add.js Add
proc ghtm_js_input {jscmd bname} {
  upvar fout    fout
  upvar inputid inputid
  upvar bid     bid

  if ![info exist inputid] { set inputid 0 } else { incr inputid }
  if ![info exist bid]     { set bid     0 } else { incr bid     }

  puts $fout "<div>"
  puts $fout "<input type=text id=inputid$inputid>"
  puts $fout "<button id=bid$bid>$bname</button>"
  puts $fout "<script src=$jscmd></script>"
  puts $fout "</div>"
}
# }}}
# ghtm_newnote
# {{{
proc ghtm_newnote {} {
  upvar fout fout
  set kout [open .godel/newnote.gtcl w]

  puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
  puts $kout "set pagepath \[file dirname \[info script]]"
  puts $kout "cd \$pagepath/.."
  puts $kout ""
  puts $kout "exec newnote"
  puts $kout ""
  puts $kout "godel_draw"
  puts $kout "exec xdotool search --name \"Mozilla\" key ctrl+r"

  close $kout

  puts $fout "<a href=.godel/newnote.gtcl type=text/gtcl>newnote</a>"
}
# }}}
# ghtm_filter_ls
# {{{
proc ghtm_filter_ls {} {
  upvar fout fout
  puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">" 
  puts $fout "<input type=text id=filter_input onKeyPress=filter_ghtmls(event) placeholder=\"Search...\">"
  puts $fout "</div>" 
}
# }}}
# gwin
# {{{
proc gwin {size} {
  set wid [exec xdotool getwindowfocus] 

  if {$size eq "b1"} {
    exec xdotool windowsize $wid 1800 800 
    exec xdotool windowmove $wid 0 0
  } elseif {$size eq "b3"} {
    exec xdotool windowsize $wid 1550 800 
    exec xdotool windowmove $wid 0 900
  } elseif {$size eq "b4"} {
    exec xdotool windowsize $wid 1800 800
    exec xdotool windowmove $wid 774 383
  } elseif {$size eq "s1"} {
    exec xdotool windowsize $wid 1550 680
    exec xdotool windowmove $wid 0 0
  }
}
# }}}
# chkfiles
# {{{
proc chkfiles {name_pattern} {
  #upvar ward ward
  upvar fout fout
  #set f  $ward/$name_pattern
  set f  $name_pattern
  set fname   [file tail $name_pattern]
  set dirname [file dirname $name_pattern]

  if [file exist $f] {
    set mtime [file mtime $f]
    set timestamp [clock format $mtime -format {%Y-%m-%d %H:%M}]
    puts $fout "<pre>$timestamp <a style=background-color:lightblue href=$f type=text/txt>$fname</a> $dirname</pre>"
  } else {
    if [file exist $name_pattern] {
      set f $name_pattern
      set mtime [file mtime $f]
      set timestamp [clock format $mtime -format {%Y-%m-%d %H:%M}]
      puts $fout "<pre>$timestamp <a style=background-color:lightblue href=$f type=text/txt>$fname</a> $dirname</pre>"
    } else {
      puts $fout "<pre>xxxx-xx-xx xx:xx <a style=background-color:lightgrey href=$f type=text/txt>$fname</a> $dirname</pre>"
    }
  }
}
# }}}

# pair_value
# {{{
proc pair_value {key {name pair}} {
  upvar where where

  if ![file exist $where/$name] {
    puts "Error: not exist... $where/$name"
    return
  }

  set hits ""

  set kin [open $where/$name r]


  while {[gets $kin line] >= 0} {
    if [regexp "$key" $line] {
      lappend hits [lindex $line 2]
    }
  }

  close $kin

  #puts $hits

  return $hits

}
# }}}

# fm
# {{{
proc fm {args} {
  upvar fout fout
  set flist [glob -nocomplain *]
  if {$flist eq ""} {
    puts $fout "<p>No files...</p>"
  }
  puts $fout "<table id=tbl class=table1>"
  foreach row [lsort $flist] {
    puts $fout "<tr>"
    set celltxt {}
    if [regexp {\.mp4} $row] {
      set mp4row "<video width=420 height=240 controls preload=none><source src=\"$row\" type=video/mp4></video>"
      append celltxt "<td>$mp4row<br>$row</td>"
    }
# control
    append celltxt "<td gname=\"$row\" contenteditable=true></td>"

# flist:
    if [file isdirectory $row] {
      regsub -all {\[} $row {\\[} dir
      regsub -all {\]} $dir {\\]} dir
      set files [glob -nocomplain $dir/*]
      set links {<pre>}
      foreach f $files {
        set name [file tail $f]
        append links "<a href=\"$f\">$name</a>\n"
      }
      append links {</pre>}
      append celltxt "<td>$links</td>"
    }

    puts $fout $celltxt
    puts $fout "</tr>"
  }
  puts $fout "</table>"
}
# }}}
# jcd
# {{{
proc jcd {args} {

  set hpath [lindex $args 0]

  regsub {file:\/\/} $hpath {} hpath

  set goto [file dirname $hpath]
  #puts stderr "cd $goto"
  puts "cd $goto"
}
# }}}
# section_start
# {{{
proc section_start {name} {
  set timestamp [clock format [clock seconds] -format {%Y-%m-%d %H:%M}]
  puts "# SECTION_START : $name : $timestamp"
}
# }}}
# section_stop
# {{{
proc section_stop {name} {
  set timestamp [clock format [clock seconds] -format {%Y-%m-%d %H:%M}]
  puts "# SECTION_STOP : $name : $timestamp"
}
# }}}
# gproc_tstamp
# {{{
proc gproc_tstamp {gpage name} {
  if ![file exist $gpage] {
    file mkdir $gpage
    godel_draw $gpage
  }
  lsetvar $gpage tstamp,$name [clock format [clock seconds] -format {%Y-%m-%d %H:%M}]
}
# }}}

# fdiff
# {{{
proc fdiff {args} {
  upvar vars  vars
  upvar files files

  # ci
# {{{
  set opt(ci) 0
  set idx [lsearch $args {ci}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(ci) 1
  }
# }}}
  # co
# {{{
  set opt(co) 0
  set idx [lsearch $args {co}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(co) 1
  }
# }}}

  set target_num [lindex $args 0]

  if [file exist .godel/dyvars.tcl] {
    source .godel/dyvars.tcl
  } else {
    puts "fdiff: not exist... .godel/dyvars.tcl"
    return
  }

  if ![info exist dyvars(srcpath)] {
    puts "fdiff: \$dyvars(srcpath)... missed in .godel/dyvars.tcl"
    return
  }

  set srcpath $dyvars(srcpath)


  set num 1
  foreach f $files {
    if ![file exist $f] {
      if {$opt(co)} {
        puts "co not exist file... $f"
        exec cp $srcpath/$f $f
      } else {
        puts "not exist... $f"
      }
      continue
    }
    set dir [file dirname $srcpath/$f]
    if [file exist $dir] {
      catch {exec diff $f $srcpath/$f | wc -l} result

      if {$result > 0} {

        set tlocal  [file mtime $f]
        set tremote [file mtime $srcpath/$f]
        if {$tlocal > $tremote} {
          set status newer
        } else {
          set status older
        }


# ci
        if {$opt(ci)} {
          if {$target_num eq ""} {
            puts [format "%-2d %s %s ......ci" $num $status $f]
            exec cp $f $srcpath/$f
          } elseif {$target_num eq $num} {
            puts [format "%-2d %s %s ......ci" $num $status $f]
            exec cp $f $srcpath/$f
          } else {
            puts [format "%-2d %s %s" $num $status $f]
          }
# co
        } elseif {$opt(co)} {
          if {$target_num eq ""} {
            puts [format "%-2d %s %s ......co" $num $status $f]
            exec cp $srcpath/$f $f
          } elseif {$target_num eq $num} {
            puts [format "%-2d %s %s ......co" $num $status $f]
            exec cp $srcpath/$f $f
          } else {
            puts [format "%-2d %s %s" $num $status $f]
          }
# tkdiff
        } else {
            puts [format "%-2d %s %s" $num $status $f]
          if {$target_num eq $num} {
            puts "   tkdiff $f $srcpath/$f"
            catch {exec tkdiff $f $srcpath/$f}
          }
        }

        incr num
      }

    }
  }

}
# }}}
# ftkdiff
# {{{
proc ftkdiff {} {
  upvar vars vars
  upvar files files
  source .godel/dyvars.tcl

  if ![info exist dyvars(srcpath)] {
    puts "Error: dyvars not exist... \$dyvars(srcpath)"
    return
  }
  set srcpath $dyvars(srcpath)

  foreach f $files {
    puts "\n\033\[0;92m# $f\033\[0m\n"
    puts "tkdiff $srcpath/$f $f"
  }
}
# }}}
# fpush
# {{{
proc fpush {args} {
  upvar vars vars
  upvar files files

  # -cm
# {{{
  set opt(-cm) 0
  set idx [lsearch $args {-cm}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-cm) 1
  }
# }}}

  source .godel/dyvars.tcl
  if ![info exist dyvars(srcpath)] {
    puts "Error: dyvars not exist... \$dyvars(srcpath)"
    return
  }
  set srcpath $dyvars(srcpath)

  if {$opt(-cm)} {
    puts ""
    puts "Commit..."
    puts ""
  }

  foreach f $files {
    set dir [file dirname $srcpath/$f]
    if [file exist $dir] {
      catch {exec diff $f $srcpath/$f | wc -l} result
      if {$result > 0} {
        if {$opt(-cm)} {
          puts [format "cp %-30s %s" $f $srcpath/$f]
          exec cp $f $srcpath/$f
        } else {
          puts [format "cp %-30s %s" $f $srcpath/$f]
        }
      }
    }
    #puts $result
  }
}
# }}}
# fpushforce
# {{{
proc fpushforce {} {
  upvar vars vars
  upvar files files
  source .godel/dyvars.tcl
  if ![info exist dyvars(srcpath)] {
    puts "Error: dyvars not exist... \$dyvars(srcpath)"
    return
  }
  set srcpath $dyvars(srcpath)

  foreach f $files {
    puts "Overwrite: cp $f $srcpath/$f"
    exec cp $f $srcpath/$f
  }
}
# }}}
# fpull
# {{{
proc fpull {} {
  upvar vars vars
  upvar files files
  source .godel/dyvars.tcl
  if ![info exist dyvars(srcpath)] {
    puts "Error: dyvars not exist... \$dyvars(srcpath)"
    return
  }
  set srcpath $dyvars(srcpath)

  foreach f $files {
    puts "cp $srcpath/$f $f"
    #exec cp $srcpath/$f $f
  }
}
# }}}
# fpullforcce
# {{{
proc fpullforce {} {
  upvar vars vars
  upvar files files
  source .godel/dyvars.tcl
  if ![info exist dyvars(srcpath)] {
    puts "Error: dyvars not exist... \$dyvars(srcpath)"
    return
  }
  set srcpath $dyvars(srcpath)

  foreach f $files {
    puts "cp $srcpath/$f $f"
    exec cp $srcpath/$f $f
  }
}
# }}}


# getcol
# {{{
proc getcol {args} {
  # -c (key)
# {{{
  set opt(-c) 0
  set idx [lsearch $args {-c}]
  if {$idx != "-1"} {
    set cols  [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-c) 1
  }
# }}}
  puts $cols
  puts $args
}
# }}}
# ghtm_keyword_button
# {{{
proc ghtm_keyword_button {tablename column keyword args} {
  upvar fout fout

  # -name
# {{{
  set opt(-name) 0
  set idx [lsearch $args {-name}]
  if {$idx != "-1"} {
    set name [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-name) 1
  } else {
    set name NA
  }
# }}}

  if {$opt(-name)} {
    puts $fout "<button class=\"w3-button w3-round w3-blue-gray\" onclick=filter_table_keyword(\"$tablename\",$column,\"$keyword\")>$name</button>"
  } else {
    puts $fout "<button class=\"w3-button w3-round w3-blue-gray\" onclick=filter_table_keyword(\"$tablename\",$column,\"$keyword\")>$keyword</button>"
  }
}
# }}}
# ghtm_ls
# {{{
proc ghtm_ls {args} {
  upvar env env
  upvar fout fout

  # -nodir
# {{{
  set opt(-nodir) 0
  set idx [lsearch $args {-nodir}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-nodir) 1
  }
# }}}
  # -sb (sortby)
# {{{
  set opt(-sb) 0
  set idx [lsearch $args {-sb}]
  if {$idx != "-1"} {
    set sortby [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-sb) 1
  }
# }}}
  # -exclude
# {{{
  set opt(-exclude) 0
  set idx [lsearch $args {-exclude}]
  if {$idx != "-1"} {
    set exclude_pattern [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-exclude) 1
  }
# }}}

  if {$opt(-exclude)} {
    set exfiles [glob -nocomplain {*}$exclude_pattern]
  }

  set pattern [lindex $args 0]

# Dir
  if {!$opt(-nodir)} {
    set flist [lsort [glob -nocomplain -type d $pattern]]
    #puts $fout <p>
    #puts $fout [pwd]/$pattern
    set count 1
    foreach full $flist {
      set fname [file tail $full]
      set mtime [file mtime $full]
      set timestamp [clock format $mtime -format {%Y-%m-%d %H:%M}]
      set fsize [file size $full]
      set fsize [num_symbol $fsize K]
      #puts $fout [format "<div class=ghtmls><pre style=background-color:lightblue>%-3s %s %-5s %s</pre>" $count $timestamp $fsize "<a class=keywords href=\"$full\">$fname</a><br></div>"]
      puts $fout [format "<div class=ghtmls><pre style=background-color:lightcyan>%s %-8s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$full/.index.htm\">$fname</a><br></div>"]
      incr count
    }
    #puts $fout </p>
  }

# Files
  set flist [lsort [glob -nocomplain -type f $pattern]]

  if {$opt(-exclude)} {
    set flist [setop_restrict $flist $exfiles]
  }
  set flist2 ""
  foreach full $flist {
    if [regexp {\$} $full] {continue}
    set mtime [file mtime $full]
    set fname [file tail  $full]
    lappend flist2 [list $mtime $full $fname]
  }
  if {$opt(-sb)} {
    set sortedlist [lsort -index 0 -decreasing $flist2 ]
  } else {
    set sortedlist [lsort -index 2 $flist2 ]
  }

  set count 1
  foreach i $sortedlist {
    set full [lindex $i 1]
    set mtime [file mtime $full]
    set fname [file tail $full]
    set timestamp [clock format $mtime -format {%Y-%m-%d %H:%M}]
    set fsize [file size $full]
    if {$fsize >= 1000000} {
      set fsize [num_symbol $fsize M]
    } elseif {$fsize >= 1000} {
      set fsize [num_symbol $fsize K]
    } else {
      set fsize [num_symbol $fsize B]
    }
    puts $full
    if [regexp {\.htm} $full] {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$full\">$fname</a><br></div>"]
    } elseif [regexp {\.mp4|\.mkv|\.webm|\.rmvb} $full] {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$full\" type=text/mp4>$fname</a><br></div>"]
    } elseif [regexp {\.mp3} $full] {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$full\" type=text/mp3>$fname</a><br></div>"]
    } elseif [regexp {\.pdf} $full] {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$full\" type=text/pdf>$fname</a><br></div>"]
    } elseif [regexp {\.epub} $full] {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$full\">$fname</a><br></div>"]
    } else {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$full\" type=text/txt>$fname</a><br></div>"]
    }
    incr count
  }
  #puts $fout </p>
  
}
# }}}
# ghtm_list_files
# {{{
proc ghtm_list_files {pattern {description ""}} {
  upvar env env
  upvar fout fout

  #puts $fout "<div><h5>Filelist$description<a href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_list_files.tcl] type=text/txt>(script)</a></h5></div>"
  set flist [lsort [glob -nocomplain $pattern]]
  foreach full $flist {
    set fname $full

    if {[regexp -nocase {\.jpg|\.png|\.gif} $fname]}  {
      #puts $fout "<div class=\"w3-card\" style=\"width:10%\">"
      #puts $fout "  <a href=$fname><img src=\"$fname\" style=\"width:100%\"></a>"
      #puts $fout "    <p>$fname</p>"
      #puts $fout "</div>"
      puts $fout "<a href=\"$full\" type=text/jpg>$full</a><br>"
    } elseif [regexp -nocase {\.png} $fname] {
    } elseif [regexp -nocase {\.md} $fname] {
      #puts $fout "<a href=\"$full\" type=text/png><img src=$full width=30% height=30%></a>"

    } elseif [regexp -nocase {\.docx} $fname] {
      puts $fout "<a href=\"$full\" type=text/docx>$full</a><br>"

    } elseif [regexp -nocase {\.one} $fname] {
      puts $fout "<a href=\"$full\">$full</a><br>"

    } elseif [regexp -nocase {\.html} $fname] {
      puts $fout "<a href=\"$full\">$full</a><br>"

    } elseif [regexp -nocase {\.mpg} $fname] {
      puts $fout "<a href=\"$full\">$full</a><br>"

    } elseif [regexp -nocase {\.msg} $fname] {
      puts $fout "<a href=\"$full\">$full</a><br>"

    } elseif [regexp -nocase {\.mobi} $fname] {
      puts $fout "<a href=\"$full\">$full</a><br>"

    } elseif [regexp -nocase {\.pptx} $fname] {
      puts $fout "<a href=\"$full\" type=text/pptx>$full</a><br>"

    } elseif [regexp -nocase {\.ppt} $fname] {
      puts $fout "<a href=\"$full\" type=text/ppt>$full</a><br>"

    } elseif [regexp -nocase {\.xlsx} $fname] {
      puts $fout "<a href=\"$full\" type=text/xlsx>$full</a><br>"

    } elseif [regexp -nocase {\.pdf} $fname] {
      puts $fout "<a href=\"$full\" type=text/pdf>$full</a><br>"
    } elseif [regexp -nocase {\.mp4} $fname] {
      puts $fout "<a href=\"$full\" type=text/mp4>$full</a><br>"
    } elseif [regexp -nocase {\.mp3} $fname] {
      puts $fout "<a href=\"$full\" type=text/mp3>$full</a><br>"
    } elseif [regexp -nocase {\.rmvb} $fname] {
      puts $fout "<a href=\"$full\" type=text/rmvb>$full</a><br>"
    } elseif [regexp -nocase {\.htm} $fname] {
      puts $fout "<a href=\"$full\" type=text/htm>$full</a><br>"
    } elseif [regexp -nocase {\.mht} $fname] {
      puts $fout "<a href=\"$full\" type=text/mht>$full</a><br>"
    } elseif [regexp -nocase {\.ppdf} $fname] {
      puts $fout "<a href=\"$full\" type=text/ppdf>$full</a><br>"
    } elseif [file isdirectory $fname] {
    } else {
      puts $fout "<a href=\"$full\" type=text/txt>$full</a><br>"
    }
  }
}
# }}}
# ghtm_top_bar
# {{{
proc ghtm_top_bar {args} {
  upvar fout fout
  upvar env env
  upvar vars vars
  upvar flow_name flow_name
  # -filter (filter tbl column x)
# {{{
  set opt(-filter) 0
  set idx [lsearch $args {-filter}]
  if {$idx != "-1"} {
    set tblcol [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-filter) 1
  }
# }}}
  # -save
# {{{
  set opt(-save) 0
  set idx [lsearch $args {-save}]
  if {$idx != "-1"} {
    set saveid [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-save) 1
  }
# }}}
  # -csv
# {{{
  set opt(-csv) 0
  set idx [lsearch $args {-csv}]
  if {$idx != "-1"} {
    set csvid [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-csv) 1
  }
# }}}
  # -js
# {{{
  set opt(-js) 0
  set idx [lsearch $args {-js}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-js) 1
    upvar LOCAL_JS LOCAL_JS
    set LOCAL_JS 1
  }
# }}}

  if [file exist .godel/dyvars.tcl] {
    source .godel/dyvars.tcl
  } else {
    set dyvars(last_updated) Now
  }

  set timestamp [clock format [clock seconds] -format {%Y-%m-%d_%H:%M}]

  set cwd [pwd]
  #file copy -force $env(GODEL_ROOT)/scripts/js/godel.js .godel/js
  #exec cp $env(GODEL_ROOT)/scripts/js/godel.js .godel/js
  #file copy -force $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js .godel/js
  #exec cp $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js .godel/js

  #puts $fout "<script src=.godel/js/jquery-3.3.1.min.js></script>"
  #puts $fout "<script src=.godel/js/godel.js></script>"

  puts $fout "<ul id=stickymenu class=solidblockmenu>"
  puts $fout "<li><a href=.godel/ghtm.tcl type=text/txt>Edit</a></li>"
  puts $fout "<li><a href=.godel/vars.tcl type=text/txt>Value</a></li>"
  if {$opt(-save)} {
    if {$saveid eq ""} {set saveid "save"}
    puts $fout "<li><button id=\"$saveid\" style=\"margin: 10px 6px\">Save</button></li>"
  }
  if {$opt(-csv)} {
    if {$csvid eq ""} {set csvid "csv"}
    puts $fout "<li><button id=\"$csvid\" style=\"margin: 10px 6px\">CSV</button></li>"
  }
  if {$opt(-filter)} {
    puts $fout "<li><input type=text id=filter_table_input onkeyup=filter_table(\"tbl\",$tblcol,event) placeholder=\"Search...\"></li>"
  }
  if {$opt(-js)} {
    puts $fout "<li style=float:right><a href=local.js type=text/txt>JS</a></li>"
  }
  puts $fout "<li><a href=../.index.htm>Parent</a></li>"
  puts $fout "<li><a href=.godel/draw.gtcl type=text/gtcl>Draw</a></li>"
  puts $fout "<li style=float:right><a href=.godel/open.gtcl type=text/gtcl>Open</a></li>"
  puts $fout "<li style=float:right><a href=.index.htm type=text/txt>HTML</a></li>"
  puts $fout "<li style=float:right><a>$timestamp</a></li>"
  puts $fout "</ul>"
  puts $fout "<br>"

  if [file exist .godel/.qn.md] {
    gmd -f .godel/.qn.md
  } else {
    set kout [open ".godel/.qn.md" w]
    close $kout
  }
}
# }}}
# akey
# {{{
proc akey {gpage keywords} {
# Func: add keywords

# Remove possible `/' at the tail.
  regsub {\/$} $gpage {} gpage

# Check file existence
  set varfile $gpage/.godel/vars.tcl
  if ![file exist $varfile] {
    puts "Error: not exist... $varfile"
    return
  } else {
    source $varfile
  }

  append vars(g:keywords) " $keywords"
  set vars(g:keywords) [string trim $vars(g:keywords)]

  godel_array_save vars $varfile

}
# }}}
# lser
# {{{
proc lser {args} {
  # -v vars to print
# {{{
  set opt(-v) 0
  set idx [lsearch $args {-v}]
  if {$idx != "-1"} {
    set vars2print [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-v) 1
  } else {
    set listfile NA
  }
# }}}

  set keywords $args

  set dirs [glob -type d *]
  foreach dir $dirs {
    if [file exist $dir/.godel/vars.tcl] {
      source $dir/.godel/vars.tcl
      lappend dir_keys [list $dir "$dir $vars(g:keywords)"]
      unset vars
    } else {
      lappend dir_keys [list $dir $dir]
    }
  }

# Search pagelist
  set found_names ""
  foreach dir $dir_keys {
    set found 1
# Is it match with keywords
    foreach k $keywords {
        set dir_keywords [lindex $dir 1]
        if {[lsearch -regexp $dir_keywords $k] >= 0} {
          set found [expr $found&&1]  
        } else {
          set found [expr $found&&0]  
        }
    }

    if {$found} {
      lappend found_names $dir
    }
  }

  if {$found_names == ""} {
    puts stderr "Not found... $keywords"
  } else {
      foreach dir $found_names {
        set gpage [lindex $dir 0]

        if {$opt(-v)} {
          foreach v $vars2print {
            puts [lvars $gpage $v]
          }
        } else {
          puts $gpage
        }
      }
  }

}
# }}}
# lcd
# {{{
proc lcd {args} {
  set keywords $args

  set dirs [glob -type d *]
  foreach dir $dirs {
    if [file exist $dir/.godel/vars.tcl] {
      source $dir/.godel/vars.tcl
      lappend dir_keys [list $dir "$dir $vars(g:keywords)"]
      unset vars
    } else {
      lappend dir_keys [list $dir $dir]
    }
  }

# Search pagelist
  set found_names ""
  foreach dir $dir_keys {
    set found 1
# Is it match with keywords
    foreach k $keywords {
        set dir_keywords [lindex $dir 1]
        if {[lsearch -regexp $dir_keywords $k] >= 0} {
          set found [expr $found&&1]  
        } else {
          set found [expr $found&&0]  
        }
    }

    if {$found} {
      lappend found_names $dir
    }
  }

  if {$found_names == ""} {
    puts stderr "Not found... $keywords"
  } else {
# If more than 1 page found, display them
    if {[llength $found_names] > 1} {
      foreach dir $found_names {
        puts stderr [format "%-20s %s" [lindex $dir 0] [lindex $dir 1]]
      }
# If only 1 page found, cd to it
    } else {
      puts "cd [lindex [lindex $found_names 0] 0]"
    }
  }

}
# }}}
# addspace
# {{{
proc addspace {txt space_count {position +}} {
# Create space
  for {set i 0} {$i < $space_count} {incr i} {
    append spaces " "
  }
  if {$position == "-"} {
    return "$txt${spaces}"
  } else {
    return "${spaces}$txt"
  }
}
# }}}
# adjust_txt
# {{{
proc adjust_txt {ctrl txt} {
  set tlength 0

# Calculate txt length
  foreach word [split $txt ""] {
    set wlength [string bytelength $word]
    if {$wlength == "3"} {
      set tlength [expr $tlength + 2]
    } elseif {$wlength == "1"} {
      set tlength [expr $tlength + 1]
    } else {
      puts "Error in length."
    }
  }

  if {$ctrl == ""} {
    set ctrl 10
  }
  set absctrl [expr abs($ctrl)]
  if {$absctrl > $tlength} {
    set space_count [expr $absctrl - $tlength]
    if {$ctrl > 0} {
      set space_added [addspace $txt $space_count +]
    } else {
      set space_added [addspace $txt $space_count -]
    }
  } else {
    set space_added $txt
  }
  return $space_added
}
# }}}
# mformat
# {{{
proc mformat {args} {
  set ff [lindex $args 0]

  set alength [llength $args]

  for {set i 1} {$i < $alength} {incr i} {
    regexp {%(-*\d*?)s} $ff -> ctrl($i)
    regsub {%-*\d*?s} $ff "!$i@" ff
  }

  for {set i 1} {$i < $alength} {incr i} {
    set orig_txt [lindex $args $i]
    set txtarr($i) [adjust_txt $ctrl($i) $orig_txt]
  }



  for {set i 1} {$i < $alength} {incr i} {
    regsub "!$i@" $ff $txtarr($i) ff
  }
  return $ff
}
# }}}
# p_col_num
# {{{
proc p_col_num {} {
  for {set i 0} {$i <= 9} {incr i} {
    puts -nonewline "${i}${i}${i}${i}${i}${i}${i}${i}${i}${i}"
  }
  puts ""
  for {set i 0} {$i < 100} {incr i} {
    puts -nonewline [expr $i % 10]
  }
  puts ""
}
# }}}
# dirdu
# {{{
proc dirdu {{pattern *}} {
  set dirs [glob -nocomplain -type d $pattern]
  foreach dir [lsort $dirs] {
    catch {exec du -sh $dir/} result
    puts "	$result"
  }
}
# }}}
# gwaive
# {{{
proc gwaive {args} {
  if [file exist .godel/vars.tcl] {
    source .godel/vars.tcl
  }
  # -w (waive file)
# {{{
  set opt(-w) 0
  set idx [lsearch $args {-w}]
  if {$idx != "-1"} {
    set waivefile [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-w) 1
  } else {
    set waivefile NA
  }
# }}}
  # -key (keyname)
# {{{
  set opt(-key) 0
  set idx [lsearch $args {-key}]
  if {$idx != "-1"} {
    set keyname [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-key) 1
    set vars($keyname,pre_waive)  0
    set vars($keyname,post_waive) 0
    set vars($keyname,waived)      0
  } else {
    set keyname NA
  }
# }}}


  set fname [lindex $args 0]

# Load waiver
  set waivers {}
  if {$opt(-w)} {
    set kin [open $waivefile r]
  } else {
    if [file exist $fname.waive] {
      set kin [open $fname.waive r]
    } else {
      puts "Error: not exist $fname.waiver"
      return
    }
  }
  while {[gets $kin line] >= 0} {
    if {[regexp {^#} $line]} {
    } elseif {[regexp {^$} $line]} {
    } else {
      lappend waivers $line
    }
  }
  close $kin

  set waived [open "$fname.waived" w]
  set kout   [open "$fname.pw" w]
# Apply waiver
  set kin [open $fname r]
    while {[gets $kin line] >= 0} {
      incr vars($keyname,pre_waive)

      set flag_waive 0
      foreach waiver $waivers {
        regsub -all {\[} $waiver {\\[} waiver
        regsub -all {\]} $waiver {\\]} waiver
        regsub -all {\/} $waiver {\\/} waiver
        if [regexp $waiver $line] {
          set flag_waive 1
          break
        }
      }

      if {$flag_waive} {
        incr arr($waiver)
        incr vars($keyname,waived)
        puts $waived $line
      } else {
        incr vars($keyname,post_waive)
        puts $kout $line
      }
    }
  close $kin
  close $kout
  close $waived

  if {$opt(-key)} {
    godel_array_save vars .godel/vars.tcl
  }

# Summary
  #parray arr
}
# }}}
# ghtm_filter_table
# {{{
proc ghtm_filter_table {tname column_no} {
  upvar fout fout
  puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">" 
  #puts $fout "<input type=text id=filter_table_input onkeyup=filter_table(\"$tname\",$column_no,event) placeholder=\"Search...\" autofocus>"
  puts $fout "<input type=text id=filter_table_input onkeyup=filter_table(\"$tname\",$column_no,event) placeholder=\"Search...\">"
  puts $fout "</div>" 
}
# }}}
# grefresh
# {{{
proc grefresh {path} {
  set org [pwd]
  cd $path
  godel_draw
  cd $org
}
# }}}
# hlwords
# {{{
proc hlwords {args} {
  upvar vars vars
  upvar rwords rwords

  set rwords $args
  set vars(hlwords) $args

  godel_array_save vars .godel/vars.tcl 
}
# }}}
# lchart_linebar
# {{{
proc lchart_linebar {args} {
  global fout
  global env
  # -f (filelist name)
# {{{
  set opt(-f) 0
  set idx [lsearch $args {-f}]
  if {$idx != "-1"} {
    set listfile [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-f) 1
  } else {
    set listfile NA
  }
# }}}
  # -c (columns)
# {{{
  set opt(-c) 0
  set idx [lsearch $args {-c}]
  if {$idx != "-1"} {
    set columns [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-c) 1
  }
# }}}
  # -colors (colors)
# {{{
  set opt(-colors) 0
  set idx [lsearch $args {-colors}]
  if {$idx != "-1"} {
    set colors [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-colors) 1
  } else {
    set colors [list green orange crimson maroon cyan ]
  }
# }}}
  # -size (size)
# {{{
  set opt(-size) 0
  set idx [lsearch $args {-size}]
  if {$idx != "-1"} {
    set size [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-size) 1
  }
# }}}
  # -name (name)
# {{{
  set opt(-name) 0
  set idx [lsearch $args {-name}]
  if {$idx != "-1"} {
    set name [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-name) 1
  }
# }}}
  # -xnames (x axles names)
# {{{
  set opt(-xnames) 0
  set idx [lsearch $args {-xnames}]
  if {$idx != "-1"} {
    set xnames [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xnames) 1
  }
# }}}

  if {$opt(-f)} {
    set kin [open $listfile r]
      while {[gets $kin line] >= 0} {
        if [regexp {^#} $line] {
        } elseif [regexp {^$} $line] {
        } else {
          lappend rowlist $line
        }
      }
    close $kin
  } else {
    set flist [lsort [glob -nocomplain */.godel]]
    foreach f $flist {
      lappend rowlist [file dirname $f]
    }
  }

  puts $fout "<div class=\"w3-panel w3-pale-white w3-leftbar w3-border-white\" style=\"width:$size;\">"
  puts $fout "<canvas id=\"$name\"></canvas>"
  puts $fout "</div>"
  if ![file exist "Chart.js"] {
    exec cp $env(GODEL_ROOT)/scripts/js/chartjs/Chart.js .
  }
  puts $fout "<script src=Chart.js></script>"
# data sets
# {{{
  puts $fout "<script>"
  puts $fout "var dset = {"
    foreach i $xnames {
      lappend rows   "\"$i\""
    }
    set x_axis   [join $rows   ,]

    puts $fout "        labels: \[$x_axis\],"
    puts $fout "        datasets: \["

    set counter 0
    foreach column $columns {
      #puts $column
      set values [list]
      set rows   [list]
      foreach i $rowlist {
        set value [lvars $i $column]
        if {$value == "NA"} {
          set value ""
        }
        lappend values $value
        lappend rows   "\"$i\""
      }
      set y_axis   [join $values ,]
      puts $fout "        {"
      if {$counter == "0"} {
        puts $fout "            type: \"line\","
        puts $fout "            yAxisID: \"y-axis-2\","
      } else {
        puts $fout "            type: \"bar\","
        puts $fout "            yAxisID: \"y-axis-1\","
      }
      puts $fout "            label: \"$column\","
      puts $fout "            backgroundColor: '[lindex $colors $counter]',"
      puts $fout "            borderColor: '[lindex $colors $counter]',"
      puts $fout "            data: \[$y_axis\],"
      puts $fout "            fill: false,"
      puts $fout "            lineTension: 0,"
      puts $fout "            spanGaps: true,"
      puts $fout "        },"

      incr counter
    }
  puts $fout "       \]"
  puts $fout "    };"
  puts $fout "</script>"
# }}}
# command file
# {{{
  puts $fout "<script>"
  puts $fout "var ctx = document.getElementById('$name').getContext('2d');"
  puts $fout ""
  puts $fout "var chart = new Chart(ctx, {"
  puts $fout "    type: 'bar',"
  puts $fout "    data: dset,"
  puts $fout "    options: {"
  puts $fout "        scales: {"
  puts $fout "            xAxes: \[{"
  puts $fout "              stacked: true"
  puts $fout "            }],"
  puts $fout "            yAxes: \[{"
  puts $fout "              stacked: true,"
  puts $fout "              position: 'left',"
  puts $fout "              id: 'y-axis-1',"
  puts $fout "            }, {"
  puts $fout "              stacked: true,"
  puts $fout "              position: 'right',"
  puts $fout "              id: 'y-axis-2',"
  puts $fout "            }]"
  puts $fout "        }"
  puts $fout "    }"
  puts $fout "});"
  puts $fout "</script>"
# }}}

}
# }}}
# lchart_bar
# {{{
proc lchart_bar {args} {
  global fout
  global env
# -f (filelist name)
# {{{
  set opt(-f) 0
  set idx [lsearch $args {-f}]
  if {$idx != "-1"} {
    set listfile [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-f) 1
  } else {
    set listfile NA
  }
# }}}
  # -c (columns)
# {{{
  set opt(-c) 0
  set idx [lsearch $args {-c}]
  if {$idx != "-1"} {
    set columns [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-c) 1
  }
# }}}
  # -g (groups)
# {{{
  set opt(-g) 0
  set idx [lsearch $args {-g}]
  if {$idx != "-1"} {
    set groups [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-g) 1
  } else {
    foreach c $columns {
      lappend groups 0
    }
  }
# }}}
  # -colors (colors)
# {{{
  set opt(-colors) 0
  set idx [lsearch $args {-colors}]
  if {$idx != "-1"} {
    set colors [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-colors) 1
  } else {
    set colors [list green orange crimson maroon cyan ]
  }
# }}}
  # -size (size)
# {{{
  set opt(-size) 0
  set idx [lsearch $args {-size}]
  if {$idx != "-1"} {
    set size [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-size) 1
  }
# }}}
  if {$opt(-f)} {
    set ilist [read_file_ret_list $listfile]
    set rowlist $ilist
  } else {
    set flist [glob -nocomplain */.godel]
    foreach f $flist {
      lappend rowlist [file dirname $f]
    }
  }

  puts $fout "<div style=\"width:$size%;\">"
  puts $fout "<canvas id=\"myChart\"></canvas>"
  puts $fout "</div>"
  if ![file exist "Chart.js"] {
    exec cp $env(GODEL_ROOT)/scripts/js/chartjs/Chart.js .
  }
  puts $fout "<script src=Chart.js></script>"
# data sets
# {{{
  puts $fout "<script>"
  puts $fout "var dset = {"
    foreach i $rowlist {
      lappend rows   "\"$i\""
    }
    set x_axis   [join $rows   ,]

    puts $fout "        labels: \[$x_axis\],"
    puts $fout "        datasets: \["

    set counter 0
    foreach column $columns group $groups {
      #puts $column
      set values [list]
      set rows   [list]
      foreach i $rowlist {
        set value [lvars $i $column]
        lappend values $value
        lappend rows   "\"$i\""
      }
      set y_axis   [join $values ,]
      puts $fout "        {"
      puts $fout "            label: \"$column\","
      puts $fout "            backgroundColor: '[lindex $colors $counter]',"
      puts $fout "            data: \[$y_axis\],"
      puts $fout "            fill: false,"
      puts $fout "            lineTension: 0,"
      puts $fout "            spanGaps: true,"
      puts $fout "            stack: '$group'"
      puts $fout "        },"

      incr counter
    }
  puts $fout "       \]"
  puts $fout "    };"
  puts $fout "</script>"
# }}}
# command file
# {{{
  puts $fout "<script>"
  puts $fout "var ctx = document.getElementById('myChart').getContext('2d');"
  puts $fout ""
  puts $fout "var chart = new Chart(ctx, {"
  puts $fout "    type: 'bar',"
  puts $fout "    data: dset,"
  puts $fout "    options: {"
  puts $fout "        scales: {"
  puts $fout "            xAxes: \[{"
  puts $fout "              stacked: true"
  puts $fout "            }],"
  puts $fout "            yAxes: \[{"
  puts $fout "              stacked: true"
  puts $fout "            }]"
  puts $fout "        }"
  puts $fout "    }"
  puts $fout "});"
  puts $fout "</script>"
# }}}

}
# }}}
# lchart_line
# {{{
proc lchart_line {args} {
  global fout
  global env
  set colors [list blue green orange crimson maroon cyan ]
# -f (filelist name)
# {{{
  set opt(-f) 0
  set idx [lsearch $args {-f}]
  if {$idx != "-1"} {
    set listfile [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-f) 1
  } else {
    set listfile NA
  }
# }}}
  # -c (columns)
# {{{
  set opt(-c) 0
  set idx [lsearch $args {-c}]
  if {$idx != "-1"} {
    set columns [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-c) 1
  }
# }}}
  if {$opt(-f)} {
    set ilist [read_file_ret_list $listfile]
  } else {
    set flist [glob -nocomplain */.godel]
    foreach f $flist {
      lappend rowlist [file dirname $f]
    }
  }

# line_dset.js (data sets)
# {{{
  set kout [open ".godel/lchart_line_dset.js" w]
  puts $kout "var line_dset = {"
    foreach i $rowlist {
      lappend rows   "\"$i\""
    }
    set x_axis   [join $rows   ,]

    puts $kout "        labels: \[$x_axis\],"
    puts $kout "        datasets: \["

    set counter 0
    foreach column $columns {
      #puts $column
      set values [list]
      set rows   [list]
      foreach i $rowlist {
        set value [lvars $i $column]
        lappend values $value
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
  set kout [open ".godel/lchart_line_cmd.js" w]
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

  #puts $fout "<div style=\"width:$attr(ghtm_table_line,size);\">"
  puts $fout "<div style=\"width:50%;\">"
  puts $fout "<canvas id=\"myChart\"></canvas>"
  puts $fout "</div>"
  puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/chartjs/Chart.js]></script>"
  puts $fout "<script src=.godel/lchart_line_dset.js></script>"
  puts $fout "<script src=.godel/lchart_line_cmd.js></script>"

}
# }}}
# lapvar
# {{{
proc lapvar {name key value} {
  regsub {\/$} $name {} name

  set varfile $name/.godel/vars.tcl

  if [file exist $varfile] {
 #   puts $varfile
    source $varfile
    lappend vars($key) $value
  } else {
    puts "Error: not exist... $varfile"
  }

  godel_array_save vars $varfile
}
# }}}
# lsetvar
# {{{
proc lsetvar {name key value} {
  regsub {\/$} $name {} name

  set varfile $name/.godel/vars.tcl

  if [file exist $varfile] {
 #   puts $varfile
    source $varfile
    set vars($key) $value
    godel_array_save vars $varfile
  } else {
    puts "Error: not exist... $varfile"
  }

}
# }}}
# lsetdyvar
# {{{
proc lsetdyvar {name key value} {
  set varfile $name/.godel/dyvars.tcl

  if [file exist $varfile] {
    source $varfile
    set dyvars($key) $value
  } else {
    set kout [open $varfile w]
    close $kout
    set dyvars($key) $value
  }

  godel_array_save dyvars $varfile
}
# }}}
# lvars
# {{{
proc lvars {args} {

  # -k (keyword)
# {{{
  set opt(-k) 0
  set idx [lsearch $args {-k}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-k) 1
  }
# }}}
  # -pvar (path var)
# {{{
  set opt(-pvar) 0
  set idx [lsearch $args {-pvar}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-pvar) 1
  }
# }}}
  set gpage [lindex $args 0]
  set vname  [lindex $args 1]

  if {$gpage == ""} {
    set gpage "."
  }
  if ![file exist $gpage/.godel/vars.tcl] {
    #puts "Error: not exist... $gpage/.godel/vars.tcl"
    return
  }
  source $gpage/.godel/vars.tcl

  set vlist ""
  if {$vname == ""} {
    parray vars
  } else {
    if {$opt(-k)} {
      foreach name [lsort [array names vars]] {
        if [setop_and_hit $vname $name] {
          puts [format "%-20s = %s" $name $vars($name)]
          lappend klist [list $name $vars($name)]
          set vlist [concat $vlist $vars($name)]
        }
      }
    } else {
      if [info exist vars($vname)] {

        if {$opt(-pvar)} {
          set txt ""
          foreach path $vars($vname) {
            set fname [file tail $path]
            append txt "$fname\n"
          }
          return $txt
        } else {
          return $vars($vname)
        }
      } else {
        return NA
      }
    }
  }
}
# }}}
# local_table
# {{{
proc local_table {name args} {
  global fout
  upvar vars vars
  upvar ltblrows ltblrows
  if ![info exist ltblrows] {
    set ltblrows ""
  }

  # -exclude
# {{{
  set opt(-exclude) 0
  set idx [lsearch $args {-exclude}]
  if {$idx != "-1"} {
    set exclude_pattern [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-exclude) 1
  }
# }}}
  # -f (filelist name)
# {{{
  set opt(-f) 0
  set idx [lsearch $args {-f}]
  if {$idx != "-1"} {
    set listfile [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-f) 1
  } else {
    set listfile NA
  }
# }}}
  # -c (columns)
# {{{
  set opt(-c) 0
  set idx [lsearch $args {-c}]
  if {$idx != "-1"} {
    set columns [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-c) 1
  }
# }}}
  # -w (width)
# {{{
  set opt(-w) 0
  set idx [lsearch $args {-w}]
  if {$idx != "-1"} {
    set width [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-w) 1
  }
# }}}
  # -row_style_proc (row_style_proc)
# {{{
  set opt(-row_style_proc) 0
  set idx [lsearch $args {-row_style_proc}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-row_style_proc) 1
  }
# }}}
  # -css (css class)
# {{{
  set opt(-css) 0
  set idx [lsearch $args {-css}]
  if {$idx != "-1"} {
    set css_class [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-css) 1
  } else {
    set css_class table1
  }
# }}}
  # -linkcol (link column)
# {{{
  set opt(-linkcol) 0
  set idx [lsearch $args {-linkcol}]
  if {$idx != "-1"} {
    set linkcol [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-linkcol) 1
  } else {
    set linkcol "g:pagename"
  }
# }}}
  # -fontsize (font size)
# {{{
  set opt(-fontsize) 0
  set idx [lsearch $args {-fontsize}]
  if {$idx != "-1"} {
    set fontsize [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-fontsize) 1
  } else {
    set fontsize "g:pagename"
  }
# }}}
  # -sortby (sort by...)
# {{{
  set opt(-sortby) 0
  set idx [lsearch $args {-sortby}]
  if {$idx != "-1"} {
    set sortby [lindex $args [expr $idx + 1]]
    if {[regexp {;d} $sortby]} {
      regsub {;d} $sortby {} sortby
      set sort_direction "-decreasing"
    } else {
      set sort_direction "-increasing"
    }
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-sortby) 1
  }
# }}}
  # -serial (serial numbers)
# {{{
  set opt(-serial) 0
  set idx [lsearch $args {-serial}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-serial) 1
  }
# }}}
  # -save
# {{{
  set opt(-save) 0
  set idx [lsearch $args {-save}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-save) 1
  }
# }}}
  # -revert
# {{{
  set opt(-revert) 0
  set idx [lsearch $args {-revert}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-revert) 1
  }
# }}}

  # create rows
  # {{{
  set rows ""
  if {$ltblrows eq ""} {
    if {$opt(-f)} {
      if [file exist $listfile] {
        #set rows [read_file_ret_list $listfile]
        set kin [open $listfile r]

        while {[gets $kin line] >= 0} {
          if {[regexp {^\s*#} $line]} {
          } elseif {[regexp {^\s*$} $line]} {
          } else {
            lappend rows $line
          }
        }
        close $kin
      } else {
        puts "Errors: Not exist... $listfile"
        return
      }
    } else {
      if {$opt(-revert)} {
        set flist [lsort -decreasing [glob -nocomplain */.godel]]
      } else {
        set flist [lsort [glob -nocomplain */.godel]]
      }
      foreach f $flist {
        lappend rows [file dirname $f]
      }
    }
  } else {
    set rows $ltblrows
  }
  # }}}
  #
  if {$opt(-exclude)} {
    set exdirs [glob -nocomplain {*}$exclude_pattern]
  }

  if {$opt(-save)} {
    puts $fout "<button id=\"save\">Save</button>"
  }
  if {$opt(-fontsize)} {
    puts $fout "<style>"
    puts $fout ".table1 td, .table1 th {"
    puts $fout "font-size : $fontsize;"
    puts $fout "}"
    puts $fout "</style>"
  }
  puts $fout "<table class=$css_class id=$name>"
# Table Headers
# {{{
  puts $fout "<tr>"
  if {$opt(-serial)} {
    puts $fout "<th>Num</th>"
  }
  foreach col $columns {
    set colname ""
    if [regexp {;} $col] {
      regexp {;(\S+)} $col -> colname

      if {$colname == ""} {
        puts $fout "<th></th>"
      } else {
        puts $fout "<th>$colname</th>"
      }
    } else {
      set colname $col
      puts $fout "<th>$colname</th>"
    }
  }
  puts $fout "</tr>"
# }}}

  # Sort by...
# {{{
  if {$opt(-sortby)} {
    set index_num 1

    ## Create row_items for sorting
    set row_items {}
    foreach row $rows {
      set sdata [lvars $row $sortby]
      if {$sdata eq ""} {
        set sdata "NA"
      }
      lappend row_items [concat $row $sdata]
    }

    ## Sorting...
    set row_items [lsort -index 1 $sort_direction $row_items]

    # Re-create rows based on sorted row_items
    set rows {}
    foreach i $row_items {
      lappend rows [lindex $i 0]
    }
  }
# }}}
#
  if {$opt(-exclude)} {
    set rows [setop_restrict $rows $exdirs]
  }

  set serial 1
#--------------------
# For each table row
#--------------------
  foreach row $rows {
    set row_style {}

    # row_style_proc
    if {$opt(-row_style_proc)} {
      row_style_proc
    }

    puts $fout "<tr style=\"$row_style\">"

    if {$opt(-serial)} {
      puts $fout "<td><a href=$row/.index.htm>$serial</a></td>"
    }
    #----------------------
    # For each table column
    #----------------------
    foreach col $columns {
      set celltxt {}
      # Remove column width
      regsub {;\S+} $col {} col

      # Get column data
      # img:
      if [regexp {img:} $col] {
        regsub {img:} $col {} col
        set coverfile [glob -nocomplain $row/cover.*]
        if {$coverfile eq ""} {
          set coverfile "cover.jpg"
        }
        append celltxt "<td><a href=$coverfile><img height=100px src=$coverfile></a></td>"
      # exe_button:
      } elseif [regexp {exe_button:} $col] {
        regsub {exe_button:} $col {} col
        set execmd [lvars $row execmd]
        append celltxt "<td><a href=$row/.$execmd.gtcl class=\"w3-btn w3-teal\" type=text/gtcl>$execmd</a><a class=\"w3-button w3-lime\" href=$row/$execmd type=text/txt>cmd</a></td>"

      # proc:
      } elseif [regexp {proc:} $col] {
        regsub {proc:} $col {} col
        set procname $col
        eval $procname
      # flist:
      } elseif [regexp {flist:} $col] {
        regsub {flist:} $col {} col
        regsub -all {\[} $row {\\[} dir
        regsub -all {\]} $dir {\\]} dir
        #set files ""
        #foreach co $col {
        #  lappend files [glob -nocomplain $dir/$co]
        #}
        set files [glob -nocomplain $dir/$col]
        set links {<pre>}
        foreach f $files {
          set name [file tail $f]
          if [regexp {\.pdf} $name] {
            append links "<a href=\"$f\" type=text/pdf>$name</a>\n"
          } elseif [regexp {\.htm*} $name] {
            append links "<a href=\"$f\">$name</a>\n"
          } else {
            append links "<a href=\"$f\" type=text/txt>$name</a>\n"
          }
        }
        append links {</pre>}
        append celltxt "<td>$links</td>"
      # md:
      } elseif [regexp {md:} $col] {
        regsub {md:} $col {} col
        set fname $row/$col.md
        if [file exist $fname] {
          set aftermd [gmd_file $fname]
          append celltxt "<td>$aftermd</td>"
        } else {
          set kout [open $fname w]
          puts $kout " "
          close $kout
          append celltxt "<td> </td>"
        }
      # edtable:
      } elseif [regexp {edtable:} $col] {
        regsub {edtable:} $col {} col
        set dirname [file dirname $col]
        if {$dirname eq "."} {
          #puts "$col $dirname"
          set page_path $row
          set page_key  $col
        } else {
          set page_path $row/$dirname
          set page_key  [file tail $col]
          #puts $page_path
        }
        set col_data [lvars $page_path $page_key]
        if {$col_data eq "NA"} {
          set col_data ""
        }
        append celltxt "<td gname=$page_path colname=$page_key contenteditable=true>$col_data</td>"
      # ed:
      } elseif [regexp {ed:} $col] {
        regsub {ed:} $col {} col
        set fname $row/$col
        if [file exist $fname] {
          append celltxt "<td><a href=\"$fname\" type=text/txt>E</a></td>"
        } else {
          append celltxt "<td></td>"
        }
      } else {
        set dirname [file dirname $col]
        if {$dirname eq "."} {
          set page_path $row
          set page_key  $col
        } else {
          set page_path $row/$dirname
          set page_key  [file tail $col]
        }
        set col_data [lvars $page_path $page_key]
        if {$col_data eq "NA"} {
          set col_data ""
        }

        if {$col == "g:pagename"} {
          set col_data "<a href=\"$row/.index.htm\">$col_data</a>"
        }
        append celltxt "<td>$col_data</td>"
      }
      puts $fout $celltxt
    }

    puts $fout "</tr>"
    incr serial
  }
  puts $fout "</table>"

}
# }}}
# clone_godel
# {{{
proc clone_godel {path} {
  puts $path/.godel
  exec cp $path/.godel/ghtm.tcl .godel
  exec cp $path/.godel/vars.tcl .godel
}
# }}}
# ghtm_begin
# {{{
proc ghtm_begin {ofile} {
  global fout
  global env

  set fout [open $ofile w]

  puts $fout "<!DOCTYPE html>"
  puts $fout "<html>"
  puts $fout "<head>"
  puts $fout "<title>$ofile</title>"

  #puts $fout "<style>"
  #set fin [open $env(GODEL_ROOT)/etc/css/w3.css r]
  #  while {[gets $fin line] >= 0} {
  #    puts $fout $line
  #  }
  #close $fin
  puts $fout "<link rel=\"stylesheet\" type=\"text/css\" href=\".godel/w3.css\">"
  #puts $fout "</style>"

  puts $fout "<meta charset=utf-8>"
  puts $fout "</head>"
  puts $fout "<body>"
}
# }}}
# ghtm_end
# {{{
proc ghtm_end {} {
  global fout

  puts $fout "</body>"
  puts $fout "</html>"

  close $fout
}
# }}}
# cshpath
# {{{
proc cshpath {} {
# List PATH in csh
  global env
  set ilist [split $env(PATH) :]
  foreach i [lsort -unique $ilist] {
    puts $i
  }
}
# }}}
# lremove
# {{{
proc lremove {target_list item} {
  set a [lsearch -all -inline -not -exact $target_list $item]
  return $a
}
# }}}
# gdraw_default
# {{{
proc gdraw_default {} {
  upvar env env
  set kout [open .godel/ghtm.tcl w]
    puts $kout "ghtm_top_bar"
    puts $kout "#ghtm_top_bar -save -filter 1"
    #puts $kout "#list_img 4 100% images/*"
    puts $kout "#lappend cols \"proc:ltbl_iname g:iname;Name\""
    puts $kout "#lappend cols \"edtable:bday;bday\""
    puts $kout "#lappend cols \"edtable:g:keywords;Keywords\""
    puts $kout "#local_table tbl -c \$cols"
    puts $kout "ghtm_ls *"
    #puts $kout "ghtm_list_files *"
    #puts $kout "#ghtm_filter_notes"
    puts $kout "gnotes {"
    puts $kout ""
    puts $kout "}"
  close $kout

  set kout [open .godel/draw.gtcl w]
    puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
    puts $kout "set pagepath \[file dirname \[file dirname \[info script\]\]\]"
    puts $kout "cd \$pagepath"
    puts $kout "if \[file exist \$env(GODEL_DOWNLOAD)/gtcl.tcl\] {"
    puts $kout "  source      \$env(GODEL_DOWNLOAD)/gtcl.tcl"
    puts $kout "  file delete \$env(GODEL_DOWNLOAD)/gtcl.tcl"
    puts $kout "}"
    puts $kout "godel_draw"
    puts $kout "exec xdotool search --name \"Mozilla\" key ctrl+r"
  close $kout

  set kout [open .godel/open.gtcl w]
    puts $kout "set pagepath \[file dirname \[file dirname \[info script\]\]\]"
    puts $kout "cd \$pagepath"
    #puts $kout "exec nautilus . &"
    puts $kout "exec xterm -T xterm.\[pwd] &"

  close $kout
}
# }}}
# datediff
# {{{
proc datediff {date2 date1 {type dd}} {
# datediff 2019/3/2 2019/1/3 hh

  set d2 [exec date -d "$date2" +%s]
  set d1 [exec date -d "$date1" +%s]

  if {$type == "ss"} {
    return [expr ($d2 - $d1)]
  } elseif {$type == "mm"} {
    return [expr ($d2 - $d1)/60]
  } elseif {$type == "hh"} {
    return [expr ($d2 - $d1)/3600]
  } elseif {$type == "dd"} {
    return [expr ($d2 - $d1)/86400]
  }

}
# }}}
# gdall, gd all
# {{{
proc gdall {} {
  set dirs [glob -type d *]
  foreach dir $dirs {
    puts $dir
    cd $dir
    godel_draw
    cd ..
  }
}
# }}}
# deln: de-link
# {{{
proc deln {args} {
  set files [glob {*}$args]
  foreach file $files {
    if [file exist $file] {
      puts $file
      set lnpath [file readlink $file]
      exec mv $file .$file
      exec cp $lnpath .
    }
  }
}
# }}}
# reln: re-link
# {{{
proc reln {args} {
  set files [glob {*}$args]
  foreach file $files {
    if [file exist .$file] {
      puts $file
      exec rm $file
      exec mv .$file $file
    }
  }
}
# }}}
# html_rows_sort
# {{{
proc html_rows_sort {rows args} {
  # -c 
# {{{
  set opt(-c) 0
  set idx [lsearch $args {-c}]
  if {$idx != "-1"} {
    set column_num [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-c) 1
  } else {
    set column_num 0
  }
# }}}

  # -p 
# {{{
  set opt(-p) 0
  set idx [lsearch $args {-p}]
  if {$idx != "-1"} {
    set parameter [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-p) 1
  } else {
    set parameter ""
  }
# }}}

  set rows2 {}
  foreach row $rows {
    set data [lindex $row $column_num]
    regsub -all {<[^>]*>} $data {} data
    lappend rows2 [list $row $data]
  }

  if {$opt(-p)} {
    set rows3 [lsort -index end {*}$parameter $rows2]
  } else {
    set rows3 [lsort -index end $rows2]
  }

  foreach r $rows3 {
    lappend sorted_rows [lindex $r 0]
  }
  return $sorted_rows
}
# }}}
# time_now
# {{{
proc time_now {} {
  set timestamp [clock format [clock seconds] -format {%Y-%m-%d_%H-%M_%S}]
  return $timestamp
}
# }}}
# list_pages
# {{{
proc list_pages {args} {
  upvar fout fout
  # -k (key)
# {{{
  set opt(-k) 0
  set idx [lsearch $args {-k}]
  if {$idx != "-1"} {
    set key  [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-k) 1
  }
# }}}
  # -t (title)
# {{{
  set opt(-t) 0
  set idx [lsearch $args {-t}]
  if {$idx != "-1"} {
    set title [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-t) 1
  }
# }}}
  # -n (newline)
# {{{
  set opt(-n) 0
  set idx [lsearch $args {-n}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-n) 1
  }
# }}}

  if {$args == ""} {
    set nlist [glob -type d *]
  } else {
    set nlist [list {*}$args]
  }

  puts $fout "<div class=\"gnotes w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"
# Title
  if {$opt(-t)} {
    puts $fout "<h1>$title</h1>"
  }
# List pages
  foreach page $nlist {
    if ![file exist $page/.godel] {
      continue
    }
    if {$opt(-k)} {
      set disp [lvars $page $key]
    } else {
      set disp [lvars $page g:pagename]
    }
    if {$opt(-n)} {
      # With newline
      puts $fout "<a class=hbox2 href=$page/.index.htm>$disp</a><br>"
    } else {
      # Single line
      puts $fout "<a class=hbox2 href=$page/.index.htm>$disp</a>"
    }
  }
  puts $fout "</div>"
}
# }}}
# glocal, gl
# {{{
proc glocal {args} {
  global env

  set name_width 35
# .gll.conf
# {{{
  if [file exist .gl.conf] {
    source .gl.conf
  } elseif [file exist $env(HOME)/.gl.conf] {
    source $env(HOME)/.gl.conf
  }
# }}}
  # -f
  set opt(-f) 0
  set idx [lsearch $args {-f}]
  if {$idx != "-1"} {
    set listfile [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-f) 1
  } else {
    set listfile NA
  }
  # -n, use -n to select item
# {{{
  set idx [lsearch $args {-n}]
  if {$idx != "-1"} {
    set serial_no [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
  } else {
    set serial_no no
  }
# }}}
  # -del (local)
# {{{
  set opt(-del) 0
  set idx [lsearch $args {-del}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-del) 1
  }
# }}}
  set keywords $args

  set ilist [list]
  if {$opt(-f)} {
    set kin [open $listfile r]
      while {[gets $kin line] >= 0} {
        if {[regexp {^\s*#} $line]} {
        } elseif {[regexp {^\s*$} $line]} {
        } else {
          lappend ilist $line
        }
      }
    close $kin
  } else {
    set flist [lsort [glob -nocomplain */.godel]]
    foreach f $flist {
      lappend ilist [file dirname $f]
    }
  }

  set found_names $ilist
#  set found_names [list]
# Search pagelist
#  foreach i $ilist {
#    set found 1
## Is it match with $meta(keys)
#    foreach k $keywords {
#      if [info exist meta($i,keys)] {
#        if {[lsearch -regexp $meta($i,keys) $k] >= 0} {
#          set found [expr $found&&1]  
#        } else {
#          set found [expr $found&&0]  
#        }
#      } else {
#        set found [expr $found&&0]  
#      }
#    }
#
#    if {$found} {
#      lappend found_names $i
#    }
#  }

  if {$found_names == ""} {
    puts stderr "Not found... $keywords"
  } else {
# If more than 1 page found, display them
    if {[llength $found_names] > 0} {
      if {$serial_no == "no"} {
        set linenum 1
        foreach i $found_names {
            set disp ""
# name
#          append disp [format "%${name_width}s " $i]

# File `.co' specify columns wanted to display
            set cols {}
            if [file exist .co] {
              set fin [open .co r]
                while {[gets $fin line] >= 0} {
                  set width -20 ;# default width

                  if [regexp {^#} $line] {
                  } else {
                    regexp {;(\S*)} $line whole width
                    regsub {;\S*} $line {} line
                    lappend cols "$line $width"
                  }
                }
              close $fin
            } else {
              set cols "g:pagename g:keywords"
            }
# Prepare `$disp'
            foreach col $cols {
              set name  [lindex $col 0]
              set width [lindex $col 1]
              append disp [mformat "%${width}s " [lvars $i $name]]
              #append disp [mformat "%-25s " [lvars $i $name]]
            }
            #puts stderr [format "%-3s %s" $linenum $disp]
            puts [format "%-3s %s" $linenum $disp]
          incr linenum
        }
      } ; # End serial_no == no
# If only 1 page found, cd to it
    #} else {
    #  #puts "cd $meta($found_names,where)"
    #  set i $found_names
    #  puts stderr [format "%-35s = %s" $i $meta($i,keywords)]

    #  if {$opt(-del)} {
    #    puts $meta($i,where)
    #    file delete -force $meta($i,where)
    #  }
    #}
  }
  return $found_names
} ; # End glocal

# }}}
# glist, gl
# {{{
proc glist {args} {
  global env

  set name_width 35
# .gll.conf
# {{{
  if [file exist .gl.conf] {
    source .gl.conf
  } elseif [file exist $env(HOME)/.gl.conf] {
    source $env(HOME)/.gl.conf
  }
# }}}
  # -f
  set opt(-f) 0
  set idx [lsearch $args {-f}]
  if {$idx != "-1"} {
    set listfile [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-f) 1
  } else {
    set listfile NA
  }
  # -n, use -n to select item
# {{{
  set idx [lsearch $args {-n}]
  if {$idx != "-1"} {
    set serial_no [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
  } else {
    set serial_no no
  }
# }}}
  # -l (local)
# {{{
  set opt(-l) 0
  set idx [lsearch $args {-l}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-l) 1
  }
# }}}
  # -del (local)
# {{{
  set opt(-del) 0
  set idx [lsearch $args {-del}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-del) 1
  }
# }}}
  set keywords $args

  if {$opt(-l)} {
    if [file exist .godel/indexing.tcl] {
      source .godel/indexing.tcl
    } else {
      puts stderr "Error: Not exist... .godel/indexing.tcl "
      return
    }
  }

  set ilist [list]
  if {$opt(-f)} {
    set kin [open $listfile r]
      while {[gets $kin line] >= 0} {
        lappend ilist $line
      }
    close $kin
  } else {
    foreach i [lsort [array name meta *,where]] {
      regsub ",where" $i "" i
      lappend ilist $i
    }
  }

  set found_names [list]
# Search pagelist
  foreach i $ilist {
    set found 1
# Is it match with $meta(keys)
    foreach k $keywords {
      if [info exist meta($i,keys)] {
        if {[lsearch -regexp $meta($i,keys) $k] >= 0} {
          set found [expr $found&&1]  
        } else {
          set found [expr $found&&0]  
        }
      } else {
        set found [expr $found&&0]  
      }
    }

    if {$found} {
      lappend found_names $i
    }
  }

  if {$found_names == ""} {
    puts stderr "Not found... $keywords"
  } else {
# If more than 1 page found, display them
    if {[llength $found_names] > 0} {
      if {$serial_no == "no"} {
        set linenum 1
        foreach i $found_names {
          if [info exist meta($i,keywords)] {
            set disp ""
# name
#          append disp [format "%${name_width}s " $i]

# File `.co' specify columns wanted to display
            set cols {}
            if [file exist .co] {
              set fin [open .co r]
                while {[gets $fin line] >= 0} {
                  set width -20 ;# default width

                  if [regexp {^#} $line] {
                  } else {
                    regexp {;(\S*)} $line whole width
                    regsub {;\S*} $line {} line
                    lappend cols "$line $width"
                  }
                }
              close $fin
            } else {
              set cols "g:pagename g:keywords"
            }
# Prepare `$disp'
            foreach col $cols {
              set name  [lindex $col 0]
              set width [lindex $col 1]
              append disp [format "%${width}s " [gvars $i $name]]
            }
            puts stderr [format "%-3s %s" $linenum $disp]
          }
          incr linenum
        }
      } ; # End serial_no == no
# If only 1 page found, cd to it
    #} else {
    #  #puts "cd $meta($found_names,where)"
    #  set i $found_names
    #  puts stderr [format "%-35s = %s" $i $meta($i,keywords)]

    #  if {$opt(-del)} {
    #    puts $meta($i,where)
    #    file delete -force $meta($i,where)
    #  }
    #}
  }
  return $found_names
} ; # End glist

# }}}
# ge
# {{{
proc ge {cmd args} {
  eval $cmd {*}$args
}
# }}}
# listcomp
# {{{
proc listcomp {a b} {
#----------------
# compare list a with b
#----------------
  set diff {}
  foreach i $a {
    if {[lsearch -exact $b $i]==-1} {
      lappend diff $i
    }
  }
  return $diff
}
# }}}
# gmd
# {{{
proc gmd {args} {
  global env
  upvar fout fout
  upvar vars vars

  # -f (file name)
# {{{
  set opt(-f) 0
  set idx [lsearch $args {-f}]
  if {$idx != "-1"} {
    set fname [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-f) 1
  } else {
    set listfile NA
  }
# }}}

  regsub -all {\.md} $fname {} fname1
  regsub -all { } $fname1 {_} fname2

  if [file exist $fname2.md] {
# If not exist, create it...
  } else {
    set kout [open $fname2.md w]
      #puts $kout "<div>"
# This blank line is important. Without it the markdown processing will fail.
      #puts $kout "</div>"
      puts $kout "# $fname2"
      puts $kout ""
      puts $kout "<a href=$fname2.md type=text/txt>edit</a>"
      puts $kout ""
      puts $kout "@? $fname1"
    close $kout
  }

  set fp [open "$fname2.md" r]
    set content [read $fp]
  close $fp

  gnotes {*}$args $content
}
# }}}
# wsplit: word split
# {{{
proc wsplit {str sep} {
    set out {} 
    set sepLen [string length $sep]
    if {$sepLen < 2} {
        return [split $str $sep]
    }
    while {[set idx [string first $sep $str]] >= 0} {
        # the left part : the current element
        lappend out [string range $str 0 [expr {$idx-1}]]
        # get the right part and iterate with it
        set str [string range $str [incr idx $sepLen] end]
    }
    # there is no separator anymore, but keep in mind the right part must be
    # appended
    lappend out $str
}
# }}}
# list_video
# {{{
proc list_video {pattern} {
  upvar fout fout
  set flist [glob {*}$pattern]
  foreach f $flist {
    puts $fout "<video width=320 height=240 controls preload=none>"
    #puts $fout "<video width=320 height=240 controls preload=auto>"
    puts $fout "<source src=\"$f\" type=video/mp4>"
    puts $fout "</video>"
  }
}
# }}}
# img_resize
# {{{
proc img_resize {pattern} {
  file mkdir resize

  set flist [glob {*}$pattern]
  foreach f $flist {
    puts "convert -resize 1024x -quality 80% $f resize/$f"
    catch {exec convert -resize 1024x -quality 80% $f resize/$f}
  }
}
# }}}
# gmd_file
# {{{
proc gmd_file {afile} {
  #puts [pwd]/$afile
  #set oridir [pwd]
  #cd [file dirname $afile]
  #puts [pwd]
  if [file exist $afile] {
    set kin [open $afile r]
      set ftxt [read $kin]
    close $kin
  } else {
    puts "Error in gmd_file: not exist... $afile"
  }

  #cd $oridir
  #puts $ftxt
  return [::gmarkdown::md_convert -f $afile -link rule $ftxt]
  #return [::gmarkdown::convert $ftxt]
}
# }}}
# csv_table
# {{{
proc csv_table {args} {
  global fout

  # -delim (delimiter)
# {{{
  set opt(-delim) 0
  set idx [lsearch $args {-delim}]
  if {$idx != "-1"} {
    set delim [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-delim) 1
  } else {
    set delim {,}
    #set delim {:}
  }
# }}}
  # -file
# {{{
  set opt(-file) 0
  set idx [lsearch $args {-file}]
  if {$idx != "-1"} {
    set fname [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-file) 1
  }
# }}}
  # -procs (proc to execute)
# {{{
  set opt(-procs) 0
  set idx [lsearch $args {-procs}]
  if {$idx != "-1"} {
    set procs [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-procs) 1
  }
# }}}

  if {$opt(-file)} {
    if [file exist $fname] {
      set kin [open $fname r]
        set content [read $kin]
      close $kin
    } else {
      return
    }
  } else {
    set content [lindex $args 0]
  }
  set lines [split $content \n]

  puts $fout "<table class=table1>"
  foreach line $lines {
    set cols [split $line $delim]
    puts $fout "<tr>"
    set colsize [llength $cols]

    for {set i 0} {$i < $colsize} {incr i} {
      set coldata [lindex $cols $i]
      if {$opt(-procs)} {
        foreach {colnum procname} [split $procs :] {}
        if {$i == $colnum} {
          $procname
        }
      }
      puts $fout "<td>$coldata</td>"
    }
    #foreach col $cols {
    #  puts $fout "<td>$col</td>"
    #}
    puts $fout "</tr>"
  }
  puts $fout "</table>"
}
# }}}
# gnotes
# {{{
proc gnotes {args} {
  global env
  upvar fout fout
  upvar vars vars
  upvar count count
  upvar meta meta

  # -link (code block link)
# {{{
  set opt(-link) 0
  set idx [lsearch $args {-link}]
  if {$idx != "-1"} {
    set opt(-link,suffix) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-link) 1
  }
# }}}

  # -qnote (quick note)
  set opt(-qnote) 0
  set idx [lsearch $args {-qnote}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-qnote) 1
  }

  set content [lindex $args 0]

  if {$content eq ""} {
    return
  }

  if {$opt(-qnote)} {
    puts $content
  }
  

# To allow `\' to display in code block
  regsub -all {\\ \n} $content "\\\n" content

# @) Get vars values
  set matches [regexp -all -inline {@\)(\S+)} $content]
  foreach {g0 g1} $matches {
    # @)dir/key
    if [regexp {\/} $g0] {
        set dir [file dirname $g0]
        regsub {@\)} $dir {} dir
        set key [file tail    $g0]
        set value [lvars $dir $key]
        regsub -all "@\\)$g1" $content $value content
    # @)key
    } else {
      if [info exist vars($g1)] {
        if {[llength $vars($g1)] > 1} {
          #set txt "\n"
          #foreach i $vars($g1) {
          #  append txt "                  $i\n"
          #}
          #regsub -all "@\\)$g1" $content $txt content
          regsub -all "@\\)$g1" $content $vars($g1) content
        } else {
          regsub -all "@\\)$g1" $content $vars($g1) content
        }
      } else {
        regsub -all "@\\)$g1" $content "<b>NA</b>($g1)" content
      }
    }
  }

# Markdown convertion
  set aftermd [::gmarkdown::convert $content]

  regsub -line -all {^<p>@\? (.*)</p>} $aftermd {<span class=keywords style=color:red>\1</span>} aftermd

  regsub -all {&lt;b&gt;NA&lt;/b&gt;} $aftermd <b>NA</b> aftermd

# @~ Link to gpage
# {{{
  set matches [regexp -all -inline {@~(\S+)} $aftermd]
  foreach {whole iname} $matches {
# Tidy up iname likes `richard_dawkins</p>'
    regsub {<\/p>} $iname {} iname

    set addr [gpage_where $iname]
    set pagename [gvars $iname g:pagename]
    set atxt "<a href=$addr>$pagename</a>"
    regsub -all "@~$iname" $aftermd $atxt aftermd
  }
# }}}

# @! Link to gpage as badge
# {{{
  set matches [regexp -all -inline {@!(\S+)} $aftermd]
  foreach {whole iname} $matches {
# Tidy iname likes `richard_dawkins</p>'
    regsub {<\/p>} $iname {} iname

    #set addr [gpage_where $iname]
    set pagename [lvars $iname g:pagename]
    puts "lvars $iname g:pagename"
    set atxt "<a class=hbox2 href=$iname/.index.htm>$pagename</a>"
    regsub -all "@!$iname" $aftermd $atxt aftermd
  }
# }}}

# @img() img
# {{{
  set matches [regexp -all -inline {@img\((\S+)\)} $aftermd]
  foreach {whole iname} $matches {
# Tidy iname likes `richard_dawkins</p>'
    regsub {<\/p>} $iname {} iname

#    set addr [gpage_where $iname]
#    set pagename [gvars $iname g:pagename]
    set atxt "<a href=$iname><img src=$iname style=\"float:right;width:30%\"></a>"
    #regsub -all {@img\(pmos} $aftermd $atxt aftermd
    regsub -all "@img\\($iname\\)" $aftermd $atxt aftermd
  }
# }}}

  puts $fout "<div class=\"gnotes w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"
  puts $fout $aftermd
  puts $fout "</div>"
}
# }}}
# ghtm_filter_notes
# {{{
proc ghtm_filter_notes {} {
  upvar fout fout
  puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">" 
#  puts $fout "<input type=text id=filter_input onKeyPress=filter_gnotes(event) placeholder=\"Search...\" autofocus>"
  puts $fout "<input type=text id=filter_input onKeyPress=filter_gnotes(event) placeholder=\"Search...\">"
  puts $fout "</div>" 
}
# }}}
# sset: silent set
# {{{
proc sset {varname value} {
 uplevel [list set $varname $value]
 return ""
}
# }}}
# list_img
# {{{
proc list_img {{N 4} {size 100%} {pattern "*.JPG *.PNG *.jpg *.png *.gif *.GIF"}} {
# list_img 4 100% img/*.png
  upvar fout fout
  set ilist [glob -nocomplain {*}$pattern]

  foreach partition [partitionlist $ilist $N] {
    puts $fout "<div class=w3-row>"
    foreach p $partition {
      set num [expr 12/$N]
      puts $fout "<div class=\"w3-col m$num\">"
      #puts $fout "<a href=\"$p\"><img src=\"$p\" style=width:$size><p style=font-size:10px>$p</p></a>"
      puts $fout "<a href=\"$p\"><img src=\"$p\"></a>"
      puts $fout {</div>}
    }
    puts $fout "</div>"
  }
}
# }}}
# partitionlist
# {{{
proc partitionlist {L {n 2}} { 
    incr n 0; # thanks to RS for this cool "is it an int" check! 
    set result {} 
    set limit [llength $L] 
    for {set p 0} {$p < $limit} {incr p $n} { 
        lappend result [lrange $L $p [expr {$p+$n-1}]] 
    } 
    return $result 
} 
# }}}
# lcount
# {{{
proc lcount {list} {
# count element number in a list
#% lcount {yes no no present yes yes no no yes present yes no no yes yes}
#{no 6} {yes 7} {present 2}
  foreach x $list {lappend arr($x) {}}
  set res {}
  foreach name [array names arr] {
     lappend res [list $name [llength $arr($name)]]
  }
  return $res
}
# }}}
# gvi
# {{{
proc gvi {keywords} {
  global env
  if [file exist $env(GODEL_CENTER)/gvi_list.tcl] {
    source       $env(GODEL_CENTER)/gvi_list.tcl
  } else {
    return
  }
  #puts $keywords

  set ilist [list]
  foreach i [array name meta *,file] {
# get page name
    regsub ",file" $i "" i
    lappend ilist $i
  }


  set found_names [list]
# Search pagelist
  foreach i $ilist {
    set found 1
# Is it match with keyword
    foreach k $keywords {
      if {[lsearch -regexp $meta($i,keywords) $k] >= 0} {
        set found [expr $found&&1]  
      } else {
        set found [expr $found&&0]  
      }
    }
    if {$found} {
      #puts "$found $i"
      lappend found_names $i
    }
  }

  if {$found_names == ""} {
    puts stderr "Not found... $keywords"
  } else {
    if {[llength $found_names] > 1} {
      foreach i [lsort $found_names] {
        #puts stderr $i
        puts stderr [format "%-35s %s" $i $meta($i,keywords)]
      }
    } else {
      #puts "vi $meta($found_names,file)"
      puts "vi +$meta($found_names,line) $meta($found_names,file)"
    }
  }

}
# }}}
# gok
# {{{
proc gok {keywords} {
  global env
  if [file exist $env(HOME)/.goklist.tcl] {
    source       $env(HOME)/.goklist.tcl
  } else {
    return
  }
# -n 
  set idx [lsearch $keywords {-n}]
  if {$idx != "-1"} {
    set serial_no [lindex $keywords [expr $idx + 1]]
    set keywords [lreplace $keywords $idx [expr $idx + 1]]
  } else {
    set serial_no no
  }

# -w
  set idx [lsearch $keywords {-w}]
  if {$idx != "-1"} {
    set w_yes yes
    set keywords [lreplace $keywords $idx $idx]
  } else {
    set w_yes no
  }

  set ilist [list]
  foreach i [lsort [array name meta *,where]] {
    regsub ",where" $i "" i
    lappend ilist $i
  }

  if {$w_yes} {
    if [file exist $meta($keywords,where)] {
      puts "cd $meta($keywords,where)"
    } else {
      puts stderr "Not exist... $meta($keywords,where)"
    }
  } else {
    set found_names [list]
  # Search pagelist
    foreach i $ilist {
      set found 1
  # Is it match with keyword
      foreach k $keywords {
        if {[lsearch -regexp $meta($i,keywords) $k] >= 0} {
          set found [expr $found&&1]  
        } else {
          set found [expr $found&&0]  
        }
      }
      if {$found} {
        #puts "$found $i"
        lappend found_names $i
      }
    }
  
    if {$found_names == ""} {
      puts stderr "Not found... $keywords"
    } else {
      if {[llength $found_names] > 1} {
        if {$serial_no == "no"} {
          set num 1
          foreach i $found_names {
            #puts stderr $i
            #puts stderr [format "%-3s %-35s %s" $num $i $meta($i,keywords)]
            puts stderr [format "%-3s %-35s %s" $num $i $meta($i,where)]
            incr num
          }
        } else {
          set name [lindex $found_names [expr $serial_no - 1]]
          if [file exist $meta($name,where)] {
            puts "cd $meta($name,where)"
          } else {
            puts stderr "Not exist... $meta($name,where)"
          }
        }
      } else {
        if [file exist $meta($found_names,where)] {
          puts "cd $meta($found_names,where)"
        } else {
          puts stderr "Not exist... $meta($found_names,where)"
        }
      }
    }
  }

}
# }}}
# cdk
# {{{
proc cdk {args} {
  global env

  source $env(GODEL_CENTER)/meta.tcl
  source $env(GODEL_CENTER)/indexing.tcl

  set keywords $args

  set ilist [list]
  foreach i [lsort [array name meta *,where]] {
    regsub ",where" $i "" i
    lappend ilist $i
  }

  set found_names [list]
# Search pagelist
  foreach i $ilist {
    set found 1
# Is it match with keyword
    foreach k $keywords {
      regsub {\/} $k {} k
      if [info exist meta($i,keywords)] {
        if {[lsearch -regexp $meta($i,keywords) $k] >= 0} {
          set found [expr $found&&1]  
        } else {
          set found [expr $found&&0]  
        }
      } else {
        set found [expr $found&&0]  
      }
    }

    if {$found} {
      lappend found_names $i
    }
  }

  if {$found_names == ""} {
    puts stderr "Not found... $keywords"
  } else {
# If more than 1 page found, display them
    if {[llength $found_names] > 1} {
      foreach i $found_names {
        if [info exist meta($i,keywords)] {
          if [file exist $meta($i,where)] {
            puts stderr [format "%-35s = %s" $i $meta($i,keywords)]
          } else {
            puts stderr [format "(NA)%-35s = %s" $i $meta($i,keywords)]
          }
        } else {
        }
      }
# If only 1 page found, cd to it
    } else {
      puts "cd $meta($found_names,where)"
    }
  }

}
# }}}
# money_convert
# {{{
proc money_convert {from to fromvalue} {
  set rate(GBP) 0.737
  set rate(TWD) 29.848
  set rate(RMB) 6.367
  set rate(USD) 1
  set N(B)   1000000000
  set N(M)   1000000
  set N(K)   1000
  set N(W)   10000
  set N(Y)   100000000
  set fromvalue [string toupper $fromvalue]
  #set N(_)   1
  ##set to [expr $from * 10]
  regsub -all {,} $fromvalue {} fromvalue

  regexp {([0-9.]*)([KWMYB]*)} $fromvalue whole value note
  #puts $value
  #puts $note
  if {$note != ""} {
    set fromvalue [expr ($value * $N($note))]
  }
  set tovalue [expr ($rate($to) * $fromvalue) / $rate($from)]
  set tovalue [format "%.2f" $tovalue]
  return $tovalue
}
# }}}
# lpush
# {{{
proc lpush {stack value} {
  upvar $stack list
  lappend list $value
}
# }}}
# lpop
# {{{
proc lpop {stack} {
  upvar $stack  list
  if [info exist list] {
    set value [lindex $list end]
    set list [lrange $list 0 [expr [llength $list]-2]]
    return $value
  } else {
    return ""
  }
}
# }}}
# ghtm_new_html
# {{{
proc ghtm_new_html {title} {
  global env
  set fout [open .toc.htm w]
  puts $fout "<!DOCTYPE html>"
  puts $fout "<html>"
  puts $fout "<head>"
  puts $fout "<title>$title</title>"
  puts $fout "<link rel=\"stylesheet\" href=[tbox_cygpath $env(GODEL_ROOT)/etc/css/w3.css]>"
  #puts $fout "<link rel=\"stylesheet\" href=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/prism/themes/prism-twilight.css] data-noprefix/>"
  puts $fout "<meta charset=utf-8>"
  puts $fout "</head>"
  puts $fout "<body>"
  puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/godel.js]></script>"
  puts $fout "<a href=.index.htm target=_top>Remove</a>"
  source .toc.tcl
  puts $fout "</body>"
  puts $fout "</html>"
  close $fout
}
# }}}
# ghtm_toc
# {{{
# Table Of Content
proc ghtm_toc {{mode ""} {begin_level 4} } {
# 
  global env
  upvar vars vars

  #upvar fout fout
  #puts $fout "<a href=.main.htm>TOC</a>"
  #puts $fout "<a href=.index.htm target=_top>Remove</a>"
  #puts $fout "<a href=.toc.tcl type=text/txt>toc.tcl</a>"

# toc.tcl
  if {$mode == "auto"} {
# always refresh .toc.tcl
    set kout [open .toc.tcl w]
      foreach i $vars(toc) {
        set level [lindex $i 0]
        # Adjust level according to begin_level
        regsub {h} $level {} level
        set level [expr $level - $begin_level + 1]
        if {$level < 1} {set level 1}
        set title [lindex $i 1]
        set id    [lindex $i 2]
        puts $kout "ghtm_chap $level \"$title\" \[gpage_where $vars(g:pagename)\]#$id"
      }
    close $kout
  } else {
# if .toc.tcl not exist, create it.
    if ![file exist .toc.tcl] {
      set kout [open .toc.tcl w]
        puts $kout "ghtm_chap L1 \"Chapter1\" \[gpage_where tcl_cmds\]"
      close $kout
    }
  }
# Create toc.htm
  #ghtm_new_html toc

# Create main.htm
#  set kout [open .main.htm w]
#    puts $kout {<!DOCTYPE html>}
#    puts $kout {<html> <head>}
#    puts $kout "<title>$vars(g:pagename)</title>"
#    puts $kout {<meta charset=utf-8>}
#    puts $kout {<frameset cols=25%,75%>}
#    puts $kout {　　<frame src=.toc.htm name=leftFrame >}
#    puts $kout {　　<frame src=.index.htm name=rightFrame >}
#    puts $kout {</frameset>}
#    puts $kout {</head> <body> </body> </html>}
#  close $kout
}
# }}}
# ghtm_chap
# {{{
proc ghtm_chap {level title {href ""} {id ""}} {
  upvar fout fout
  if {$href == ""} {
    puts $fout "<div class=L$level>$title</div>"
  } else {
    if {$id == ""} {
      puts $fout "<div class=L$level><a id=\"$title\" href=$href target=rightFrame>$title</a></div>"
    } else {
      puts $fout "<div class=L$level><a id=\"$title $id\" href=$href target=rightFrame>$title</a></div>"
    }
  }
}
# }}}
# gpage_where
# {{{
proc gpage_where {pagename} {
  global env env
  upvar meta meta

  #if [info exist meta] {
  #} else {
  #  mload default
  #}
  #if {$env(GODEL_IN_CYGWIN)} {
  #  if [info exist meta($pagename,where)] {
  #    return [tbox_cygpath $meta($pagename,where)]/.index.htm
  #  } else {
  #    return ".index.htm"
  #  }
  #} else {
  #  return $meta($pagename,where)/.index.htm
  #}
    return $meta($pagename,where)/.index.htm
}
# }}}
# num_symbol
# {{{
proc num_symbol {num {symbol B}} {
  set s(K) 1000
  set s(W) 10000
  set s(M) 1000000
  set s(Y) 100000000
  set s(B) 1000000000
  set s(G) 1000000000
  set s(T) 1000000000000
  if {$num eq "NA"} {
    return "NA"
  } elseif {$symbol eq "B"} {
    return [format_3digit [expr $num]]$symbol
  } else {
    regsub -all {,} $num {} num
    return [format_3digit [expr $num/$s($symbol)]]$symbol
  }
}
# }}}
# format_3digit
# {{{
proc format_3digit {num {sep ,}} {
    # Find the whole number and decimal (if any)
    set whole [expr int($num)]
    set decimal [expr $num - int($num)]

    #Basically convert decimal to a string
    set decimal [format %0.2f $decimal]
    #set decimal [format %.f $decimal]


    # If number happens to be a negative, shift over the range positions
    # when we pick up the decimal string part we want to keep
    if { $decimal <=0 } {
        set decimal [string range $decimal 2 4]
    } else {
        set decimal [string range $decimal 1 3]
    }

    # If $decimal is zero, then assign the default value of .00
    # and glue the formatted $decimal to the whole number ($whole)
    if { $decimal == 0} {
        #set num $whole.00
        set num $whole
    } else {
        set num $whole$decimal
    }

    # Take given number and insert commas every 3 positions
    while {[regsub {^([-+]?\d+)(\d\d\d)} $num "\\1$sep\\2" num]} {}
    # Were done; give the result back
    return $num
}
# }}}
# lgrep_index
# {{{
proc lgrep_index {ilist pattern {start_index 0}} {
  set size [llength $ilist]
  #puts $start_index
  regsub -all {\[} $pattern {\\[} pattern
  regsub -all {\]} $pattern {\\]} pattern

  for {set i $start_index} {$i <= $size} {incr i} {
    set line [lindex $ilist $i]
    if [regexp $pattern $line] {
      break;
    }
  }
  # No found
  if {$i > $size} {
    return -1
  } else {
    return $i
  }
}
# }}}
# godel_merge_proc
# {{{
proc godel_merge_proc {plist ofile} {
  set fout [open "m.tcl" w]
  foreach p $plist {
    set fin [open "dc_tcl/$p.tcl"]
      puts $fout "# $p"
      puts $fout "# {{{"
      while {[gets $fin line] >= 0} {
        puts $fout $line
      }
      puts $fout "# }}}"
    close $fin
  }
  puts $fout "# vim:fdm=marker"
  close $fout
}
# }}}
# godel_split_proc
# {{{
proc godel_split_proc {fname odir} {
  godel_split_by_proc $fname
  #puts $curs(size)
  file mkdir $odir
  set count $curs(size)
  for {set i 1} {$i <= $count} {incr i} {
    foreach line $curs($i,all) {
      if [regexp {^proc\s+(\S+) } $line whole matched] {
        set ofile_name $matched
        break
      }
    }
    set fout [open "$odir/$ofile_name.tcl" w]
      foreach line $curs($i,all) {
        puts $fout $line
      }
    close $fout
  }
}
# }}}
# godel_file_join
# {{{
proc godel_file_join {args} {
  foreach i $args {
    puts $i
  }
}
# }}}
# godel_split_by_proc
# {{{
proc godel_split_by_proc {afile} {
  upvar curs curs
  godel_array_reset curs
  set fin [open $afile r]
  set num 0
  set process_no 0
  while {[gets $fin line] >= 0} {
    if {[regexp {^proc} $line]} {
      incr num
    }

    if [regexp {^# } $line] {
    } elseif [regexp {^# \{\{\{} $line] {
    } elseif [regexp {^# \}\}\}} $line] {
    } elseif [regexp {^# vim} $line] {
    } else {
      lappend curs($num,all) $line
    }
  }
  close $fin
  set curs(size) $num
  #unset curs(0,all)
}
# }}}
# cput: color put
# {{{
proc cputs {text} {
  puts "\033\[0;36m%$text\033\[0m"
}
# }}}
# setop_restrict
# {{{
proc setop_restrict {a b} {
# from a and not in b
  set o {}
  foreach i $a {
    if {[lsearch $b $i] < 0} {lappend o $i}
  }
  return $o
}
# }}}
# setop_intersection
# {{{
proc setop_intersection {a b} {
# Both in a and b
  set o {}
  foreach i $a {
    if {[lsearch $b $i] >= 0} {lappend o $i}
  }
  return $o
}
# }}}
# setop_union
# {{{
proc setop_union {a b} {
# All element in a and b once i.e. join
  set o {}
  foreach i $a {
    if {[lsearch $b $i] < 0} {lappend o $i}
  }
  set o [concat $o $b]
  return $o
}
# }}}
# math_average
# {{{
proc math_average {alist} {
  expr ([join $alist +])/[llength $alist].
}
# }}}
# math_sum
# {{{
proc math_sum {alist} {
  expr ([join $alist +])
}
# }}}
# Godel Fundamental
# godel_draw
# {{{
proc godel_draw {{target_path NA}} {
  upvar env env
  if {$target_path == "NA" || $target_path == ""} {
  } else {
    set orgpath [pwd]
    cd $target_path
  }
  # If .freeze exist, do nothing. Page keeps the same.
# {{{
  if [file exist .freeze] {
    puts "INFO: No change to .index.htm. This page is frozen."
    return
  }
# }}}

  if [info exist env(GODEL_PLUGIN)] {
    if [file exist $env(GODEL_PLUGIN)] {
      source $env(GODEL_PLUGIN)
    }
  }

  package require gmarkdown
  upvar vars vars
  global env
  upvar argv argv

  file mkdir .godel
  # default vars
# {{{
  if [file exist .godel/vars.tcl] {
    source .godel/vars.tcl
  } else {
    set kout [open .godel/dyvars.tcl w]
    close $kout
    set kout [open .godel/vars.tcl w]
    close $kout
    set vars(g:keywords) ""
    set vars(g:pagename) [file tail [pwd]]
    set vars(g:iname)    [file tail [pwd]]
    godel_array_save vars   .godel/vars.tcl

  }
# }}}

  if [file exist .godel/dyvars.tcl] {
    source .godel/dyvars.tcl
  } else {
    set kout [open .godel/dyvars.tcl w]
    close $kout
  }
  set dyvars(last_updated) [clock format [clock seconds] -format {%Y-%m-%d_%H%M}]
  godel_array_save dyvars .godel/dyvars.tcl


# create draw.gtcl
# {{{
  #if ![file exist .godel/draw.gtcl] {
  #}
    set kout [open .godel/draw.gtcl w]
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "set pagepath \[file dirname \[file dirname \[info script\]\]\]"
      puts $kout "cd \$pagepath"
      puts $kout "if \[file exist \$env(GODEL_DOWNLOAD)/gtcl.tcl\] {"
      puts $kout "  source      \$env(GODEL_DOWNLOAD)/gtcl.tcl"
      puts $kout "  file delete \$env(GODEL_DOWNLOAD)/gtcl.tcl"
      puts $kout "}"
      puts $kout "godel_draw"
      puts $kout "exec xdotool search --name \"Mozilla\" key ctrl+r"

    close $kout
# }}}
  set kout [open .godel/open.gtcl w]
    puts $kout "set pagepath \[file dirname \[file dirname \[info script\]\]\]"
    puts $kout "cd \$pagepath"
    #puts $kout "exec nautilus . &"
    puts $kout "exec xterm -T xterm.\[pwd] &"

  close $kout

#----------------------------
# Start creating .index.htm
#----------------------------
  global fout
  set fout [open ".index.htm" w]

  puts $fout "<!DOCTYPE html>"
  puts $fout "<html>"
  puts $fout "<head>"
  if [info exist vars(g:title)] {
    puts $fout "<title>$vars(g:title)</title>"
  } else {
    puts $fout "<title>$vars(g:pagename)</title>"
  }

# Hardcoded w3.css in .index.htm so that you have all in one file.
# {{{
## }}}

  if {$env(GODEL_ALONE)} {
# Standalone w3.css
      exec cp $env(GODEL_ROOT)/etc/css/w3.css .godel/w3.css
      puts $fout "<link rel=\"stylesheet\" type=\"text/css\" href=\".godel/w3.css\">"
  } else {
# Link to Godel's central w3.css
# {{{
    if {$env(GODEL_EMB_CSS)} {
      puts $fout "<style>"
      set fin [open $env(GODEL_ROOT)/etc/css/w3.css r]
        while {[gets $fin line] >= 0} {
          puts $fout $line
        }
      close $fin
      puts $fout "</style>"
    } else {
      puts $fout "<link rel=\"stylesheet\" type=\"text/css\" href=\"$env(GODEL_ROOT)/etc/css/w3.css\">"
    }
# }}}
  }

  puts $fout "<meta charset=utf-8>"
  puts $fout "</head>"
  puts $fout "<body>"

# Source ghtm.tcl
  if [file exist .godel/ghtm.tcl] {
    source .godel/ghtm.tcl
  } else {
    gdraw_default
    source .godel/ghtm.tcl
  }

# highlight words
# {{{
  if [info exist rwords] {
  puts $fout "<script>"
    puts $fout "var target_words = \["
    foreach rword $rwords {
      puts $fout "\'$rword\',"
    }
    puts $fout "\];"
    puts $fout "word_highlight(target_words)"
  puts $fout "</script>"
  }
# }}}
  if {$env(GODEL_ALONE)} {
    file mkdir .godel/js
    exec cp $env(GODEL_ROOT)/scripts/js/godel.js .godel/js
    exec cp $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js .godel/js
    puts $fout "<script src=.godel/js/jquery-3.3.1.min.js></script>"
    puts $fout "<script src=.godel/js/godel.js></script>"
  } else {
    puts $fout "<script src=$env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js></script>"
    puts $fout "<script src=$env(GODEL_ROOT)/scripts/js/godel.js></script>"
  }

  if [info exist LOCAL_JS] {
    if ![file exist "local.js"] {
      set kout [open "local.js" w]
      close $kout
    }
    puts $fout "<script src=local.js></script>"
  }

  puts $fout "</body>"
  puts $fout "</html>"

  close $fout

  if {$target_path == "NA" || $target_path == ""} {
  } else {
    cd $orgpath
  }
}
# }}}
# godel_create_file
# {{{
proc godel_create_file {fname} {
  if ![file exist $fname] {
    set fout [open $fname w]
    close $fout
  }
}
# }}}
# tbox_path_length
# {{{
proc tbox_path_length {path} {
  regsub -all {\/} $path { } path_items
  return [llength $path_items]
}
# }}}
# godel_proc_get_ready
# {{{
proc godel_proc_get_ready {infile} {
  upvar vars vars

# 1. source vars.tcl
  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }

# 2. Check infile existence
  if [file exist $infile] {
    puts "Working on.. $infile"
    return 1
  } else {
    puts "Working on.. $infile"
    puts "\033\[0;31m            Error: Not exist.. $infile\033\[0m"
    return 0
  }
}
# }}}
# godel_remove_list_element
# {{{
proc godel_remove_list_element {alist elename} {
  return [lsearch -all -inline -not -exact $alist $elename]
}
# }}}
# godel_list_uniq_add
# {{{
proc godel_list_uniq_add {varname value} {
  upvar $varname var
  lappend var $value
  set var [lsort [lsort -unique $var]]
}
# }}}
# godel_array_add_prefix
# {{{
proc godel_array_add_prefix {arrname prefix} {
  upvar $arrname arr
  foreach {key value} [array get arr] {
    set arr($prefix,$key) $value
    unset arr($key)
  }
}
# }}}
# godel_write_list_to_file
# {{{
proc godel_write_list_to_file {ilist ofile} {
  set fout [open $ofile w]
  foreach i $ilist {
    puts $fout $i
  }
  close $fout
}
# }}}
# godel_split_by_space
# {{{
proc godel_split_by_space {line} {
# Remove leading space
      regsub -all {^\s+} $line "" line
# Replace space with #
      regsub -all {\s+} $line "#" line
      set c [split $line #]
      return $c
}
# }}}
# split_by
# {{{
proc split_by {afile delimiter} {
  upvar curs curs
  godel_array_reset curs

  set fin [open $afile r]
  set num 0

  while {[gets $fin line] >= 0} {
    if {[regexp "$delimiter" $line]} {
      incr num
    }
    lappend curs($num,all) $line
  }
  close $fin
  set curs(size) $num

  #if [info exist curs(0,all)] {
  #  unset curs(0,all)
  #}
}
# }}}
# godel_split_by
# {{{
proc godel_split_by {afile delimiter} {
  upvar curs curs
  godel_array_reset curs
  set fin [open $afile r]
  set num 0
  set no 0
  set process_no 0
  while {[gets $fin line] >= 0} {
    if {[regexp "$delimiter" $line]} {
      incr num
    }
    lappend curs($num,all) $line
    incr no
    if {[expr $no%100000]} {
    } else {
      incr process_no
      puts $process_no
    }
  }
  close $fin
  set curs(size) $num
  if [info exist curs(0,all)] {
    unset curs(0,all)
  }
}
# }}}
# godel_get_vars
# {{{
proc godel_get_vars {key} {
  upvar vars vars
  if [info exist vars($key)] {
    return $vars($key)
  } else {
    return "NA"
  }
}
# }}}
# gget
# {{{
proc gget {pagename args} {
  global env
  source $env(GODEL_CENTER)/meta.tcl

  if [file exist $pagename] {
    set meta($pagename,where) [pwd]/$pagename
  }

  if {$pagename == "."} {
    set meta(.,where) .
  }

  set varfile $meta($pagename,where)/.godel/vars.tcl
  if [file exist $varfile] {
    source $varfile
  } else {
    puts "gget: not exist... $varfile"
    return
  }
  set where $meta($pagename,where)

  if [file exist $meta($pagename,where)/.godel/proc.tcl] {
    source $meta($pagename,where)/.godel/proc.tcl
  }

  if {$args == ""} {
    help
  } else {
    {*}$args
  }
}
# }}}
# setop_and_hit
# {{{
proc setop_and_hit {patterns target} {
  set hit 1
  foreach pattern $patterns {
    if [regexp $pattern $target] {
      set hit [expr $hit&&1]
    } else {
      set hit [expr $hit&&0]
    }
  }
  return $hit
}
# }}}
# godel_puts
# {{{
proc godel_puts {key} {
  upvar vars vars
  if [info exist vars($key)] {
    puts [format "%-25s : %s" $key $vars($key)]
  } else {
    puts [format "%-25s : not ready.." $key)]
  }
}
# }}}
# godel_array_save
# {{{
proc godel_array_save {aname ofile} {
  upvar $aname arr

  if ![file exist $ofile] {
    puts "Error: godel_array_save error... $ofile not exist."
    return
  }
  #parray arr
  if {[file dirname $ofile] != "."} {
    file mkdir [file dirname $ofile]
  }
  set fout [open $ofile w]
    set keys [lsort [array name arr]]
    foreach key $keys {
      set newvalue [string map {\\ {\\}} $arr($key)]
      regsub -all {"}  $newvalue {\\"}  newvalue
      regsub -all {\[} $newvalue {\\[}  newvalue
      regsub -all {\]} $newvalue {\\]}  newvalue
      puts $fout [format "set %-40s \"%s\"" [set aname]($key) $newvalue]
    }
  close $fout

}
# }}}
# godel_array_reset
# {{{
proc godel_array_reset {arrname} {
  upvar $arrname arr
  array unset arr *
}
# }}}
# godel_array_rm
# {{{
proc godel_array_rm {arrname pattern} {
  upvar $arrname arr
  foreach {key value} [array get arr $pattern] {
    unset arr($key)
  }
}
# }}}
# lshift
# {{{
proc lshift {ls {size 1}} {
  upvar 1 $ls LIST
  set size [expr $size - 1]

  if {[llength $LIST]} {
    #set ret [lindex $LIST 0]
    set ret  [lrange $LIST 0 $size]
    set LIST [lreplace $LIST 0 $size]
    return $ret
  } else {
    error "Ran out of list elements."
  }
}
# }}}
# godel_shift
# {{{
proc godel_shift {ls} {
  upvar 1 $ls LIST
  if {[llength $LIST]} {
    set ret [lindex $LIST 0]
    set LIST [lreplace $LIST 0 0]
    return $ret
  } else {
    error "Ran out of list elements."
  }
}
# }}}
# godel_get_column
# {{{
proc godel_get_column {line num} {
      regsub {<-} $line "" line
      regsub {\(gclock source\)} $line "" line
# Remove leading space
      regsub -all {^\s+} $line "" line
# Replace space with #
      regsub -all {\s+} $line "#" line
      set c [split $line #]
      set column_string [lindex $c $num]
}
# }}}
# plist
# {{{
proc plist {args} {
  # -s (sort)
# {{{
  set opt(-s) 0
  set idx [lsearch $args {-s}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-s) 1
  }
# }}}
  set ll [lindex $args 0]
  if {$opt(-s)} {
    foreach i [lsort $ll] {
      puts $i
    }
  } else {
    foreach i $ll {
      puts $i
    }
  }
}
# }}}
# pcollection_list
# {{{
proc pcollection_list {ll} {
  foreach_in_collection i $ll {
    puts [get_attribute $i full_name]
  }
}
# }}}
# Tool Box
# {{{
proc ggrep {re ffile} {
# Usage:
# ggrep "errors" foo.rpt

  set matches ""
  set fp [open $ffile r]
  while {[gets $fp line] >= 0} {
      if [regexp -- $re $line] {
          lappend matches "$line"
      }
  }
  close $fp
  return $matches
}
# }}}
# tbox_grep_filelist
# {{{
proc tbox_grep_filelist {re filelist} {
# Usage:
# tbox_grep_filelist foo [list a.txt.b.txt c.txt]
#
    foreach file $filelist {
        set fp [open $file r]
        while {[gets $fp line] >= 0} {
            if [regexp -- $re $line] {
                puts "$file: $line"
            }
        }
        close $fp
    }
}
# }}}
# tbox_ww2date
# {{{
proc tbox_ww2date {ww} {
# Usage: tbox_ww2date 17.46.3
  regsub -all {\.} $ww { } dlist

  set year   [lindex $dlist 0]
  
  set ww [lindex $dlist 1]
  set ww [string trimlef $ww 0]
  set wwdate [lindex $dlist 2]
  incr ww -1

  set day1 [exec tcsh -fc "date -d \"20$year/1/1\" +%w"]
  set date1 [exec tcsh -fc "date -d \"20$year/1/1 - $day1 days + $ww weeks\" +%x"]

  return [exec tcsh -fc "date -d \"$date1 + $wwdate days\" +%m/%d"]

}
# }}}
# tbox_list
# {{{
proc tbox_list {fname {prefix ""} {postfix ""}} {

  set klist [glob -nocomplain */$fname]
  
  foreach k $klist {
    lappend dlist [file dirname $k]
  }
  
  foreach d $dlist {
    puts "$prefix$d$postfix"
  }
}
# }}}
# tbox_procExists
# {{{
proc tbox_procExists {p} {
   return uplevel 1 [expr {[llength [info procs $p]] > 0}]
}
# }}}
# godel_value_scatter
# {{{
proc godel_value_scatter {name bin_size inlist} {
  if ![file exist .chart] { file mkdir .chart }

  set inlist [lsort -real $inlist]
  set smallest [lindex $inlist 0]
  set biggest  [lindex $inlist end]

  set begin [expr round($smallest/$bin_size)]
  set end   [expr round($biggest/$bin_size)]


  for {set i $begin} {$i <= $end} {incr i} {
    lappend binlist [expr $i * $bin_size]
  }

  #puts $binlist
  #puts $inlist

# scatter
  set fout [open .chart/$name.dat w]
  foreach bin $binlist {
    set low $bin
    set high [expr $bin + $bin_size]
    set vars($bin,scatter) 0
    #set high $bin
    foreach num $inlist {
      if {$num >= $low && $num < $high} {
        incr vars($bin,scatter)
      }
    }
    #puts "$bin $vars($bin,scatter)"
    puts $fout "$bin $vars($bin,scatter) 2"
  }
  close $fout

  #parray vars
}

# }}}
# godel_value_accu
# {{{
proc godel_value_accu {name bin_size inlist} {
  if ![file exist .chart] { file mkdir .chart }
  set inlist [lsort -real $inlist]
  set smallest [lindex $inlist 0]
  set biggest  [lindex $inlist end]

  set begin [expr round($smallest/$bin_size)]
  set end   [expr round($biggest/$bin_size)]


  for {set i $begin} {$i <= $end} {incr i} {
    lappend binlist [expr $i * $bin_size]
  }

  #puts $binlist
  #puts $inlist

# accumulate
  set fout [open .chart/$name.dat w]
  foreach bin $binlist {
    set count 0
    foreach num $inlist {
      if {$num >= $bin} {
        if {$num == $bin} {
          incr count
        }
        break
      } else {
        incr count
      }
    }
    set vars($bin,accu) $count
    puts $fout "$bin $vars($bin,accu) 2"
  }
  close $fout
}

# }}}
# godel_add_class
# {{{
proc godel_add_class {pname value} {
  global env
  source $env(GODEL_CENTER)/meta.tcl

# Get pname where
  source $mfile
  #puts $meta($pname,where)

# Get pname vars
  source $meta($pname,where)/.godel/vars.tcl

# Set pname with value
  set vars(g:class) [concat $vars(g:class) $value]
# Unique
  set vars(g:class) [lsort -unique $vars(g:class)]
# Remove {}
  set vars(g:class) [lsort -unique $vars(g:class)]
  set vars(g:class) [list {*}$vars(g:class)]
  set vars(g:class) [godel_remove_list_element $vars(g:class) {}]

  godel_array_save vars $meta($pname,where)/.godel/vars.tcl
}
# }}}
# godel_set_page_value
# {{{
proc godel_set_page_value {pname attr value} {
  global env
  source $env(GODEL_CENTER)/meta.tcl

# Get pname where
  source $mfile
  #puts $meta($pname,where)

# Get pname vars
  source $meta($pname,where)/.godel/vars.tcl

# Set pname with value
  set vars($attr) $value

  godel_array_save vars $meta($pname,where)/.godel/vars.tcl
  #puts $vars(g:keywords)
  #return $vars(g:keywords)
}
# }}}
# meta-indexing
# {{{
proc meta_indexing {{ofile NA}} {
  upvar env env
  source $env(GODEL_CENTER)/meta.tcl

  array set vars [array get meta]

  set ilist [list]
  foreach i [array name meta *,where] {
    regsub ",where" $i "" i
    lappend ilist $i
  }

  godel_array_reset meta

  foreach i $ilist {
    set varspath   $vars($i,where)/.godel/vars.tcl
    if [file exist $varspath] {
      source $varspath
      set meta($i,keywords)     [lsort [concat $vars(g:keywords) $i]]
      
    } else {
      puts "Error: not exist.. $varspath"
    }
  }

  set index_file $env(GODEL_CENTER)/indexing.tcl
  if [file exist $index_file] {
  } else {
    set kout [open $index_file w]
    close $kout
  }

  godel_array_save meta $env(GODEL_CENTER)/indexing.tcl
}
# }}}
# meta_chkin
# {{{
proc meta_chkin {args} {
  # -f (force)
# {{{
  set opt(-f) 0
  set idx [lsearch $args {-f}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-f) 1
  }
# }}}
  global env
  source $env(GODEL_CENTER)/meta.tcl
  set org_path [pwd]

  set page_path $args

# meta value to be checked-in stored in .godel/vars.tcl
  if {$page_path != ""} {
    #cd [tbox_cyg2unix $page_path]
    cd $page_path
  }

  #source .godel/vars.tcl
  set fullpath [pwd]
  set c [split $fullpath /]

  set fullpath [pwd]
  set c [split $fullpath /]

# pagename
  set hier_level ""
  if {$hier_level == ""} {
    set pathelem [lrange $c end end]
  } else {
    set pathelem [lrange $c end-$hier_level end]
  }
  
  set pagename [join $pathelem ":"]
 

# checked-in meta value
  if {$opt(-f)} {
      puts "Checkin $pagename..."
      set meta($pagename,where)    $fullpath
      godel_array_save meta $env(GODEL_CENTER)/meta.tcl
      cd $org_path
      return 1
  } else {
    if [info exist meta($pagename,where)] {
      puts "Error: `$pagename' already exist..."
      puts "       $pagename = $meta($pagename,where)"
      cd $org_path
      return 0
    } else {
      puts "Checkin $pagename..."
      set meta($pagename,where)    $fullpath
      godel_array_save meta $env(GODEL_CENTER)/meta.tcl
      cd $org_path
      return 1
    }
  }


}
# }}}
# meta_rm
# {{{
proc meta_rm {name} {
  global env
  set mfile $env(GODEL_CENTER)/meta.tcl
  if [file exist $mfile] {
    source $mfile
  }

  array unset meta $name,where

  godel_array_save meta $env(GODEL_CENTER)/meta.tcl
}
# }}}
# tbox_grep
# {{{
proc tbox_grep {re afilelist} {
    set files [glob -types f $args]
    foreach file $files {
        set fp [open $file]
        while {[gets $fp line] >= 0} {
            if [regexp -- $re $line] {
                if {[llength $files] > 1} {puts -nonewline $file:}
                puts $line
            }
        }
        close $fp
    }
}
# }}}
# lgrep
# {{{
proc lgrep_inc {pattern} {
  upvar gglist gglist

  if [regexp "^!" $pattern] {
    set option -not
    regsub "^!" $pattern "" pattern
  } else {
    set option ""
  }

  if {$option == ""} {
    set gglist [lsearch -all -inline -regexp $gglist $pattern]
  } else {
    set gglist [lsearch $option -all -inline -regexp $gglist $pattern]
  }
}
# }}}
# gscreen
# {{{
proc gscreen {pattern_list {ofile NA}} {
  upvar gscreen_list gscreen_list

  set gglist $gscreen_list

# Screening
  foreach p $pattern_list {
    lgrep_inc $p
  }

# Save to file
  if {$ofile == "NA"} {
    plist $gglist
  } else {
    set kout [open $ofile w]
      foreach line $gglist {
        puts $kout $line
      }
    close $kout
  }
}
# }}}
# read_file_ret_list
# {{{
# read a file and retrun a list
proc read_file_ret_list {afile} {
  set fin [open $afile r]
    while {[gets $fin line] >= 0} {
      lappend lines $line
    }
  close $fin

  if [info exist lines] {
    return $lines
  } else {
    return ""
  }
}
# }}}

# vim:fdm=marker
