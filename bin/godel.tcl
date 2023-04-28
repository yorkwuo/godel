# newgpage
# {{{
proc newgpage {} {
  set idcounter [lvars . idcounter]
  set rowid [format "%04d" $idcounter]

  incr idcounter
  lsetvar . idcounter $idcounter

  file mkdir $rowid
  godel_draw $rowid

  godel_draw

  catch {exec xdotool search --name "Mozilla" key ctrl+r}
}
# }}}
# pathbar
# {{{
proc pathbar {depth} {
  upvar fout fout

  set cwd [pwd]

  set pathhier "<a style=\"font-size:16px\">[file tail $cwd]</a>"
  set relative_path "../"
  for {set i 1} {$i <= $depth} {incr i} {
    set name [pindex $cwd end-$i]
    set pathhier "<a style=\"font-size:16px\" href=\"$relative_path.index.htm\">$name</a> / $pathhier"
    append relative_path "../"

  }
  puts $fout $pathhier
}
# }}}
# lgrep
# {{{
proc lgrep {lines pattern} {
  set matches ""
  foreach line $lines {
    if [regexp $pattern $line] {
      lappend matches $line
    }
  }

  return $matches
}
# }}}
# toolarea_begin
# {{{
proc toolarea_begin {} {
  upvar fout fout
  set toolarea [lvars . toolarea]
  if {$toolarea eq "1"} {
    puts $fout "<div id=\"toolarea\" style=\"display:block\">"
  } else {
    puts $fout "<div id=\"toolarea\" style=\"display:none\">"
  }
}
# }}}
# toolarea_end
# {{{
proc toolarea_end {} {
  upvar fout fout
  puts $fout "</div>"
}
# }}}
# alinkname
# {{{
proc alinkname {} {
  upvar env env
  upvar row row
  upvar celltxt celltxt
  upvar atvar atvar

  set name [get_atvar $row,name]
  #set url  [get_atvar $row,url]

  if {$name eq ""} {
    set celltxt "<td gname=\"$row\" colname=\"name\" contenteditable=\"true\" ></td>"
  } else {
    set celltxt "<td gname=\"$row\" colname=\"name\" contenteditable=\"true\" >$name</td>"
  }

  #if {$name eq ""} {
  #  set celltxt "<td gname=\"$row\" colname=\"name\" contenteditable=\"true\" ><a href=\"$url\"></td>"
  #} else {
  #  #set celltxt "<td><a href=\"$url\">$name</td>"
  #  if {[info exist env(GODEL_WSL)] && $env(GODEL_WSL) eq "1"} {
  #    set celltxt "<td><button onclick=\"chrome_open('$url')\">L</button></td>"
  #  } else {
  #    set celltxt "<td><a href=\"$url\">L</td>"
  #  }
  #}
}
# }}}
# gen_random_num
# {{{
proc gen_random_num {count min max} {
  package require math
  set rnums ""
  while {1} {
    set rnums [lsort -unique $rnums]
    if {[llength $rnums] < $count } {
      set num [::math::random $min $max]
      lappend rnums $num
    } else {
      break
    }
  }
  return $rnums
}
# }}}
# omsg
# {{{
proc omsg {args} {
  upvar msgvar msgvar

  set name [lindex $args 0]
  
  set timestamp [clock format [clock seconds] -format {%Y-%m-%d_%H:%M:%S}]


  set msgvar($name,sec) [clock seconds]

  if [info exist msgvar(current)] {
    set msgvar(last)    $msgvar(current)
    set msgvar(current) $name
    lappend msgvar(names) $name

    set stagetime [ss2hhmmss [expr $msgvar($name,sec) - $msgvar($msgvar(last),sec)]]
    set totaltime [ss2hhmmss [expr $msgvar($name,sec) - $msgvar(begin,sec)]]

  } else {
    set msgvar(last)    NA
    set msgvar(NA,sec)  0
    set msgvar(current) $name
    lappend msgvar(names) $name

    set stagetime 0h:0m:0s
    set totaltime [ss2hhmmss [expr $msgvar($name,sec) - $msgvar(begin,sec)]]
  }

  puts [format "#omsg: %s : %-12s : %-14s : %s" $timestamp $stagetime $totaltime $name]
  if {$name eq "end"} {
    lsetvar . runtime $totaltime
  }

}
# }}}
# pindex : path index
# {{{
proc pindex {path index} {
  set cols [lreplace [split $path /] 0 0]
  return [lindex $cols $index]
}
# }}}
# prange : path range
# {{{
proc prange {path start end} {
  set cols [lreplace [split $path /] 0 0]
  return /[join [lrange $cols $start $end] /]
}
# }}}
# pdepth : path depth
# {{{
proc pdepth {path} {
  set cols [lreplace [split $path /] 0 0]
  return [llength $cols]
}
# }}}
# sd_fp_init
# {{{
proc sd_fp_init {width height scale} {
  upvar sdvar sdvar
  upvar fout fout

  svg_init -w $width -h $height -vbox "0 0 [expr $width * $scale] [expr $height * $scale]"

  set sdvar(die,height) $height
}
# }}}
# sd_read_lef
# {{{
proc sd_read_lef {ifile} {
  upvar sdvar sdvar

  set fp [open $ifile r]
    set data [read $fp]
  close $fp

  regexp {MACRO (\S+)} $data whole cell
  regexp {SIZE (\S+) BY (\S+) ;} $data whole width height
  
  regsub -all {PIN} $data {:PIN} data
  regsub -all {OBS} $data {:OBS} data

  set lines [split $data ":"]

  foreach line $lines {
    if [regexp {USE CLOCK} $line] {
      set pin [lindex $line 1]
      set sdvar($cell,$pin,x1) [lindex $line 13]
      set sdvar($cell,$pin,y1) [lindex $line 14]
      set sdvar($cell,$pin,x2) [lindex $line 15]
      set sdvar($cell,$pin,y2) [lindex $line 16]
    }
  }

  set sdvar($cell,width) $width
  set sdvar($cell,height) $height

}
# }}}
# sd_cell
# {{{
proc sd_cell {args} {
  upvar svar svar
  upvar fout fout
  upvar sdvar sdvar
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
  # -w
# {{{
  set opt(-w) 0
  set idx [lsearch $args {-w}]
  if {$idx != "-1"} {
    set width [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-w) 1
  } else {
    set width 1
  }
# }}}
  # -h
# {{{
  set opt(-h) 0
  set idx [lsearch $args {-h}]
  if {$idx != "-1"} {
    set height [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-h) 1
  } else {
    set height 1
  }
# }}}
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}
  # -ori
# {{{
  set opt(-ori) 0
  set idx [lsearch $args {-ori}]
  if {$idx != "-1"} {
    set ori [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-ori) 1
  } else {
    set ori N
  }
# }}}

  foreach {x y} [split $xy ,] {}

  set fpheight $sdvar(die,height)

  set y [expr $fpheight - $y]

  if {$ori eq "W"} {
    puts $fout "
                  <path d=\"M$x,$y h$height v-$width h-$height v$width\" stroke=\"purple\" stroke-width=\"1\" fill=\"none\" />
                "
  } else {
    puts $fout "
                  <path d=\"M$x,$y h$width v-$height h-$width v$height\" stroke=\"purple\" stroke-width=\"1\" fill=\"none\" />
                "
  }
}
# }}}
# sd_place_cell
# {{{
proc sd_place_cell {args} {
  upvar sdvar sdvar
  upvar svar svar
  upvar fout fout
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}
  # -inst
# {{{
  set opt(-inst) 0
  set idx [lsearch $args {-inst}]
  if {$idx != "-1"} {
    set inst [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-inst) 1
  } else {
    set inst NA/NA
  }
# }}}
  # -cell
# {{{
  set opt(-cell) 0
  set idx [lsearch $args {-cell}]
  if {$idx != "-1"} {
    set cell [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-cell) 1
  } else {
    set cell NA/NA
  }
# }}}
  # -ori
# {{{
  set opt(-ori) 0
  set idx [lsearch $args {-ori}]
  if {$idx != "-1"} {
    set ori [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-ori) 1
  } else {
    set ori N
  }
# }}}

  sd_cell -xy $xy -w $sdvar($cell,width) -h $sdvar($cell,height) -ori $ori

  set sdvar($inst,cell) $cell
  set sdvar($inst,xy)   $xy
  set sdvar($inst,ori)  $ori
}
# }}}
# sd_place_pin
# {{{
proc sd_place_pin {instpin} {
  upvar sdvar sdvar
  upvar svar svar
  upvar fout fout
  
  set inst [file dirname $instpin]
  set pin  [file tail    $instpin]
  set cell $sdvar($inst,cell)
  set ori  $sdvar($inst,ori)

  sd_pin -xy $sdvar($inst,xy) -pin $instpin -ori $ori
}
# }}}
# sd_pin_connect
# {{{
proc sd_pin_connect {args} {
  upvar sdvar sdvar
  upvar svar svar
  upvar fout fout
  # -ofs
# {{{
  set opt(-ofs) 0
  set idx [lsearch $args {-ofs}]
  if {$idx != "-1"} {
    set ofs [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-ofs) 1
  } else {
    set ofs ""
  }
# }}}
  set spin [lindex $args 0]
  set epin [lindex $args 1]

  svg_connect $sdvar($spin,xy) $sdvar($epin,xy) -ofs $ofs
  puts       "$sdvar($spin,xy) $sdvar($epin,xy) $ofs"

}
# }}}
# sd_pin
# {{{
proc sd_pin {args} {
  upvar sdvar sdvar
  upvar svar svar
  upvar fout fout
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}
  # -pin
# {{{
  set opt(-pin) 0
  set idx [lsearch $args {-pin}]
  if {$idx != "-1"} {
    set instpin [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-pin) 1
  } else {
    set instpin NA/NA
  }
# }}}
  # -ori
# {{{
  set opt(-ori) 0
  set idx [lsearch $args {-ori}]
  if {$idx != "-1"} {
    set ori [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-ori) 1
  } else {
    set ori N
  }
# }}}

  foreach {x y} [split $xy ,] {}

  set pin  [file tail    $instpin]
  set cell $sdvar([file dirname $instpin],cell)

  set cw $sdvar($cell,width)
  set ch $sdvar($cell,height)

  set fpheight $sdvar(die,height)

  set x1 $sdvar($cell,$pin,x1)
  set y1 $sdvar($cell,$pin,y1)
  set x2 $sdvar($cell,$pin,x2)
  set y2 $sdvar($cell,$pin,y2)

  # rotate/flip
# {{{
  if {$ori eq "W"} {
    set newx1 [expr $ch - $y1]
    set newy1 $x1
    set newx2 [expr $ch - $y2]
    set newy2 $x2
  } elseif {$ori eq "S"} {
    set newx1 [expr $cw - $x1]
    set newy1 [expr $ch - $y1]
    set newx2 [expr $cw - $x2]
    set newy2 [expr $ch - $y2]
  } elseif {$ori eq "E"} {
    set newx1 $y1
    set newy1 [expr $cw - $x1]
    set newx2 $y2
    set newy2 [expr $cw - $x2]
  } elseif {$ori eq "FS"} {
    set newx1 $x1
    set newy1 [expr $ch - $y1]
    set newx2 $x2
    set newy2 [expr $ch - $y2]
  } elseif {$ori eq "FW"} {
    set newx1 [expr $ch - [expr $ch - $y1]]
    set newy1 $x1
    set newx2 [expr $ch - [expr $ch - $y2]]
    set newy2 $x2
  } elseif {$ori eq "FN"} {
    set newx1 [expr $cw - $x1]
    set newy1 [expr $ch - [expr $ch - $y1]]
    set newx2 [expr $cw - $x2]
    set newy2 [expr $ch - [expr $ch - $y2]]
  } elseif {$ori eq "FE"} {
    set newx1 [expr $ch - $y1]
    set newy1 [expr $cw - $x1]
    set newx2 [expr $ch - $y2]
    set newy2 [expr $cw - $x2]
  } else {
    set newx1 $x1
    set newy1 $y1
    set newx2 $x2
    set newy2 $y2
  }
# }}}

  set x1 [format "%.3f" [expr $newx1 + $x]]
  set y1 [format "%.3f" [expr $fpheight - $newy1 - $y ]]
  set x2 [format "%.3f" [expr $newx2 + $x]]
  set y2 [format "%.3f" [expr $fpheight - $newy2 - $y ]]

  puts $fout "
  <path stroke=\"purple\" stroke-width=\"5\" d=\"M$x1 $y1 L$x2 $y1 L$x2 $y2 L$x1 $y2 Z\" />
  "

  set sdvar($instpin,xy) $x1,$y1
}
# }}}
# sd_create_pin
# {{{
proc sd_create_pin {args} {
  upvar sdvar sdvar
  upvar svar svar
  upvar fout fout
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}
  # -pin
# {{{
  set opt(-pin) 0
  set idx [lsearch $args {-pin}]
  if {$idx != "-1"} {
    set instpin [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-pin) 1
  } else {
    set instpin NA/NA
  }
# }}}

  set pin  [file tail $instpin]
  set inst [file dirname $instpin]

  foreach {x y} [split $xy ,] {}
  set fpheight $sdvar(die,height)

  set x1 $x
  set y1 [format "%.3f" [expr $fpheight - $y ]]

  svg_rect $x1 $y1 5 5

  set sdvar($inst,cell) FOOCELL
  set sdvar($instpin,xy) $x1,$y1
}
# }}}
# sd_text
# {{{
proc sd_text {args} {
  upvar sdvar sdvar
  upvar svar svar
  upvar fout fout
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}
  # -txt
# {{{
  set opt(-txt) 0
  set idx [lsearch $args {-txt}]
  if {$idx != "-1"} {
    set txt [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-txt) 1
  } else {
    set txt NA
  }
# }}}
  # -size
# {{{
  set opt(-size) 0
  set idx [lsearch $args {-size}]
  if {$idx != "-1"} {
    set size [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-size) 1
  } else {
    set size NA
  }
# }}}


  foreach {x y} [split $xy ,] {}

  set fpheight $sdvar(die,height)

  set x1 $x
  set y1 [format "%.3f" [expr $fpheight - $y ]]

  puts $fout "<text x=\"$x1\" y=\"$y1\" style=\"font-family:monospace;font-size:${size}px\" \>$txt</text>"

}
# }}}
# svg_blk
# {{{
proc svg_blk {args} {
  upvar svar svar
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
    set name 1
  }
# }}}
  # -w
# {{{
  set opt(-w) 0
  set idx [lsearch $args {-w}]
  if {$idx != "-1"} {
    set width [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-w) 1
  } else {
    set width 1
  }
# }}}
  # -h
# {{{
  set opt(-h) 0
  set idx [lsearch $args {-h}]
  if {$idx != "-1"} {
    set height [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-h) 1
  } else {
    set height 1
  }
# }}}
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}


  foreach {x y} [split $xy ,] {}

  puts $fout "
                <path d=\"M$x,$y h$width v$height h-$width v-$height\" stroke=\"purple\" stroke-width=\"1\" fill=\"none\" />
              "
  puts $fout "<text x=$x y=[expr $y-2] style=\"font-family:monospace;font-size:8px\">$name</text>"
  set svar($name,xy) $x,$y
  set svar($name,Ox) [expr $x+$width]
  set svar($name,x)  $x
  set svar($name,y)  $y
  set svar($name,I)  $x,[expr $y + [expr $width/2]]
  set svar($name,O)  [expr $x+$width],[expr $y + [expr $width/2]]
}
# }}}
# svg_init
# {{{
proc svg_init {args} {
  upvar fout fout
  # -w
# {{{
  set opt(-w) 0
  set idx [lsearch $args {-w}]
  if {$idx != "-1"} {
    set width [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-w) 1
  } else {
    set width 1
  }
# }}}
  # -h
# {{{
  set opt(-h) 0
  set idx [lsearch $args {-h}]
  if {$idx != "-1"} {
    set height [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-h) 1
  } else {
    set height 1
  }
# }}}
  # -vbox
# {{{
  set opt(-vbox) 0
  set idx [lsearch $args {-vbox}]
  if {$idx != "-1"} {
    set vbox [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-vbox) 1
  } else {
    set vbox 1
  }
# }}}
  # -sw
# {{{
  set opt(-sw) 0
  set idx [lsearch $args {-sw}]
  if {$idx != "-1"} {
    set stroke_width [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-sw) 1
  } else {
    set stroke_width 0.1
  }
# }}}
  # -color
# {{{
  set opt(-color) 0
  set idx [lsearch $args {-color}]
  if {$idx != "-1"} {
    set color [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-color) 1
  } else {
    set color blue
  }
# }}}

  puts $fout "<svg width=\"$width\" height=\"$height\" viewBox=\"$vbox\" style=\"border: blue solid;\">"

  set xcount [expr $width/10]
  set ycount [expr $height/10]

  for {set i 1} {$i < $xcount} {incr i} {
    set stride [expr $i * 10]
    puts $fout "<path stroke=\"$color\" stroke-width=\"$stroke_width\" d=\"M$stride 0 V$height\" />"
  }

  for {set i 1} {$i < $ycount} {incr i} {
    set stride [expr $i * 10]
    puts $fout "<path stroke=\"$color\" stroke-width=\"$stroke_width\" d=\"M0 $stride H$width\" />"
  }
  

}
# }}}
# svg_circle
# {{{
proc svg_circle {xy} {
  upvar fout fout
  foreach {x y} [split $xy ,] {}
  puts $fout "<circle cx=\"$x\" cy=\"$y\" r=\"3\" fill=\"purple\" />"
}
# }}}
# svg_rect
# {{{
proc svg_rect {x y width height} {
  upvar fout fout
  puts $fout "<rect stroke=\"purple\" stroke-width=\"1\" x=\"$x\" y=\"$y\" width=\"$width\" height=\"$height\" fill=\"none\" />"
}
# }}}
# svg_connect
# {{{
proc svg_connect {x1y1 x2y2 args} {
  upvar fout fout
  foreach {x1 y1} [split $x1y1 ,] {}
  foreach {x2 y2} [split $x2y2 ,] {}
  # -color
# {{{
  set opt(-color) 0
  set idx [lsearch $args {-color}]
  if {$idx != "-1"} {
    set color [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-color) 1
  } else {
    set color blue
  }
# }}}
  # -width
# {{{
  set opt(-width) 0
  set idx [lsearch $args {-width}]
  if {$idx != "-1"} {
    set width [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-width) 1
  } else {
    set width 1
  }
# }}}
  # -ofs
# {{{
  set opt(-ofs) 0
  set idx [lsearch $args {-ofs}]
  if {$idx != "-1"} {
    set ofs [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-ofs) 1
  } else {
    set ofs ""
  }
# }}}
  # -di
# {{{
  set opt(-di) 0
  set idx [lsearch $args {-di}]
  if {$idx != "-1"} {
    set direction [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-di) 1
  } else {
    set direction v
  }
# }}}

  if {$ofs eq ""} {
      puts $fout "<path stroke=\"$color\" stroke-width=\"$width\" fill=\"none\" d=\"M$x1 $y1 L$x2 $y2\" />"
  } else {
    set xmid $x1
    set ymid $y1
    foreach offset $ofs {
      regexp {(\w)(.*)} $offset whole dir value
      if {$dir eq "h"} {
        set xmid [expr $xmid + $value]
      } else {
        set ymid [expr $ymid + $value]
      }
    }
    #svg_circle $xmid,$ymid
    if {$direction eq "v"} {
      set vlast [expr $y2 - $ymid]
      set hlast [expr $x2 - $xmid]
      puts $fout "<path stroke=\"$color\" stroke-width=\"$width\" fill=\"none\" d=\"M$x1 $y1 $ofs v$vlast h$hlast\" />"
    } else {
      set vlast [expr $y2 - $ymid]
      set hlast [expr $x2 - $xmid]
      puts $fout "<path stroke=\"$color\" stroke-width=\"$width\" fill=\"none\" d=\"M$x1 $y1 $ofs h$hlast v$vlast\" />"
    }
  }
}
# }}}
# svg_flop
# {{{
proc svg_flop {args} {
  upvar svar svar
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
    set name 1
  }
# }}}
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}
  # -inst
# {{{
  set opt(-inst) 0
  set idx [lsearch $args {-inst}]
  if {$idx != "-1"} {
    set inst [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-inst) 1
  } else {
    set inst NA
  }
# }}}

  foreach {x y} [split $xy ,] {}
  puts $fout "
                <path d=\"M$x,$y h30 v50 h-30 v-50\" stroke=purple stroke-width=1 fill=white />
                <line x1=$x y1=[expr $y+30] x2=[expr $x+10] y2=[expr $y+35] stroke=purple stroke-width=1 />
                <line x1=$x y1=[expr $y+40] x2=[expr $x+10] y2=[expr $y+35] stroke=purple stroke-width=1 />
              "
  puts $fout "<text x=$x y=[expr $y-1] style=\"font-family:monospace;font-size:8px\">$name</text>"
  set svar($name,x) $x
  set svar($name,y) $y
  set svar($name,xy) $x,$y
  set svar($name,Q)  [expr $x+30],[expr $y+10]
  set svar($name,D)  [expr $x],[expr $y+10]
  set svar($name,CK) [expr $x],[expr $y+35]
  set svar($name,inst) $inst
}
# }}}
# svg_inv
# {{{
proc svg_inv {xy name {ofs ""}} {
  upvar svar svar
  upvar fout fout
  foreach {x y} [split $xy ,] {}
  if {$ofs eq ""} {
  } else {
    foreach {xofs yofs} [split $ofs ,] {}
    set x [expr $x + $xofs]
    set y [expr $y + $yofs]
  }

  set x1 $x
  set y1 [expr $y - 10]
  set x2 [expr $x + 10]
  set y2 $y
  set x3 $x
  set y3 [expr $y+10]
 
  puts $fout "
                <polygon points=\"$x,$y $x1,$y1 $x2,$y2 $x3,$y3 $x,$y\" stroke=purple stroke-width=1 fill=white />
                <circle cx=\"$x2\" cy=\"$y2\" r=\"2\" fill=\"white\" stroke=purple stroke-width=1 />
             "
  puts $fout "<text x=$x1 y=$y1 style=\"font-family:monospace;font-size:8px\">$name</text>"
  set svar($name,xy) $x,$y
  set svar($name,I)  $x,$y
  set svar($name,Z)  [expr $x+12],$y
}
# }}}
# svg_buf
# {{{
proc svg_buf {xy name {ofs ""}} {
  upvar svar svar
  upvar fout fout
  foreach {x y} [split $xy ,] {}
  if {$ofs eq ""} {
  } else {
    foreach {xofs yofs} [split $ofs ,] {}
    set x [expr $x + $xofs]
    set y [expr $y + $yofs]
  }

  set x1 $x
  set y1 [expr $y - 10]
  set x2 [expr $x + 10]
  set y2 $y
  set x3 $x
  set y3 [expr $y+10]
 
  puts $fout "
                <polygon points=\"$x,$y $x1,$y1 $x2,$y2 $x3,$y3 $x,$y\" stroke=purple stroke-width=1 fill=white />
             "
  puts $fout "<text x=$x1 y=$y1 style=\"font-family:monospace;font-size:8px\">$name</text>"
  set svar($name,xy) $x,$y
  set svar($name,I)  $x,$y
  set svar($name,Z)  [expr $x+10],$y
}
# }}}
# svg_mux
# {{{
proc svg_mux {args} {
  upvar svar svar
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
    set name 1
  }
# }}}
  # -inst
# {{{
  set opt(-inst) 0
  set idx [lsearch $args {-inst}]
  if {$idx != "-1"} {
    set inst [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-inst) 1
  } else {
    set inst NA
  }
# }}}
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}

  foreach {x y} [split $xy ,] {}
  set x1 $x
  set y1 [expr $y - 20]
  puts $fout "
                <path d=\"M$x,$y v-20 L[expr $x+15] [expr $y-10] v20 L$x [expr $y+20] Z\" stroke=purple stroke-width=1 fill=white />
             "
  puts $fout "<text x=$x1 y=$y1 style=\"font-family:monospace;font-size:8px\">$name</text>"
  set svar($name,xy) $x,$y
  set svar($name,I0)   $x,[expr $y-10]
  set svar($name,I1)   $x,[expr $y+10]
  set svar($name,Z)    [expr $x+15],$y
  set svar($name,inst) $inst
}
# }}}
# svg_icg
# {{{
proc svg_icg {args} {
  upvar svar svar
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
    set name 1
  }
# }}}
  # -inst
# {{{
  set opt(-inst) 0
  set idx [lsearch $args {-inst}]
  if {$idx != "-1"} {
    set inst [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-inst) 1
  } else {
    set inst NA
  }
# }}}
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}

  foreach {x y} [split $xy ,] {}
  set x1 $x
  set y1 [expr $y - 20]
  set x2 [expr $x1 + 15]
  set y2 $y1
  set x3 $x2
  set y3 [expr $y2 + 30]
  set x4 $x
  set y4 $y3
  puts $fout "
             <polygon points=\"$x,$y $x1,$y1 $x2,$y2 $x3,$y3 $x4,$y4 $x,$y\" stroke=purple stroke-width=1 fill=white />
             <text x=[expr $x+1] y=[expr $y+3] style=\"font-family:monospace;font-size:8px\">CK</text>
             <text x=[expr $x+1] y=[expr $y-10] style=\"font-family:monospace;font-size:8px\">EN</text>
             <text x=[expr $x]   y=[expr $y-23] style=\"font-family:monospace;font-size:8px\">$name</text>
             "
  set svar($name,xy)  $x,$y
  set svar($name,CK)  $x,$y
  set svar($name,GCK) [expr $x+15],$y
}
# }}}
# svg_port
# {{{
proc svg_port {xy name {ofs ""}} {
  upvar svar svar
  upvar fout fout
  foreach {x y} [split $xy ,] {}

  if {$ofs eq ""} {
  } else {
    foreach {xofs yofs} [split $ofs ,] {}
    set x [expr $x + $xofs]
    set y [expr $y + $yofs]
  }

  puts $fout "
                <path d=\"M$x,$y v-3 h15 
                L[expr $x + 20] $y 
                L[expr $x + 15] [expr $y+3] h-15 Z\" stroke=purple stroke-width=1 fill=white />
             "
  puts $fout "<text x=$x y=[expr $y-6] style=\"font-family:monospace;font-size:8px\">$name</text>"

  set svar($name,xy) $x,$y
  set svar($name,I)  $x,$y
  set svar($name,O)  [expr $x+20],$y
}
# }}}
# svg_in_pin
# {{{
proc svg_in_pin {args} {
  upvar svar svar
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
    set name 1
  }
# }}}
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}
  # -ofs
# {{{
  set opt(-ofs) 0
  set idx [lsearch $args {-ofs}]
  if {$idx != "-1"} {
    set ofs [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-ofs) 1
  } else {
    set ofs ""
  }
# }}}

  foreach {x y} [split $xy ,] {}

  if {$ofs eq ""} {
  } else {
    foreach {xofs yofs} [split $ofs ,] {}
    set x [expr $x + $xofs]
    set y [expr $y + $yofs]
  }

  puts $fout "
                <path d=\"M$x,$y v-1 h5 v2 h-5 Z\" stroke=purple stroke-width=1 fill=purple />
             "
  puts $fout "<text x=[expr $x+1] y=[expr $y-4] style=\"font-family:monospace;font-size:6px\">$name</text>"

  set svar($name,I)  $x,$y
  set svar($name,O)  [expr $x+5],$y
}
# }}}
# svg_out_pin
# {{{
proc svg_out_pin {args} {
  upvar svar svar
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
    set name 1
  }
# }}}
  # -xy
# {{{
  set opt(-xy) 0
  set idx [lsearch $args {-xy}]
  if {$idx != "-1"} {
    set xy [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-xy) 1
  } else {
    set xy 0,0
  }
# }}}
  # -ofs
# {{{
  set opt(-ofs) 0
  set idx [lsearch $args {-ofs}]
  if {$idx != "-1"} {
    set ofs [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-ofs) 1
  } else {
    set ofs ""
  }
# }}}
  foreach {x y} [split $xy ,] {}

  if {$ofs eq ""} {
  } else {
    foreach {xofs yofs} [split $ofs ,] {}
    set x [expr $x + $xofs]
    set y [expr $y + $yofs]
  }

  puts $fout "
                <path d=\"M$x,$y v-1 h-5 v2 h5 Z\" stroke=purple stroke-width=1 fill=purple />
             "
  puts $fout "<text text-anchor=end x=[expr $x-1] y=[expr $y-3] style=\"font-family:monospace;font-size:6px\">$name</text>"

  set svar($name,I)  [expr $x-5],$y
  set svar($name,O)  $x,$y
}
# }}}
# svg_create_clock
# {{{
proc svg_create_clock {x y high low count} {
  upvar fout fout
  
  #puts $fout "<text x=\"30\" y=\"35\" style=\"font-size:8px;font-family:monospace;\">test</text>"
  puts $fout "<path stroke=\"blue\" stroke-width=\"1\" fill=\"none\" d=\"M$x $y h10 "
  for {set i 0} {$i < $count} {incr i} {
    puts $fout "v-20 h$high v20 h$low"
  }
  puts $fout "v-20 h10\"/>"
}
# }}}
# svg_attr
# {{{
proc svg_attr {name attr} {
  upvar svar svar
  return $svar($name,$attr)
}
# }}}
# svg_pin_connect
# {{{
proc svg_pin_connect {pin1 pin2 args} {
  upvar svar svar
  upvar fout fout
  set pin1_name [file tail $pin1]
  set pin1_inst [file dirname $pin1]
  set pin2_name [file tail $pin2]
  set pin2_inst [file dirname $pin2]
  svg_connect [svg_attr $pin1_inst $pin1_name] [svg_attr $pin2_inst $pin2_name] {*}$args
}
# }}}
# asave
# {{{
proc asave {aname ofile newname} {
  upvar $aname arr

  #if ![file exist $ofile] {
  #  puts "Error: godel_array_save error... $ofile not exist."
  #  return
  #}
  #parray arr
  if {[file dirname $ofile] != "."} {
    file mkdir [file dirname $ofile]
  }

  set fout [open $ofile w]
    set keys [lsort [array name arr]]
    foreach key $keys {
      set newvalue [string map {\\ {\\}} $arr($key)]
      regsub -all {\[} $key {\\[} key
      regsub -all {"}  $newvalue {\\"}  newvalue
      regsub -all {\$}  $newvalue {\\$}  newvalue
      regsub -all {\[} $newvalue {\\[}  newvalue
      regsub -all {\]} $newvalue {\\]}  newvalue
      puts $fout [format "set %-40s \"%s\"" [set newname]($key) $newvalue]
    }
  close $fout

}
# }}}
# openfile
# {{{
proc openfile {fpath} {
  global env
  if [regexp {\.pdf} $fpath] {
    if {$env(GODEL_WSL) eq "1"} {
      regsub      {\/mnt\/c\/} $fpath {c:\\\\} fpath
      regsub -all {\/}         $fpath {\\\\}   fpath
      catch {exec /mnt/c/Program\ Files\ \(x86\)/Foxit\ Software/Foxit\ PDF\ Reader/FoxitPDFReader.exe $fpath &}
    } else {
      catch {exec okular $fpath &}
    }
  } elseif [regexp {http} $fpath] {
    catch {exec /mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe $fpath &}
  } elseif [regexp {\.avi|\.mpg|\.mp4|\.rmvb|\.mkv|.webm|\.wmv|\.flv} $fpath] {
      catch {exec mpv $fpath &}
  } elseif [regexp {\.rpt} $fpath] {
      catch {exec gvim $fpath &}
  } elseif [regexp {\.epub} $fpath] {
      catch {exec ebook-viewer $fpath &}
  } elseif [regexp {\.mobi} $fpath] {
      catch {exec ebook-viewer $fpath &}
  } elseif [regexp {\.djvu} $fpath] {
      catch {exec okular $fpath &}
  } elseif [regexp {\.html} $fpath] {
      catch {exec /home/york/tools/firefox/firefox $fpath &}
  } elseif [regexp {\.pptx} $fpath] {
    puts $fpath
    regsub      {\/mnt\/c\/} $fpath {c:\\\\} fpath
    regsub -all {\/}         $fpath {\\\\}   fpath
    catch {exec /mnt/c/Program\ Files/Microsoft\ Office/root/Office16/POWERPNT.EXE  $fpath &}
  } elseif [regexp {\.xlsx} $fpath] {
    regsub      {\/mnt\/c\/} $fpath {c:\\\\} fpath
    regsub -all {\/}         $fpath {\\\\}   fpath
    catch {exec /mnt/c/Program\ Files/Microsoft\ Office/root/Office16/EXCEL.EXE  $fpath &}
  } elseif [regexp {\.docx} $fpath] {
    regsub      {\/mnt\/c\/} $fpath {c:\\\\} fpath
    regsub -all {\/}         $fpath {\\\\}   fpath
    catch {exec /mnt/c/Program\ Files/Microsoft\ Office/root/Office16/WINWORD.EXE  $fpath &}
  } elseif [regexp {\.msg} $fpath] {
    regsub      {\/mnt\/c\/} $fpath {c:\\\\} fpath
    regsub -all {\/}         $fpath {\\\\}   fpath
    catch {exec /mnt/c/Program\ Files/Microsoft\ Office/root/Office16/OUTLOOK.EXE  $fpath &}
  } elseif [regexp {\.vsdx} $fpath] {
    #regsub      {\/mnt\/c\/} $fpath {c:\\\\} fpath
    #regsub -all {\/}         $fpath {\\\\}   fpath
    #puts $fpath
    #catch {exec /mnt/c/Program\ Files\ \(x86\)/Internet\ Explorer/iexplore.exe $fpath &}
    set orig [pwd]
    cd [file dirname $fpath]
    catch {exec /mnt/c/Windows/explorer.exe . &}
    cd $orig
  } else {
    set orig [pwd]
    cd [file dirname $fpath]
    if {[info exist env(GODEL_WSL)] && $env(GODEL_WSL) eq "1"} {
      catch {exec /mnt/c/Windows/explorer.exe . &}
    } else {
      catch {exec thunar . &}
    }
    cd $orig
    puts "Error: Unkonwn filetype... $fpath"
  }
}
# }}}
# openfolder
# {{{
proc openfolder {} {
  upvar env env
  if {[info exist env(GODEL_WSL)] && $env(GODEL_WSL) eq "1"} {
    catch {exec /mnt/c/Windows/explorer.exe . &}
  } else {
    catch {exec thunar . &}
  }
}
# }}}
# at_fdel_status
# {{{
proc at_fdel_status {} {
  upvar celltxt celltxt
  upvar row row
  upvar atvar atvar
  
  if [info exist atvar($row,fdel)] {
    if {$atvar($row,fdel) eq "1"} {
      set celltxt "<td bgcolor=pink></td>"
    } else {
      set celltxt "<td></td>"
    }
  } else {
    set celltxt "<td></td>"
  }
}
# }}}
# at_fdel
# {{{
proc at_fdel {{atfile at.tcl}} {
  upvar celltxt celltxt
  upvar row row
  upvar atvar atvar

  regsub -all {'} $row {\'} txt

  set celltxt "<td><button onclick=\"at_fdel('$atfile','$txt')\" class=\"w3-button w3-blue-gray\">fdel</button></td>"
}
# }}}
# at_delete
#j {{{
proc at_delete {name} {
  upvar celltxt celltxt
  upvar row row
  upvar atvar atvar

  set celltxt "<td><button onclick=\"at_delete('at.tcl','$row')\" class=\"w3-button w3-blue-gray\">$name</button></td>"
}
# }}}
# at_open
# {{{
proc at_open {{atfile at.tcl}} {
  upvar celltxt celltxt
  upvar row row
  upvar atvar atvar

  regsub -all {'} $row {\'} txt

  set celltxt "<td style=\"cursor:pointer;\" bgcolor=lightblue onclick=\"at_open('$atfile','$txt')\">O</td>"
}
# }}}
# at_mpv
# {{{
proc at_mpv {} {
  upvar celltxt celltxt
  upvar row row
  upvar atvar atvar

  set celltxt "<td><button onclick=\"at_mpv('at.tcl','$row')\" class=\"w3-button w3-blue-gray\">mpv</button></td>"
}
# }}}
# atcols_onoff
# {{{
proc atcols_onoff {str} {
  upvar atcols atcols

  set cols [split $str ";"]

  set onoff_key [lindex $cols 0]
  regsub {^\s*} $onoff_key {} onoff_key
  regsub {\s*$} $onoff_key {} onoff_key
  set key       [lindex $cols 1]
  regsub {^\s*} $key {} key
  regsub {\s*$} $key {} key
  set disp      [lindex $cols 2]

  if {[lvars . $onoff_key] eq "1"} {
    lappend atcols "$key;$disp"
  }
}
# }}}
# cols_onoff
# {{{
proc cols_onoff {str} {
  upvar cols cols

  set cc [split $str ";"]

  set onoff_key [lindex $cc 0]
  regsub {^\s*} $onoff_key {} onoff_key
  regsub {\s*$} $onoff_key {} onoff_key

  set key       [lindex $cc 1]
  regsub {^\s*} $key {} key
  regsub {\s*$} $key {} key

  set disp      [lindex $cc 2]

  if {$onoff_key eq "1"} {
      lappend cols "$key;$disp"
  } else {
    if {[lvars . $onoff_key] eq "1"} {
      lappend cols "$key;$disp"
    }
  }
}
# }}}
# ltable_exe (outdated)
# {{{
proc ltable_exe {name exefile} {
  upvar row row
  upvar celltxt celltxt

  set runfile "$row/$exefile"

  set celltxt "<td><a href=\"$runfile\" type=text/gtcl>$name</a></td>"
}
# }}}
# ltbl_exe
# {{{
proc ltbl_exe {name exefile} {
  upvar row row
  upvar celltxt celltxt

  set runfile "$row/$exefile"
  if [file exist $runfile] {
    set celltxt "<td><a href=\"$runfile\" type=text/gtcl>$name</a></td>"
  } else {
    set celltxt "<td>NA</td>"
  }

}
# }}}
# ltbl_edfile
# {{{
proc ltbl_edfile {vname} {
  upvar row row
  upvar celltxt celltxt

  set linkopen [lvars . linkopen]
  set value    [lvars $row $vname]

  if {$linkopen eq "1"} {
    if {$value eq "NA" || $value eq ""} {
      set celltxt "<td gname=\"$row\" colname=\"$vname\" contenteditable=\"true\" style=\"white-space:pre\"></td>"
    } else {
      if {[llength $value] > 1} {
        set txt ""
        foreach f $value {
          if [file exist $f] {
            append txt "<a href=$f type=text/txt>$f</a><br>"
          } else {
            append txt "$f<br>"
          }
        }
        set celltxt "<td>$txt</td>"
      } else {
      if [file exist $row/$value] {
        set celltxt "<td style=\"white-space:pre\"><a href=\"$row/$value\" type=text/txt>$value</a></td>"
      } elseif [file exist $value] {
        set celltxt "<td style=\"white-space:pre\"><a href=\"$value\" type=text/txt>$value</a></td>"
      } else {
        set celltxt "<td gname=\"$row\" colname=\"$vname\" contenteditable=\"true\" style=\"white-space:pre\">$value</td>"
      }
      }
    }
  } else {
    if {$value eq "NA"} {
      set celltxt "<td gname=\"$row\" colname=\"$vname\" contenteditable=\"true\" style=\"white-space:pre\"></td>"
    } else {
      set txt ""
      foreach f $value {
        append txt "$f<br>"
      }
      set celltxt "<td gname=\"$row\" colname=\"$vname\" contenteditable=\"false\" style=\"white-space:pre\">$txt</td>"
    }
  }
}
# }}}
# at_filter
# {{{
proc at_filter {key filter_value} {
  upvar atvar atvar
  upvar atrows atrows

  set trows ""

  foreach row $atrows {
    if {$key eq "id"} {
      set value $row
      if [regexp "$filter_value" $value] {
        lappend trows $row
      }
    } else {
      if [info exist atvar($row,$key)] {
        set value $atvar($row,$key)
        if [regexp "$filter_value" $value] {
          lappend trows $row
        }
      }
    }
  }
  set atrows $trows
}
# }}}
# at_cover
# {{{
proc at_cover {args} {
  upvar atvar atvar
  upvar atrows atrows
  # -col
# {{{
  set opt(-col) 0
  set idx [lsearch $args {-col}]
  if {$idx != "-1"} {
    set val(-col) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-col) 1
  } else {
    set pattern *
  }
# }}}
  # -pattern
# {{{
  set opt(-pattern) 0
  set idx [lsearch $args {-pattern}]
  if {$idx != "-1"} {
    set val(-pattern) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-pattern) 1
  } else {
    set pattern *
  }
# }}}

  set trows ""
  set count 0
    if {$val(-col) eq "id"} {
      foreach row $atrows {
        set value $row
        if [regexp "$val(-pattern)" $value] {
          incr count
        } else {
          lappend trows $row
        }
      }
    } else {
      foreach row $atrows {
        if [info exist atvar($row,$val(-col))] {
          set value $atvar($row,$val(-col))
          if [regexp "$val(-pattern)" $value] {
            incr count
          } else {
            lappend trows $row
          }
        }
      }
    }
  set atrows $trows
  lsetvar . $val(-pattern),count $count
}
# }}}
# css_hide
# {{{
proc css_hide {} {
  upvar fout fout

  ghtm_onoff css_hide -name Hide

  set css_ctrl [lvars . css_hide]

  puts $fout "<style>"

  if {$css_ctrl eq "1"} {
    puts $fout "rect:hover {"
    #puts $fout "  fill: red !important;"
    puts $fout "  cursor: pointer;"
    #puts $fout "  opacity: 0.1 !important;"
    puts $fout "}"
  } else {
    puts $fout "rect {"
    puts $fout "  fill: none !important;"
    puts $fout "}"
  }


  puts $fout "</style>"

}
# }}}
# get_atvar
# {{{
proc get_atvar {key} {
  upvar atvar atvar

  if [info exist atvar($key)] {
    return $atvar($key)
  } else {
    return NA
  }
}
# }}}
# at_get_rows
# {{{
proc at_get_rows {} {
  upvar atvar atvar
  foreach n [array names atvar] {
    set cols [split $n ,]
    lappend ns [join [lrange $cols 0 end-1] ","]
  }
  set atrows [lsort -unique $ns]
  return $atrows
}
# }}}
# atable
# {{{
proc atable {args} {
  upvar env env
  # -local
# {{{
  set opt(-local) 0
  set idx [lsearch $args {-local}]
  if {$idx != "-1"} {
    set localfile [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-local) 1
  } else {
    set localfile NA
  }
# }}}
  # -rowctrl
# {{{
  set opt(-rowctrl) 0
  set idx [lsearch $args {-rowctrl}]
  if {$idx != "-1"} {
    set rowctrl_proc [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-rowctrl) 1
  } else {
    set rowctrl_proc NA
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
  # -dataTables
# {{{
  set opt(-dataTables) 0
  set idx [lsearch $args {-dataTables}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-dataTables) 1
  }
# }}}
  # -noshow
# {{{
  set opt(-noshow) 0
  set idx [lsearch $args {-noshow}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-noshow) 1
  }
# }}}
  # -noid
# {{{
  set opt(-noid) 0
  set idx [lsearch $args {-noid}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-noid) 1
  }
# }}}
  # -num
# {{{
  set opt(-num) 0
  set idx [lsearch $args {-num}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-num) 1
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
  # -sortby (sort by...)
# {{{
  set opt(-sortby) 0
  set idx [lsearch $args {-sortby}]
  if {$idx != "-1"} {
    set sortby [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-sortby) 1
  }
# }}}
  # -sortopt (sort options"
# {{{
  set opt(-sortopt) 0
  set idx [lsearch $args {-sortopt}]
  if {$idx != "-1"} {
    set val(-sortopt) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-sortopt) 1
  } else {
    set val(-sortopt) "-ascii"
  }
# }}}
  # -tableid
# {{{
  set opt(-tableid) 0
  set idx [lsearch $args {-tableid}]
  if {$idx != "-1"} {
    set tableid [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-tableid) 1
  } else {
    set tableid tbl
  }
# }}}

  upvar fout fout
  upvar atrows atrows
  upvar atcols atcols


  set atfname [lindex $args 0]

  if ![file exist $atfname] {
    return
  }
  source $atfname

  if [file exist $localfile] {
    godel_array_read $localfile latvar atvar
  }

# atcols
  set ns ""
  if ![info exist atcols] {
    foreach n [array names atvar] {
      regsub {^\S+,} $n {} n
      lappend ns $n
    }
    set atcols [lsort -unique $ns]
  }
# atrows
  if {$opt(-f) eq "1"} {
    set kin [open $listfile r]

    while {[gets $kin line] >= 0} {
      if {[regexp {^\s*#} $line]} {
      } elseif {[regexp {^\s*$} $line]} {
      } else {
        lappend atrows $line
      }
    }
    close $kin
  } else {
    set ns ""
    if ![info exist atrows] {
      foreach n [array names atvar] {
        set cols [split $n ,]
        lappend ns [join [lrange $cols 0 end-1] ","]
      }
      set atrows [lsort -unique $ns]
    }
  }

  # Sort by...
# {{{
  if {$opt(-sortby)} {
    ## Create row_items for sorting
    set row_items {}
    foreach atrow $atrows {
      if [info exist atvar($atrow,$sortby)] {
        set sdata $atvar($atrow,$sortby)
      } else {
        set sdata ""
      }
      if {$sdata eq "NA" || $sdata eq ""} {
        if [regexp {\-ascii} $val(-sortopt)] {
          set sdata "~"
        } else {
          set sdata 0
        }
      }
      lappend row_items [list $atrow $sdata]
    }

    ## Sorting...
    set row_items [lsort -index 1 {*}$val(-sortopt) $row_items]

    # Re-create rows based on sorted row_items
    set atrows {}
    foreach i $row_items {
      lappend atrows [lindex $i 0]
    }
  }
# }}}
# Buttons
if {$opt(-noshow) eq "1"} {
} else {
  #puts $fout "Total: [llength $atrows]"
  #puts $fout "<a href=\".godel/draw.gtcl\" type=text/gtcl class=\"w3-bar-item w3-button w3-blue-gray\">Draw</a>"
  #puts $fout "<button onclick=\"at_save('$atfname')\" class=\"w3-bar-item w3-button w3-blue-gray\">Save</button>"
  #puts $fout "<a href=\"$atfname\" type=text/txt>$atfname</a>"
  if [file exist "src.tcl"] {
    puts $fout "<a href=\"src.tcl\" type=text/txt>src.tcl</a>"
  }
  if [file exist $listfile] {
    puts $fout "<a href=\"$listfile\" type=text/txt>$listfile</a>"
  }
}

# Header
  puts $fout "<table class=$css_class id=$tableid tbltype=atable atfname=$atfname>"
  puts $fout "<thead>"
  puts $fout "<tr>"
  if {$opt(-num) eq "1"} {
    puts $fout "<th>num</th>"
  }
  if {$opt(-noid) eq "1"} {
  } else {
    puts $fout "<th>id</th>"
  }

  foreach col $atcols {
    set colname ""
    if [regexp {;} $col] {
      set cs [split $col ";"]
      set colname [lindex $cs 1]
      set page_key [lindex $cs 0]
      regsub {edtable:} $page_key {} page_key

      if {$colname == ""} {
        puts $fout "<th></th>"
      } else {
        puts $fout "<th colname=\"$page_key\">$colname</th>"
      }
    } else {
      set colname $col
      puts $fout "<th colname=\"$colname\">$colname</th>"
    }
  }
  puts $fout "</tr>"
  puts $fout "</thead>"

# foreach atrows
  set num 1
  foreach row $atrows {
    regsub {^\s+} $row {} row
    if {$opt(-rowctrl) eq "1"} {
      eval $rowctrl_proc
    } else {
      puts $fout "<tr>"
    }
    if {$opt(-num) eq "1"} {
      puts $fout "<td>$num</td>"
    }
    if {$opt(-noid) eq "1"} {
    } else {
      puts $fout "<td gname=\"$row\" colname=\"id\" style=\"white-space:pre\">$row</td>"
    }
    foreach col $atcols {
      set cs [split $col ";"]
      set col [lindex $cs 0]
      regsub {\s+$} $col {} col

      set celltxt {}
      if [regexp {proc:} $col] {
        regsub {proc:} $col {} col
        set procname $col
        eval $procname
      } elseif [regexp {^ed:} $col] {
        regsub {^ed:} $col {} col
        if ![info exist atvar($row,$col)] {
          set atvar($row,$col) ""
        }
        set value $atvar($row,$col)
        append celltxt "<td gname=\"$row\" colname=\"$col\" contenteditable=\"true\"><pre style=\"white-space:pre\">$value</pre></td>"
      } else {
        if ![info exist atvar($row,$col)] {
          set atvar($row,$col) ""
        }
        set value $atvar($row,$col)
        append celltxt "<td gname=\"$row\" colname=\"$col\" style=\"white-space:pre\">$value</td>"
      }
      puts $fout $celltxt
    }
    puts $fout "</tr>"
    incr num
  }
  puts $fout "</table>"

    if {$opt(-dataTables) eq "1"} {
            if {$env(GODEL_EMB_CSS) eq "1"} {
              puts $fout "<script src=.godel/js/jquery.dataTables.min.js></script>"
            } else {
              puts $fout "<script src=$env(GODEL_ROOT)/scripts/js/jquery.dataTables.min.js></script>"
            }
            puts $fout "<script>"
            puts $fout "    \$(document).ready(function() {"
            puts $fout "    \$('#$tableid').DataTable({"
            puts $fout "       \"paging\": false,"
            puts $fout "       \"info\": false,"
            puts $fout "       \"order\": \[\],"
            puts $fout "    });"
            puts $fout "} );"
            puts $fout "</script>"
    }
}
# }}}
# alinkurl
# {{{
proc alinkurl {} {
  upvar env     env
  upvar atvar   atvar
  upvar row     row
  upvar celltxt celltxt

  set value [get_atvar $row,url]

  if {$value eq "NA"} {
    set celltxt "<td style=\"font-size:8px\" gname=\"$row\" colname=\"url\" contenteditable=\"true\"></td>"
  } else {
    if {[info exist env(GODEL_WSL)] && $env(GODEL_WSL) eq "1"} {
      set celltxt "<td><button onclick=\"chrome_open('$value')\">Link</button></td>"
    } else {
      set celltxt "<td><a href=$value target=blank>Link</a></td>"
    }
  }

}
# }}}
# ltbl_lsdirs
# {{{
proc ltbl_lsdirs {pattern} {
  upvar env env
  upvar row row
  upvar celltxt celltxt

  set ifiles [lsort -decreasing [glob -nocomplain -type d $row/$pattern]]

      set links {<pre>}
      foreach f $ifiles {
        set name [file tail $f]
        append links "<a href=\"$f/.index.htm\">$name</a> "
      }
      append links {</pre>}
      append celltxt "<td>$links</td>"

}
# }}}
# ltbl_flist
# {{{
proc ltbl_flist {pattern} {
  upvar env env
  upvar row row
  upvar celltxt celltxt

  set ifiles [glob -nocomplain -type f $row/$pattern]

      set links {<pre>}
      foreach f $ifiles {
        set name [file tail $f]
        append links "<a href=\"$f\">$name</a>\n"
      }
      append links {</pre>}
      append celltxt "<td>$links</td>"

}
# }}}
# ltbl_linkurl
# {{{
proc ltbl_linkurl {key} {
  upvar env env
  upvar row row
  upvar celltxt celltxt

  set urlvalue [lvars $row $key]

  if {$urlvalue eq "NA"} {
    set celltxt "<td gname=\"$row\" colname=\"$key\" contenteditable=\"true\"></td>"
  } else {
    if {[info exist env(GODEL_WSL)] && $env(GODEL_WSL) eq "1"} {
      set celltxt "<td><button onclick=\"chrome_open('$urlvalue')\">url</button></td>"
    } else {
      set celltxt "<td><a href=\"$urlvalue\">$key</td>"
    }
  }
}
# }}}
# at_lnpage
# {{{
proc at_lnpage {} {
  upvar row row
  upvar celltxt celltxt
  upvar atvar atvar

  set value [get_atvar $row,lnpage]

  if {$value eq "NA" || $value eq ""} {
    set celltxt "<td gname=\"$row\" colname=\"lnpage\" contenteditable=\"true\"></td>"
  } else {
      if [file exist $value/.index.htm] {
        set celltxt "<td><a href=\"$value/.index.htm\">$value</td>"
      } else {
        file mkdir $value
        exec godel_draw.tcl $value
        set celltxt "<td><a href=\"$value/.index.htm\">$value</td>"
      }
  }
}
# }}}
# ltbl_star
# {{{
proc ltbl_star {} {
  upvar row row
  upvar celltxt celltxt

  set value [lvars $row star]

  if {$value eq "1"} {
    set celltxt "<td gclass=\"onoff\" gname=\"$row\" colname=\"star\" bgcolor=\"yellow\" onoff=\"1\">1</td>"
  } else {
    set celltxt "<td gclass=\"onoff\" gname=\"$row\" colname=\"star\" onoff=\"0\"></td>"
  }
}
# }}}
# svg_line
# {{{
proc svg_line {x1 y1 x2 y2} {
  upvar ymax ymax
  upvar shrink shrink
  upvar fout fout
  set x1 [expr $x1/$shrink]
  set y1 [expr $y1/$shrink]
  set x2 [expr $x2/$shrink]
  set y2 [expr $y2/$shrink]

  set newx1 $x1
  set newy1 [expr $ymax/$shrink - $y1 ]
  set newx2 $x2
  set newy2 [expr $ymax/$shrink - $y2 ]
  puts $fout "<line x1=$newx1 y1=$newy1 x2=$newx2 y2=$newy2 stroke=black />"
}
# }}}
# svg_point
# {{{
proc svg_point {x y} {
  upvar shrink shrink
  upvar fout fout
  upvar ymax ymax
  set x [expr $x/$shrink]
  set y [expr $y/$shrink]
  set newx $x
  set newy [expr $ymax/$shrink - $y ]
  puts $fout "<circle cx=$newx cy=$newy r=3 />"
}
# }}}
# folder
# {{{
proc folder {} {
  upvar row row
  upvar celltxt celltxt
  set kout [open $row/open.gtcl w]
    puts $kout "cd [pwd]/$row"
    puts $kout "catch {exec /mnt/c/Windows/explorer.exe .}"
  close $kout
  set celltxt "<td><a href=$row/open.gtcl type=text/gtcl>folder</a></td>"
}
# }}}
# csplit_init
# {{{
proc csplit_init {args} {
  upvar fout fout
  # -width
# {{{
  set opt(-width) 0
  set idx [lsearch $args {-width}]
  if {$idx != "-1"} {
    set val(-width) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-width) 1
  } else {
    set val(-width) 50% 
  }
# }}}
  puts $fout {
  <style>
  * {
    box-sizing: border-box;
  }
  
  .column {
    float: left;
    width: $val(-width);
    padding: 10px;
  }
  
  .row:after {
    content: "";
    display: table;
    clear: both;
  }
  </style>
  }

}
# }}}
# csplit_begin
# {{{
proc csplit_begin {} {
  upvar fout fout
  puts $fout {<div class="row">}
}
# }}}
# csplit_sub_begin
# {{{
proc csplit_sub_begin {} {
  upvar fout fout
  puts $fout {  <div class="column">}
}
# }}}
# csplit_end
# {{{
proc csplit_end {} {
  upvar fout fout
  puts $fout {</div>}
}
# }}}
# csplit_sub_end
# {{{
proc csplit_sub_end {} {
  upvar fout fout
  puts $fout {  </div>}
}
# }}}
# var_table
# {{{
proc var_table {} {
  upvar fout fout
  upvar rows rows

  puts $fout "<table class=table1 id=tbl1>"
  foreach row $rows {
    set cols [split $row ";"]
    set name [lindex $cols 0]
    set type [lindex $cols 1]
    set fpath [lindex $cols 2]
  
    puts $fout "<tr>"
# mf:multiple files
      if {$type eq "mf"} {
        puts $fout "<td>$name</td>"
        if [file exist $fpath] {
          set kin [open $fpath r]
            set value ""
            while {[gets $kin line] >= 0} {
              if [file exist $line] {
                append value "<a href=$line type=text/txt>$line</a><br>"
              } else {
                append value "<a style=background-color:lightgrey href=$line type=text/txt>$line</a><br>"
              }
            }
          close $kin
        } else {
          set value ""
          set kout [open $fpath w]
          close $kout
        }
        set symbol &#9701;
        puts $fout "<td><span style=float:right><a style=text-decoration:none href=\"$fpath\" type=text/txt>$symbol</a></span>$value</td>"
# f:file
      } elseif {$type eq "f"} {
        set value [lvars . $name]
        if {$value eq "NA"} {
            puts $fout "<td>$name</td>"
            puts $fout "<td gname=\".\" colname=\"$name\" contenteditable=\"true\" ></td>"
        } else {
          if {[llength $value] > 1} {
              puts $fout "<td>$name</td>"
              puts $fout "<td gname=\".\" colname=\"$name\" contenteditable=\"true\"  style=\"white-space:pre\">$value</td>"
          } else {
            if [file exist $value] {
              puts $fout "<td><a href=$value type=text/txt>$name</a></td>"
              puts $fout "<td gname=\".\" colname=\"$name\" contenteditable=\"true\"  style=\"white-space:pre\">$value</td>"
            } else {
              puts $fout "<td>$name</td>"
              puts $fout "<td bgcolor=lightgrey gname=\".\" colname=\"$name\" contenteditable=\"true\"  style=\"white-space:pre\">$value</td>"
            }
          }
        }
# value
      } else {
        puts $fout "<td>$name</td>"
        set value [lvars . $name]
        if {$value eq "NA"} {
          set value ""
          puts $fout "<td width=30px gname=\".\" colname=\"$name\" contenteditable=\"true\" style=\"white-space:pre\"></td>"
        } else {
          puts $fout "<td gname=\".\" colname=\"$name\" contenteditable=\"true\" style=\"white-space:pre\">$value</td>"
        }
      }
    puts $fout "</tr>"
  }
  puts $fout "</table>"
}
# }}}
# gtcl_commit
# {{{
proc gtcl_commit {} {
  upvar env env
  set gtcl $env(GODEL_DOWNLOAD)/gtcl.tcl
  if [file exist $gtcl] {

    set kin [open $gtcl r]
      set data [read $kin]
    close $kin
    
    if [file exist $env(GODEL_DOWNLOAD)/ginst.tcl] {
      source      $env(GODEL_DOWNLOAD)/ginst.tcl
      file delete $env(GODEL_DOWNLOAD)/ginst.tcl
      file delete $gtcl

    } else {
      package require textutil
      set chunks [::textutil::split::splitx $data "\\|E\\|"]

      set chunks [lreplace $chunks end end] 

      set dels ""
      array set adels {}
      array set afdels {}
      foreach chunk $chunks {
        set cols [::textutil::split::splitx $chunk "\\|#\\|"]
        set gpage_tmp [lindex $cols 0]
        set key     [lindex $cols 1]
        set value   [lindex $cols 2]
        set atfname [lindex $cols 3]

        regsub {\n}  $gpage_tmp {} gpage_tmp
        regsub {\n$} $value {} value
        regexp {^(\w)(.*)} $gpage_tmp whole tbltype gpage

        if {$tbltype eq "a"} {
          if {$key eq "DEL"} {
            lappend adels($atfname) $gpage
          } elseif {$key eq "fdel"} {
            lappend afdels($atfname) $gpage
          } else {
            asetvar $gpage,$key $value $atfname
          }
        } else {
          if {$key eq "DEL"} {
            lappend dels $gpage
          } else {
            lsetvar $gpage $key $value
          }
        }
      }

# delete gpage
      if {$dels eq ""} {
      } else {
        catch {exec rm -rf {*}$dels}
      }

# adels
      if {[array names adels] eq ""} {
      } else {
        foreach atfname [array names adels] {
          source $atfname
          foreach adel $adels($atfname) {
            array unset atvar $adel*
          }
          godel_array_save atvar $atfname
        }
      }

# afdels
      if {[array names afdels] eq ""} {
      } else {
        foreach atfname [array names afdels] {
          source $atfname
          foreach afdel $afdels($atfname) {
            catch {exec rm -f $atvar($afdel,path)}
            array unset atvar $afdel*
          }
          godel_array_save atvar $atfname
        }
      }


      file delete $gtcl
    }
    
  }
}
# }}}
# ghtm_ls_table
# {{{
proc ghtm_ls_table {args} {
  upvar fout fout
  upvar env env
  # -dir
# {{{
  set opt(-dir) 0
  set idx [lsearch $args {-dir}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-dir) 1
  }
# }}}
  # -dataTables
# {{{
  set idx [lsearch $args {-dataTables}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    upvar dataTables dataTables
    set dataTables 1
  } else {
    set dataTables 0
  }
# }}}
  # -id
# {{{
  set opt(-id) 0
  set idx [lsearch $args {-id}]
  if {$idx != "-1"} {
    set val(-id) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-id) 1
  } else {
    set val(-id) na
  }
# }}}
  # -pattern
# {{{
  set opt(-pattern) 0
  set idx [lsearch $args {-pattern}]
  if {$idx != "-1"} {
    set pattern [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-pattern) 1
    set ifiles [lsort [glob -nocomplain -type f $pattern]]
  } else {
    set pattern *
  }
# }}}
  # -listvar
# {{{
  set opt(-listvar) 0
  set idx [lsearch $args {-listvar}]
  if {$idx != "-1"} {
    set varfiles [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-listvar) 1
  } else {
    set val(-listvar) na
  }
# }}}
  # -srcdirs
# {{{
  set opt(-srcdirs) 0
  set idx [lsearch $args {-srcdirs}]
  if {$idx != "-1"} {
    set val(-srcdirs) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-srcdirs) 1
  } else {
    set val(-srcdirs) na
  }
# }}}
  # -nonum
# {{{
  set idx [lsearch $args {-nonum}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-nonum) 1
  } else {
    set opt(-nonum) 0
  }
# }}}

  set ifiles ""
  if {$opt(-pattern)} {
    if {$opt(-srcdirs)} {
      foreach dir $val(-srcdirs) {
        set ifiles [concat $ifiles [glob -nocomplain -type f $dir/$pattern]]
      }
      set ifiles [lsort $ifiles]
    } else {
      set ifiles [lsort [glob -nocomplain -type f $pattern]]
    }
  } elseif {$opt(-listvar)} {
    set ifiles $varfiles
  }
  
  set count 1
    puts $fout "<pre>"
  if {$opt(-srcdirs)} {
    foreach dir $val(-srcdirs) {
      puts $fout $dir
    }
  }
    puts $fout "</pre>"
  puts $fout "<table class=table1 id=$val(-id)>"

  puts $fout "<thead>"
  puts $fout "<tr>"
    if {$opt(-nonum) eq "0"} {
      puts $fout "<th>Num </th>"
    }
    puts $fout "<th>Date</th>"
    puts $fout "<th>Size</th>"
    puts $fout "<th>Name</th>"
    if {$opt(-dir) eq "1"} {
      puts $fout "<th>Dir</th>"
    }
  puts $fout "</tr>"
  puts $fout "</thead>"

  puts $fout "<tdata>"
  foreach ifile $ifiles {
    puts $fout "<tr>"

    if [file exist $ifile] {
      set mtime [file mtime $ifile]
      #if {[file type $ifile] eq "link"} {
      #  set fname [file tail [file readlink $ifile]]
      #  set ori [pwd]
      #  cd [file dirname [file readlink $ifile]]
      #  set realpath [pwd]
      #  cd $ori
      #  set linktarget $realpath/$fname
      #} else {
        set linktarget $ifile
      #}
      #set timestamp [clock format $mtime -format {%Y-%m-%d_%H:%M}]
      set timestamp [clock format $mtime -format {%m-%d_%H:%M}]
      set fsize [file size $ifile]
      set fsize [num_symbol $fsize K]
      set fname [file tail $ifile]
      set dir   [file dirname $ifile]
      if {$opt(-nonum) eq "0"} {
        puts $fout "<td>$count</td>"
      }
      puts $fout "<td>$timestamp</td>"
      puts $fout "<td>$fsize</td>"
      if [regexp {\.htm} $ifile] {
        puts $fout "<td><a href=\"$linktarget\"              >$fname</a></td>"
      } elseif [regexp {\.mp4|\.mkv|\.webm|\.rmvb} $ifile] {
        puts $fout "<td><a href=\"$linktarget\" type=text/mp4>$fname</a></td>"
      } elseif [regexp {\.mp3} $ifile] {
        puts $fout "<td><a href=\"$linktarget\" type=text/mp3>$fname</a></td>"
      } elseif [regexp {\.pdf} $ifile] {
        puts $fout "<td><a href=\"$linktarget\" type=text/pdf>$fname</a></td>"
      } elseif [regexp {\.svg} $ifile] {
        puts $fout "<td><a href=\"$linktarget\" type=text/svg>$fname</a></td>"
      } elseif [regexp {\.epub} $ifile] {
        puts $fout "<td><a href=\"$linktarget\"              >$fname</a></td>"
      } elseif {[regexp -nocase {\.jpg|\.png|\.gif} $ifile]}  {
        puts $fout "<td><a href=\"$linktarget\" type=text/jpg>$fname</a></td>"
      } else {
        puts $fout "<td><a href=\"$linktarget\" type=text/txt>$fname</a></td>"
      }
      if {$opt(-dir) eq "1"} {
        puts $fout "<td>$dir</td>"
      }
    } else {
      if {$opt(-nonum) eq "0"} {
        puts $fout "<td>$count</td>"
      }
      puts $fout "<td></td>"
      puts $fout "<td></td>"
      puts $fout "<td bgcolor=lightgrey>[file tail $ifile]</td>"
    }

    puts $fout "</tr>"

    incr count
  }

  puts $fout "</tdata>"
  puts $fout "</table>"

  if {$dataTables eq "1"} {
            if {$env(GODEL_EMB_CSS) eq "1"} {
              puts $fout "<script src=.godel/js/jquery.dataTables.min.js></script>"
            } else {
              puts $fout "<script src=$env(GODEL_ROOT)/scripts/js/jquery.dataTables.min.js></script>"
            }
      puts $fout "<script>"
      puts $fout "    \$(document).ready(function() {"
      puts $fout "    \$('#$val(-id)').DataTable({"
      puts $fout "       \"paging\": false,"
      puts $fout "       \"info\": false,"
      puts $fout "       \"order\": \[\],"
      puts $fout "    });"
      puts $fout "} );"
      puts $fout "</script>"
  }
}
# }}}
# opt_bton
# {{{
proc opt_bton {args} {
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
  #    puts $fout "<a href=$exefile class=\"w3-btn w3-blue\" type=text/gtcl><b>$name</b></a><a class=\"w3-button w3-lime\" href=$exefile type=text/txt>cmd</a>"
  #} else {
      #puts $fout "<a href=$exefile class=\"w3-btn w3-blue\" type=text/gtcl><b>$name</b></a><a class=\"w3-button w3-lime\" href=$exefile type=text/txt>cmd</a>"
      set cur_value [lvars . $key]
      if {$cur_value eq $value} {
        puts $fout "<a href=$exefile class=\"w3-btn w3-pink\" type=text/gtcl><b>$name</b></a>"
      } else {
        puts $fout "<a href=$exefile class=\"w3-btn w3-blue\" type=text/gtcl><b>$name</b></a>"
      }

    set kout [open "$exefile" w]
      puts $kout "set pagepath \[file dirname \[info script]]"
      puts $kout "cd \$pagepath"
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "lsetvar . $key \"$value\""
      puts $kout "godel_draw"
      puts $kout "catch {exec xdotool search --name \"Mozilla\" key ctrl+r}"
    close $kout
  #}
  
}
# }}}
# msg_start
# {{{
proc msg_start {} {
  global gtime
  set timestamp [clock format [clock seconds] -format {%Y-%m-%d %H:%M}]

  puts "# INFO : Start at $timestamp"

  set gtime(begin,date) $timestamp
  set gtime(begin,seconds) [clock seconds]

}
# }}}
# msg_end
# {{{
proc msg_end {} {
  global gtime
  set timestamp [clock format [clock seconds] -format {%Y-%m-%d %H:%M}]


  set gtime(end,date) $timestamp
  set gtime(end,seconds) [clock seconds]

  set total  [ss2hhmmss [expr [clock seconds] - $gtime(begin,seconds)]]

  lsetvar . runtime $total

  puts "# INFO : End at $timestamp"
  puts "# INFO : Total runtime $total"

}
# }}}
# msg
# {{{
proc msg {args} {
  global gtime
  # -begin
# {{{
  set opt(-begin) 0
  set idx [lsearch $args {-begin}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-begin) 1
  }
# }}}
  # -end
# {{{
  set opt(-end) 0
  set idx [lsearch $args {-end}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-end) 1
  }
# }}}
  set secname [lindex $args 0]

  set timestamp [clock format [clock seconds] -format {%Y-%m-%d %H:%M}]

  if {$opt(-begin)} {
    set total  [ss2hhmmss [expr [clock seconds] - $gtime(begin,seconds)]]
    set gtime($secname,begin) [clock seconds]
    puts "# SECTION_BEGIN : $secname : $timestamp : $total"

  }
  if {$opt(-end)} {
    set total  [ss2hhmmss [expr [clock seconds] - $gtime(begin,seconds)]]
    set gtime($secname,end) [clock seconds]
    set elaspe [ss2hhmmss [expr $gtime($secname,end) - $gtime($secname,begin)]]
    puts "# SECTION_END : $secname : $timestamp : $total : $elaspe"
  }

}
# }}}
# linkbox
# {{{
proc linkbox {args} {
  upvar fout fout
  # -name
# {{{
  set opt(-name) 0
  set idx [lsearch $args {-name}]
  if {$idx != "-1"} {
    set val(-name) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-name) 1
  } else {
    set val(-name) ""
  }
# }}}
  # -bgcolor
# {{{
  set opt(-bgcolor) 0
  set idx [lsearch $args {-bgcolor}]
  if {$idx != "-1"} {
    set val(-bgcolor) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-bgcolor) 1
  } else {
    set val(-bgcolor) pale-green
  }
# }}}
  # -target
# {{{
  set opt(-target) 0
  set idx [lsearch $args {-target}]
  if {$idx != "-1"} {
    set val(-target) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-target) 1
  } else {
    set val(-target) pale-green
  }
# }}}
  # -asize
# {{{
  set opt(-asize) 0
  set idx [lsearch $args {-asize}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-asize) 1
  }
# }}}
  # -gsize
# {{{
  set opt(-gsize) 0
  set idx [lsearch $args {-gsize}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-gsize) 1
  }
# }}}


  set name [lindex $args 0]

  if {$opt(-name) eq "1"} {
    set dispname  $val(-name)
  } else {
    set dispname  $name
  }

  if {$opt(-target)} {
    set target $val(-target)
  } else {
    set target $name/.index.htm
  }

  set txtsize ""
  if {$opt(-asize) eq "1"} {
    cd $name
    source at.tcl
    set size [llength [at_allrows]]
    cd ..
    set txtsize "($size)"
  } elseif {$opt(-gsize) eq "1"} {
    cd $name
    puts [pwd]
    set size [llength [glob -nocomplain -type d *]]
    cd ..
    set txtsize "($size)"
  }

  if [file exist $target] {
    puts $fout "<a class=\"w3-$val(-bgcolor) w3-padding w3-large w3-round-large w3-hover-red\" style=\"text-decoration:none\" href=\"$target\">$dispname$txtsize</a>"
  } else {
    #puts $fout "<a class=\"w3-blue-gray w3-padding w3-large w3-round-large w3-hover-red\" style=\"text-decoration:none\" href=\"$target\">$dispname$txtsize</a>"
  }
}
# }}}
# qsetvar
# {{{
proc qsetvar {gpage key value} {
  if [file exist $value] {
    lsetvar $gpage $key $value
  } else {
    puts "Error: qsetvar: not exist... $value"
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
# ltbl_chk
# {{{
proc ltbl_chk {name {bgcolor lightgreen}} {
  upvar celltxt celltxt
  upvar row     row

  set value [lvars $row $name]

  if {$value eq "1"} {
    set celltxt "<td gclass=\"onoff\" gname=\"$row\" colname=\"$name\" bgcolor=\"$bgcolor\" onoff=\"1\"></td>"
  } else {
    set celltxt "<td gclass=\"onoff\" gname=\"$row\" colname=\"$name\" onoff=\"0\"></td>"
  }
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
  # -fname 
# {{{
  set opt(-fname) 0
  set idx [lsearch $args {-fname}]
  if {$idx != "-1"} {
    set fname [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-fname) 1
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

  set cur_value [lvars . $key]
  if {$opt(-fname) eq "0"} {
    set fname $name
  }
  
  set exefile ".set_$fname.gtcl"

  #if [file exist $exefile] {
  #    puts $fout "<a href=$exefile class=\"w3-btn w3-blue\" type=text/gtcl><b>$name</b></a><a class=\"w3-button w3-lime\" href=$exefile type=text/txt>cmd</a>"
  #} else {
      #puts $fout "<a href=$exefile class=\"w3-btn w3-blue\" type=text/gtcl><b>$name</b></a><a class=\"w3-button w3-lime\" href=$exefile type=text/txt>cmd</a>"
      if {$cur_value eq $value} {
        puts $fout "<a href=$exefile class=\"w3-btn w3-pink\" type=text/gtcl><b>$name</b></a>"
      } else {
        puts $fout "<a href=$exefile class=\"w3-btn w3-blue\" type=text/gtcl><b>$name</b></a>"
      }
    set kout [open "$exefile" w]
      puts $kout "set pagepath \[file dirname \[info script]]"
      puts $kout "cd \$pagepath"
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "lsetvar . $key \"$value\""
      puts $kout "godel_draw"
      puts $kout "catch {exec xdotool search --name \"Mozilla\" key ctrl+r}"
    close $kout
  #}
  
}
# }}}
# bton_onoff
# {{{
proc bton_onoff {args} {
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
    set val(-value) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-value) 1
  }
# }}}
  # -count
# {{{
  set idx [lsearch $args {-count}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-count) 1
  } else {
    set opt(-count) 0
  }
# }}}

  set cur_value [lvars . $key]
  set count     [lvars . $key,count]
  
  set exefile ".onoff_$name.gtcl"

      if {$cur_value eq "1"} {
        if {$opt(-count) eq "1"} {
          puts $fout "<a href=$exefile class=\"w3-btn w3-green\" type=text/gtcl><b>$name ($count)</b></a>"
        } else {
          puts $fout "<a href=$exefile class=\"w3-btn w3-green\" type=text/gtcl><b>$name</b></a>"
        }
      } else {
        if {$opt(-count) eq "1"} {
          puts $fout "<a href=$exefile class=\"w3-btn w3-light-grey\" type=text/gtcl><b>$name ($count)</b></a>"
        } else {
          puts $fout "<a href=$exefile class=\"w3-btn w3-light-grey\" type=text/gtcl><b>$name</b></a>"
        }
      }

  if ![file exist $exefile] {
    set kout [open "$exefile" w]
      puts $kout "set pagepath \[file dirname \[info script]]"
      puts $kout "cd \$pagepath"
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "set cur_value \[lvars . $key]"
      if {$opt(-value) eq "1"} {
        puts $kout "lsetvar . $key,value \"$val(-value)\""
      }
      puts $kout "if {\$cur_value eq \"1\"} {"
      puts $kout "  lsetvar . $key \"0\""
      puts $kout "} else {"
      puts $kout "  lsetvar . $key \"1\""
      puts $kout "}"
      puts $kout "godel_draw"
      puts $kout "catch {exec xdotool search --name \"Mozilla\" key ctrl+r}"
    close $kout
  }
  
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

  puts $fout "<a href=.note_onoff.gtcl class=\"w3-btn w3-blue\" type=text/gtcl><b>note on/off</b></a>"
}
# }}}
# ltbl_hit
# {{{
proc ltbl_hit {dispcol} {
  upvar celltxt celltxt
  upvar row row
  set code $row

  set hit  [lvars $code hit]
  set tick [lvars $code tick]
  if {$tick eq "NA"} {
    set tick [lvars $code tick]
  }
  set disp [lvars $code $dispcol]

  if {$hit eq "NA"} {
    set hit 0
  }

  if {$hit} {
    if {$tick eq "1"} {
      set celltxt "<td bgcolor=lightgreen style=\"white-space:pre\">$disp</td>"
    } else {
      set celltxt "<td style=\"white-space:pre\">$disp</td>"
    }
  } else {
    set celltxt "<td bgcolor=lightgray style=\"white-space:pre\">$disp</td>"
  }
}
# }}}
# ltbl_iname
# {{{
proc ltbl_iname {dispcol} {
  upvar celltxt celltxt
  upvar row     row
  upvar textalign textalign

  #set iname [lvars $row g:iname]
  set tick [lvars $row tick]
  if {$tick eq "NA"} {
    set tick [lvars $row tick]
  }
  set disp [lvars $row $dispcol]

  if {$tick eq "1"} {
    set celltxt "<td colname=\"proc:ltbl_iname $dispcol\" $textalign bgcolor=lightyellow><a href=\"$row/.index.htm\" style=\"white-space:pre\">$disp</a></td>"
  } else {
    set celltxt "<td colname=\"proc:ltbl_iname $dispcol\" $textalign style=\"white-space:pre\"><a href=\"$row/.index.htm\">$disp</a></td>"
  }
}
# }}}
# ltbl_lnfile
# {{{
proc ltbl_lnfile {target lnas} {
  upvar celltxt celltxt
  upvar row     row

  set fpath $row/$target
  
  if [file exist $fpath] {
    set celltxt "<td><a href=\"$fpath\" type=text/txt>$lnas</a></td>"
  } else {
    set celltxt "<td bgcolor=lightgrey>$lnas</td>"
  }
}
# }}}
# ltbl_img
# {{{
proc ltbl_img {target} {
  upvar celltxt celltxt
  upvar row     row

  set fpath $row/$target
  
  if [file exist $fpath] {
    set celltxt "<td><img src=\"$fpath\" width=200px height=100px></img></td>"
  } else {
    set celltxt "<td</td>"
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

  if {$opt(-title)} {
    puts $fout "<h2 class=\"w3-margin-bottom\">$title</h2>"
  }
  if {$opt(-bg)} {
    puts $fout "<div class=\"w3-panel w3-sand w3-$bgcolor w3-margin-top\">"
  } else {
    puts $fout "<div class=\"w3-panel w3-white w3-margin-top\">"
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
    set celltxt "<td colname=\"proc:bton_move $pathto\"><a href=$row/.move.gtcl class=\"w3-btn w3-blue w3-round\" type=text/gtcl>M</a></td>"
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

  set celltxt "<td style=\"cursor:pointer;\" gname=\"$row\" bgcolor=lightblue colname=\"DEL\">D</td>"

}
# }}}
# bton_fdelete
# {{{
proc bton_fdelete {{name ""}} {
  upvar celltxt celltxt
  upvar row     row

  set celltxt "<td style=\"cursor:pointer;\" gname=\"$row\" bgcolor=lightblue colname=\"fdel\">FD</td>"

}
# }}}
# abton_tick
# {{{
proc abton_tick {{name ""}} {
  upvar celltxt celltxt
  upvar row     row
  upvar atvar   atvar

  set tick [get_atvar $row,tick]

  if {$tick eq "1"} {
    set celltxt "<td style=\"cursor:pointer;\" gclass=\"onoff\" gname=\"$row\" colname=\"tick\" bgcolor=\"lightgreen\" onoff=\"1\">1</td>"
  } else {
    set celltxt "<td style=\"cursor:pointer;\" gclass=\"onoff\" gname=\"$row\" colname=\"tick\" onoff=\"0\"></td>"
  }
}
# }}}
# bton_tick
# {{{
proc bton_tick {{save ""}} {
  upvar celltxt celltxt
  upvar row     row

  set tick [lvars $row tick]

  if {$tick eq "1"} {
    set celltxt "<td gclass=\"onoff\" gname=\"$row\" colname=\"tick\" bgcolor=\"lightgreen\" onoff=\"1\">1</td>"
# To enable function of "official release"
    if {$save eq "-save"} {
      lsetvar . tick $row
    }
  } else {
    set celltxt "<td gclass=\"onoff\" gname=\"$row\" colname=\"tick\" onoff=\"0\"></td>"
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
  # -cmd
# {{{
  set opt(-cmd) 0
  set idx [lsearch $args {-cmd}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-cmd) 1
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
  # -id 
# {{{
  set opt(-id) 0
  set idx [lsearch $args {-id}]
  if {$idx != "-1"} {
    set id [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-id) 1
  } else {
    set id NA
  }
# }}}
  set exefile [lindex $args 0]
  if {$opt(-name)} {
  } else {
    set name $exefile
  }

  if [file exist $exefile] {
    set exename [file tail $exefile]
    if {$opt(-cmd)} {
      puts $fout "<a id=\"$id\" href=.$exename.gtcl class=\"w3-btn w3-blue\" type=text/gtcl><b>$name</b><span style=float:right><a class=\"w3-button w3-blue\" href=$exefile type=text/txt>&#9701</a></span></a>"
    } else {
      puts $fout "<a id=\"$id\" href=.$exename.gtcl class=\"w3-btn w3-blue\" type=text/gtcl><b>$name</b></a>"
    }
    set kout [open ".$exename.gtcl" w]
      puts $kout "set pagepath \[file dirname \[info script]]"
      puts $kout "cd \$pagepath"
      if {$opt(-nowin)} {
        puts $kout "exec ./$exefile"
      } else {
        puts $kout "exec xterm -geometry 150x30+5+800 -e \"./$exefile\""
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
  # src
# {{{
  set opt(src) 0
  set idx [lsearch $args {src}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(src) 1
  }
# }}}
  # -path
# {{{
  set opt(-path) 0
  set idx [lsearch $args {-path}]
  if {$idx != "-1"} {
    set srcpath [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-path) 1
  } else {
    set srcpath NA
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

  if {$opt(-path) eq "1"}  {
  } else {
    set srcpath $dyvars(srcpath)
  }

  if {$opt(src)} {
    puts $srcpath
    return
  }

  set num 1
  foreach f $files {

# local not exist
    if ![file exist $f] {
      if {$opt(co)} {
        puts "co not exist file... $f"
        exec cp $srcpath/$f $f
      } else {
        puts "not exist... $f"
      }
      continue
    }
# remote not exist
    if ![file exist $srcpath/$f] {
      if {$opt(ci)} {
        puts "ci not exist file... $srcpath/$f"
        if [file exist [file dirname $srcpath/$f]] {
          exec cp $f $srcpath/$f
        } else {
          file mkdir [file dirname $srcpath/$f]
          exec cp $f $srcpath/$f
        }
      } else {
        puts "not exist... $srcpath/$f"
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
            file copy -force $f $srcpath/$f
          } elseif {$target_num eq $num} {
            puts [format "%-2d %s %s ......ci" $num $status $f]
            file copy -force $f $srcpath/$f
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
          file copy -force $f $srcpath/$f
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
    file copy -force $f $srcpath/$f
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
    file copy -force $srcpath/$f $f
  }
}
# }}}


# getcol
# {{{
proc getcol {args} {
#  # -c (key)
## {{{
#  set opt(-c) 0
#  set idx [lsearch $args {-c}]
#  if {$idx != "-1"} {
#    set col  [lindex $args [expr $idx + 1]]
#    set args [lreplace $args $idx [expr $idx + 1]]
#    set opt(-c) 1
#  }
## }}}

  set col   [lindex $args 0]
  set fname [lindex $args 1]

  set lines [read_as_list $fname]

  foreach line $lines {
    puts [lindex $line $col]
  }
}
# }}}
# ghtm_set_value
# {{{
proc ghtm_set_value {key value args} {
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
  if {$name eq "NA"} {
    set name $value
  }
  set cur_value [lvars . $key]
  if {$cur_value eq $value} {
    puts $fout "<a class=\"w3-button w3-round w3-lime\" onclick=\"set_value('$key','$value')\">${name}</a>"
  } else {
    puts $fout "<a class=\"w3-button w3-round w3-light-gray\" onclick=\"set_value('$key','$value')\">${name}</a>"
  }
}
# }}}
# ghtm_onoff
# {{{
proc ghtm_onoff {key args} {
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
  set cur_value [lvars . $key]
  if {$cur_value eq "1"} {
    puts $fout "<a class=\"w3-button w3-round w3-lime\" onclick=\"onoff('$key', '0')\">${name}</a>"
  } else {
    puts $fout "<a class=\"w3-button w3-round w3-light-gray\" onclick=\"onoff('$key', '1')\">${name}</a>"
  }
}
# }}}
# ghtm_open_folder
# {{{
proc ghtm_open_folder {dirpath} {
  upvar fout fout
  puts $fout "<a class=\"w3-button w3-round w3-pale-blue\" onclick=\"open_folder('$dirpath')\">folder</a>"
}
# }}}
# at_allrows
# {{{
proc at_allrows {{pattern NA}} {
  upvar atvar atvar
  if {$pattern eq "NA"} {
    set names [array names atvar]
  } else {
    set names [array names atvar $pattern]
  }
  if {$names eq ""} {
    return ""
  }
    foreach n $names {
      set cols [split $n ,]
      lappend ns [join [lrange $cols 0 end-1] ","]
    }
  return [lsort -unique $ns]
}
# }}}
# at_keyword_button
# {{{
proc at_keyword_button {args} {
  upvar fout fout
  upvar atvar atvar

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
  # -bgcolor
# {{{
  set opt(-bgcolor) 0
  set idx [lsearch $args {-bgcolor}]
  if {$idx != "-1"} {
    set val(-bgcolor) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-bgcolor) 1
  } else {
    set val(-bgcolor) pale-blue
  }
# }}}
  # -key
# {{{
  set opt(-key) 0
  set idx [lsearch $args {-key}]
  if {$idx != "-1"} {
    set val(-key) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-key) 1
  } else {
    set val(-key) nan
  }
# }}}

  set tablename [lindex $args 0]
  set column    [lindex $args 1]
  set keyword   [lindex $args 2]

  set count 0
  if {$opt(-key)} {
    set rows [at_allrows]

    foreach row $rows {
      set value $atvar($row,$val(-key))
      if [regexp -nocase $keyword $value] {
        incr count
      }
    }
    #set total "\($count\)"
    set total " $count"
  } else {
    set dirs [glob -nocomplain -type d *]
    set matches [lsearch -all -inline -regexp $dirs $keyword]
    set count [llength $matches]
    set total " $count"
  }

  if {$opt(-name)} {
    puts $fout "<button class=\"w3-button w3-round w3-$val(-bgcolor)\" onclick=filter_table_keyword(\"$tablename\",\"$column\",\"$keyword\")>${name}$total</button>"
  } else {
    if {$opt(-key)} {
      puts $fout "<button class=\"w3-button w3-round w3-$val(-bgcolor)\" onclick=filter_table_keyword(\"$tablename\",\"$column\",\"$keyword\")>${keyword}$total</button>"
    } else {
      puts $fout "<button class=\"w3-button w3-round w3-$val(-bgcolor)\" onclick=filter_table_keyword(\"$tablename\",\"$column\",\"$keyword\")>${keyword}</button>"
    }
  }
}
# }}}
# ghtm_keyword_button
# {{{
proc ghtm_keyword_button {args} {
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
  # -bgcolor
# {{{
  set opt(-bgcolor) 0
  set idx [lsearch $args {-bgcolor}]
  if {$idx != "-1"} {
    set val(-bgcolor) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-bgcolor) 1
  } else {
    set val(-bgcolor) pale-blue
  }
# }}}
  # -key
# {{{
  set opt(-key) 0
  set idx [lsearch $args {-key}]
  if {$idx != "-1"} {
    set val(-key) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-key) 1
  } else {
    set val(-key) nan
  }
# }}}

  set tablename [lindex $args 0]
  set column    [lindex $args 1]
  set keyword   [lindex $args 2]

  set count 0
  if {$opt(-key)} {
    set dirs [glob -nocomplain -type d *]

    foreach dir $dirs {
      set value [lvars $dir $val(-key)]
      if [regexp -nocase $keyword $value] {
        incr count
      }
    }
    #set total "\($count\)"
    set total " $count"
  } else {
    set dirs [glob -nocomplain -type d *]
    set matches [lsearch -all -inline -regexp $dirs $keyword]
    set count [llength $matches]
    set total " $count"
  }

  if {$opt(-name)} {
    puts $fout "<button class=\"w3-button w3-round w3-$val(-bgcolor)\" onclick=filter_table_keyword(\"$tablename\",\"$column\",\"$keyword\")>${name}$total</button>"
  } else {
    if {$opt(-key)} {
      puts $fout "<button class=\"w3-button w3-round w3-$val(-bgcolor)\" onclick=filter_table_keyword(\"$tablename\",\"$column\",\"$keyword\")>${keyword}$total</button>"
    } else {
      puts $fout "<button class=\"w3-button w3-round w3-$val(-bgcolor)\" onclick=filter_table_keyword(\"$tablename\",\"$column\",\"$keyword\")>${keyword}</button>"
    }
  }
}
# }}}
# ghtm_reset
# {{{
proc ghtm_reset {} {
  upvar fout fout

  puts $fout "<button class=\"w3-button w3-round w3-pale-blue\" onclick=filter_table_reset()>reset</button>"
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
    if {[file type $full] eq "link"} {
      set linktarget [file readlink $full]
    } else {
      set linktarget $full
    }
    if [regexp {\.htm} $full] {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$linktarget\">$fname</a><br></div>"]
    } elseif [regexp {\.mp4|\.mkv|\.webm|\.rmvb} $full] {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$linktarget\" type=text/mp4>$fname</a><br></div>"]
    } elseif [regexp {\.mp3} $full] {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$linktarget\" type=text/mp3>$fname</a><br></div>"]
    } elseif [regexp {\.pdf} $full] {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$linktarget\" type=text/pdf>$fname</a><br></div>"]
    } elseif [regexp {\.azw3|\.mobi|\.epub} $full] {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$linktarget\">$fname</a><br></div>"]
    } elseif {[regexp -nocase {\.jpg|\.png|\.gif} $full]}  {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$linktarget\" type=text/jpg>$fname</a><br></div>"]
    } else {
      puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-20s %-10s %s</pre>" $timestamp $fsize "<a class=keywords href=\"$linktarget\" type=text/txt>$fname</a><br></div>"]
    }
    incr count
  }
  
}
# }}}
# ghtm_list_files
# {{{
proc ghtm_list_files {pattern {description ""}} {
  upvar env env
  upvar fout fout

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
  # -p1
# {{{
  set opt(-p1) 0
  set idx [lsearch $args {-p1}]
  if {$idx != "-1"} {
    set saveid [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-p1) 1
  }
# }}}
  # -win
# {{{
  set opt(-win) 0
  set idx [lsearch $args {-win}]
  if {$idx != "-1"} {
    set saveid [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-win) 1
  }
# }}}
  # -save
# {{{
  set opt(-save) 0
  set idx [lsearch $args {-save}]
  if {$idx != "-1"} {
    set saveid [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx $idx]
    set opt(-save) 1
  }
# }}}
  # -notime
# {{{
  set opt(-notime) 0
  set idx [lsearch $args {-notime}]
  if {$idx != "-1"} {
    set saveid [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx $idx]
    set opt(-notime) 1
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
  # -new
# {{{
  set opt(-new) 0
  set idx [lsearch $args {-new}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-new) 1
  }
# }}}

  if [file exist .godel/dyvars.tcl] {
    source .godel/dyvars.tcl
  } else {
    set dyvars(last_updated) Now
  }


  set cwd [pwd]
 
  puts $fout {
  
  <style>
  .content {
    padding: 19px;
  }
  
  .sticky {
    position: fixed;
    top: 0;
    width: 100%;
  }
  .sticky + .content {
    padding-top: 60px;
  }
  </style>
  }
  
  puts $fout {
    <div id="navbar" class="w3-bar w3-indigo" style="margin:0px">
    <a id="idedit" href=".godel/ghtm.tcl"  type=text/txt  class="w3-bar-item w3-button">Edit</a>
    <a id="idvalue" href=".godel/vars.tcl" type=text/txt  class="w3-bar-item w3-button">Value</a>
    <a id="idparent" href="../.index.htm"                 class="w3-bar-item w3-button">Parent</a>
    <a id="iddraw" href=".godel/draw.gtcl" type=text/gtcl class="w3-bar-item w3-button">Draw</a>
    <a style="display:none" id="idexec" href=".godel/exec.gtcl" type=text/gtcl class="w3-bar-item w3-button">Exec</a>
  }
  if {$opt(-filter)} {
    puts $fout "<input style=\"margin: 5px 0px\" type=text id=filter_table_input onkeyup=filter_table(\"tbl\",$tblcol,event) placeholder=\"Search...\">"
  }


  if {$opt(-notime) eq "1"} {
  } else {
    set timestamp [clock format [clock seconds] -format {%Y-%m-%d_%H:%M}]
    puts $fout "
      <a href=.index.htm type=text/txt class=\"w3-bar-item w3-button w3-right\">$timestamp</a>
    "
  }
  puts $fout "<button onclick=\"open_terminal()\" class=\"w3-bar-item w3-button w3-darkblue w3-right\">Open</button>"
  puts $fout "<button onclick=\"open_folder()\"   class=\"w3-bar-item w3-button w3-darkblue w3-right\">Win</button>"
  if {$opt(-new) eq "1"} {
    puts $fout "<button onclick=\"newgpage()\"      class=\"w3-bar-item w3-button w3-darkblue w3-right\">New</button>"
  }

  if {$opt(-save)} {
    #puts $fout "<button id=\"save\" class=\"w3-bar-item w3-button w3-blue-gray\" style=\"margin: 0px 0px\">Save</button>"
    if [info exist env(GODEL_SAVEnDRAW)] {
      puts $fout "<button id=\"idbutton\" onclick=\"g_save()\" class=\"w3-bar-item w3-button w3-blue-gray\">Save</button>"
    } else {
      puts $fout "<button id=\"idbutton\" onclick=\"g_save_nodraw()\" class=\"w3-bar-item w3-button w3-blue-gray\">Save</button>"
    }
  }
    puts $fout "<button class=\"w3-bar-item w3-button\" onclick=\"toolarea()\" style=\"margin: 0px 0px\">Tools</button>"
    puts $fout "<button class=\"w3-bar-item w3-button\" onclick=\"topFunction()\" style=\"margin: 0px 0px\">Top</button>"
    #puts $fout {<a href=".godel/tools.gtcl"  type=text/gtcl class="w3-bar-item w3-button w3-right">Tools</a>}
    if {$opt(-js) eq "1"} {
      puts $fout {<a href="local.js"  type=text/txt class="w3-bar-item w3-button w3-right">JS</a>}
    }
  puts $fout "</div>"

  puts $fout {
  <script>
  window.onscroll = function() {myFunction()};
  
  var navbar = document.getElementById("navbar");
  var sticky = navbar.offsetTop;
  
  function myFunction() {
    if (window.pageYOffset >= sticky) {
      navbar.classList.add("sticky")
      nav2.classList.add("content")
    } else {
      navbar.classList.remove("sticky");
      nav2.classList.remove("content");
    }
  }
  </script>
  
  <div id=nav2 class=> </div>
  
  }


  if {$opt(-p1)} {
    puts $fout "<style>"
    puts $fout "p {"
    puts $fout "  margin: 30px 0px 5px 0px;"
    puts $fout "  font-size     : 20px;"
    puts $fout "}"
    puts $fout "</style>"
  }
  #if {$env(GODEL_WSL)} {

  #  set kout [open .godel/win.gtcl w]

  #  puts $kout "cd [pwd]"
  #  puts $kout "catch {exec /mnt/c/Windows/explorer.exe .}"
  #  close $kout

  #}

  # York: not sure if I want this feature
  #if [file exist .godel/.qn.md] {
  #  gmd -f .godel/.qn.md
  ##} else {
  #  #set kout [open ".godel/.qn.md" w]
  #  #close $kout
  #}
  #if {[lvars . tools_display] eq "1"} {
  #  if [file exist .tools.tcl] {
  #    source .tools.tcl
  #  }
  #}
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
    set ilist [read_as_list $listfile]
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
    set ilist [read_as_list $listfile]
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
# asetvar
# {{{
proc asetvar {key value {atfname at.tcl}} {
  if [file exist "$atfname"] {
    source $atfname
    set atvar($key) $value
    godel_array_save atvar $atfname
  } else {
    puts "Error: not exist... $atfname"
  }
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
# ldyvars
# {{{
proc ldyvars {args} {

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
  if ![file exist $gpage/.godel/dyvars.tcl] {
    #puts "Error: not exist... $gpage/.godel/vars.tcl"
    return
  }
  source $gpage/.godel/dyvars.tcl

  set vlist ""
  if {$vname == ""} {
    parray dyvars
  } else {
    if {$opt(-k)} {
      foreach name [lsort [array names dyvars]] {
        if [setop_and_hit $vname $name] {
          puts [format "%-20s = %s" $name $dyvars($name)]
          lappend klist [list $name $dyvars($name)]
          set vlist [concat $vlist $dyvars($name)]
        }
      }
    } else {
      if [info exist dyvars($vname)] {

        if {$opt(-pvar)} {
          set txt ""
          foreach path $dyvars($vname) {
            set fname [file tail $path]
            append txt "$fname\n"
          }
          return $txt
        } else {
          return $dyvars($vname)
        }
      } else {
        return NA
      }
    }
  }
}
# }}}
# avar
# {{{
proc avar {key {ifile at.tcl}} {
  source $ifile

  if [info exist atvar($key)] {
    return $atvar($key)
  } else {
    return NA
  }

}
# }}}
# lvars
# {{{
proc lvars {args} {
  set gpage [lindex $args 0]
  set vname [lindex $args 1]

    if {$gpage == ""} {
      set gpage "."
    }
    if ![file exist $gpage/.godel/vars.tcl] {
      return
    }
    source $gpage/.godel/vars.tcl

    set vlist ""
    if {$vname == ""} {
      parray vars
    } else {
      if [info exist vars($vname)] {
        return $vars($vname)
      } else {
        return NA
      }
    }
}
# }}}
# local_table
# {{{
proc local_table {tableid args} {
  global fout
  upvar vars vars
  upvar env env

  # -pattern
# {{{
  set opt(-pattern) 0
  set idx [lsearch $args {-pattern}]
  if {$idx != "-1"} {
    set pattern [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-pattern) 1
  } else {
    set pattern *
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
#  set opt(-row_style_proc) 0
#  set idx [lsearch $args {-row_style_proc}]
#  if {$idx != "-1"} {
#    set args [lreplace $args $idx $idx]
#    set opt(-row_style_proc) 1
#  }
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
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-sortby) 1
  }
# }}}
  # -sortopt (sort options"
# {{{
  set opt(-sortopt) 0
  set idx [lsearch $args {-sortopt}]
  if {$idx != "-1"} {
    set val(-sortopt) [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-sortopt) 1
  } else {
    set val(-sortopt) "-ascii"
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
  # -dataTables
# {{{
  set opt(-dataTables) 0
  set idx [lsearch $args {-dataTables}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    #upvar dataTables dataTables
    set opt(-dataTables) 1
  }
# }}}

  # create rows
  # {{{
  set rows ""
  if ![info exist ::ltblrows] {
    if {$opt(-f)} {
      if [file exist $listfile] {
        #set rows [read_as_list $listfile]
        set kin [open $listfile r]

        while {[gets $kin line] >= 0} {
          if {[regexp {^\s*#} $line]} {
          } elseif {[regexp {^\s*$} $line]} {
          } else {
            regsub {^\s*} $line {} line
            lappend rows $line
          }
        }
        close $kin
      } else {
        #puts "Errors: Not exist... $listfile"
        if {$opt(-revert)} {
          set flist [lsort -decreasing [glob -nocomplain $pattern/.godel]]
        } else {
          set flist [lsort [glob -nocomplain $pattern/.godel]]
        }
        foreach f $flist {
          lappend rows [file dirname $f]
        }
      }
    } else {
      if {$opt(-revert)} {
        set flist [lsort -decreasing [glob -nocomplain $pattern/.godel]]
      } else {
        set flist [lsort [glob -nocomplain $pattern/.godel]]
      }
      foreach f $flist {
        lappend rows [file dirname $f]
      }
    }
  } else {
    set rows $::ltblrows
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
  puts $fout "<table class=$css_class id=$tableid tbltype=gtable>"
# Table Headers
# {{{
  puts $fout "<thead>"
  puts $fout "<tr>"
  if {$opt(-serial)} {
    puts $fout "<th colname=\"num\">Num</th>"
  }
  foreach col $columns {
    set colname ""
    if [regexp {;} $col] {
      set cs [split $col ";"]
      set colname [lindex $cs 1]
      set page_key [lindex $cs 0]
      regsub {edtable:} $page_key {} page_key

      if {$colname == ""} {
        puts $fout "<th></th>"
      } else {
        puts $fout "<th colname=\"$page_key\">$colname</th>"
      }
    } else {
      set colname $col
      puts $fout "<th colname=\"$colname\">$colname</th>"
    }
  }
  puts $fout "</tr>"
  puts $fout "</thead>"
# }}}

  # Sort by...
# {{{
  if {$opt(-sortby)} {
    ## Create row_items for sorting
    set row_items {}
    foreach row $rows {
      set sdata [lvars $row $sortby]
      regsub -all {,} $sdata {} sdata
      if {$sdata eq "NA" || $sdata eq ""} {
        if [regexp {\-ascii} $val(-sortopt)] {
          set sdata "~"
        } else {
          set sdata 0
        }
      }
      lappend row_items [list $row $sdata]
    }

    ## Sorting...
    set row_items [lsort -index 1 {*}$val(-sortopt) $row_items]

    # Re-create rows based on sorted row_items
    set rows {}
    foreach i $row_items {
      lappend rows [lindex $i 0]
    }
  }
# }}}

  if {$opt(-exclude)} {
    set rows [setop_restrict $rows $exdirs]
  }

  set serial 1
#--------------------
# For each table row
#--------------------
  lsetvar . $tableid,size [llength $rows]
  foreach row $rows {
    # York: consider to remove row style function
    #set row_style {}
    #if {$opt(-row_style_proc)} {
    #  row_style_proc
    #}
    #puts $fout "<tr style=\"$row_style\">"
    puts $fout "<tr>"

    if {$opt(-serial)} {
      puts $fout "<td colname=\"num\"><a href=\"$row/.index.htm\">$serial</a></td>"
      #puts $fout "<td>$serial</td>"
    }
    #----------------------
    # For each table column
    #----------------------
    foreach col $columns {
      set cs [split $col ";"]

      set col [lindex $cs 0]
      regsub {\s+$} $col {} col

      set align [lindex $cs 2]
      regsub -all {\s} $align {} align
      if {$align eq "right"} {
        set textalign "style=text-align:right"
      } else {
        set textalign ""
      }

      set celltxt {}

      # Get column data
      # proc:
      if [regexp {proc:} $col] {
        regsub {proc:} $col {} col
        set procname $col
        eval $procname
      # md:
      } elseif [regexp {md:} $col] {
        regsub {md:} $col {} col
        set fname $row/$col.md
        if [file exist $fname] {
          set aftermd [gmd_file $fname]
          #set symbol &#9808;
          set symbol &#9701;
          append celltxt "<td><span style=float:right><a style=text-decoration:none href=\"$row/$col.md\" type=text/txt>$symbol</a></span>$aftermd</td>"
        } else {
          if [file exist $row] {
            set kout [open $fname w]
            puts $kout " "
            close $kout
            append celltxt "<td> </td>"
          }
        }
      # edtable:
      } elseif [regexp {edtable[2-9]*:} $col] {
        regsub {edtable[2-9]*:} $col {} page_key
        set col_data [lvars $row $page_key]
        if {$col_data eq "NA"} {
          set col_data ""
        }
        if [regexp {edtable2} $col] {
          append celltxt "<td gtype=\"innerHTML\" gname=\"$row\" colname=\"$page_key\" contenteditable=\"true\" style=\"white-space:pre\">$col_data</td>"
        } else {
          append celltxt "<td gname=\"$row\" colname=\"$page_key\" contenteditable=\"true\" style=\"white-space:pre\">$col_data</td>"
        }
      # ed:
      } elseif [regexp {ed:} $col] {
        regsub {ed:} $col {} col
        set col_data [lvars $row $col]
        if {$col_data eq "NA"} {
          set col_data ""
        }
        append celltxt "<td gname=\"$row\" colname=\"$col\" contenteditable=\"true\"><pre style=\"white-space:pre\">$col_data</pre></td>"
      } else {
        set dirname [file dirname $col]
        set page_path $row
        set page_key  $col
        #puts "$page_path $page_key"
        set col_data [lvars $page_path $page_key]
        if {$col_data eq "NA"} {
          set col_data ""
        }

        if {$col == "g:pagename"} {
          set col_data "<a href=\"$row/.index.htm\">$col_data</a>"
        }
        append celltxt "<td $textalign colname=\"$page_key\">$col_data</td>"
      }
      puts $fout $celltxt
    }

    puts $fout "</tr>"
    incr serial
  }
  puts $fout "</table>"
  if {$opt(-dataTables) eq "1"} {
            if {$env(GODEL_EMB_CSS) eq "1"} {
              puts $fout "<script src=.godel/js/jquery.dataTables.min.js></script>"
            } else {
              puts $fout "<script src=$env(GODEL_ROOT)/scripts/js/jquery.dataTables.min.js></script>"
            }
          puts $fout "<script>"
          puts $fout "    \$(document).ready(function() {"
          puts $fout "    \$('#$tableid').DataTable({"
          puts $fout "       \"paging\": false,"
          puts $fout "       \"info\": false,"
          puts $fout "       \"order\": \[\],"
          puts $fout "    });"
          puts $fout "} );"
          puts $fout "</script>"
  }

}
# }}}
# lremove
# {{{
proc lremove {tlist item} {
  set a [lsearch -all -inline -not -exact $tlist $item]
  return $a
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

  #puts $fout "<div class=\"gnotes w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"
  puts $fout "<div class=\"w3-panel w3-white w3-margin-top\">"
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
      puts $fout "<a class=hbox2 href=\"$page/.index.htm\">$disp</a><br>"
    } else {
      # Single line
      puts $fout "<a class=hbox2 href=\"$page/.index.htm\">$disp</a>"
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
      puts $kout "<a href=\"$fname2.md\" type=text/txt>edit</a>"
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

  puts $fout "<table class=$css_class>"
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

# @! Link to gpage as badge
# {{{
  set matches [regexp -all -inline {@!(\S+)} $aftermd]
  foreach {whole iname} $matches {
# Tidy iname likes `richard_dawkins</p>'
    regsub {<\/p>} $iname {} iname

    set pagename [lvars $iname g:pagename]
    puts "lvars $iname g:pagename"
    set atxt "<a class=hbox2 href=\"$iname/.index.htm\">$pagename</a>"
    regsub -all "@!$iname" $aftermd $atxt aftermd
  }
# }}}

# @img() img
# {{{
  set matches [regexp -all -inline {@img\((\S+)\)} $aftermd]
  foreach {whole iname} $matches {
# Tidy iname likes `richard_dawkins</p>'
    regsub {<\/p>} $iname {} iname

#    set pagename [gvars $iname g:pagename]
    set atxt "<a href=\"$iname\"><img src=$iname style=\"float:right;width:30%\"></a>"
    #regsub -all {@img\(pmos} $aftermd $atxt aftermd
    regsub -all "@img\\($iname\\)" $aftermd $atxt aftermd
  }
# }}}

  #puts $fout "<div class=\"w3-panel\">"
  puts $fout $aftermd
  #puts $fout "</div>"
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
  if [file exist $env(GOK_HOME)/goklist.tcl] {
    source       $env(GOK_HOME)/goklist.tcl
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
# ghtm_toc
# {{{
proc ghtm_toc {} {
  upvar fout fout
  upvar toc_enable toc_enable
  set toc_enable 1
  puts $fout "=toc_anchor="
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
  } elseif {$num eq ""} {
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
  #set o {}
  #foreach i $a {
  #  if {[lsearch $b $i] >= 0} {lappend o $i}
  #}
  #return $o
  return [lsort -unique [list {*}$a {*}$b]]
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
# godel_draw
# {{{
proc godel_draw {{target_path NA}} {
  upvar env env
  set ::toc_id_count 1
  set toc_enable     0

  if {$target_path == "NA" || $target_path == ""} {
  } else {
    set orgpath [pwd]
    cd $target_path
  }

  set gtype [lvars . gtype]
  # If .freeze exist, do nothing. Page keeps the same.
# {{{
  if [file exist .freeze] {
    puts "INFO: No change to .index.htm. This page is frozen."
    return
  }
# }}}

  package require gmarkdown
  upvar vars vars
  global env
  upvar argv argv

  file mkdir .godel
  # vars.tcl
# {{{
  if ![file exist .godel/vars.tcl] {
    set kout [open .godel/vars.tcl w]
    close $kout
    set vars(g:keywords) ""
    set vars(g:pagename) [file tail [pwd]]
    set vars(g:iname)    [file tail [pwd]]
    godel_array_save vars   .godel/vars.tcl
  }
  source .godel/vars.tcl
# }}}

  if ![file exist .godel/dyvars.tcl] {
    set kout [open .godel/dyvars.tcl w]
    close $kout
  }
  source .godel/dyvars.tcl
  set dyvars(last_updated) [clock format [clock seconds] -format {%Y-%m-%d_%H%M}]
  godel_array_save dyvars .godel/dyvars.tcl


# create draw.gtcl
# {{{
  if ![file exist .godel/draw.gtcl] {
    set kout [open .godel/draw.gtcl w]
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "set pagepath \[file dirname \[file dirname \[info script\]\]\]"
      puts $kout "cd \$pagepath"
      puts $kout ""
      puts $kout "catch {exec xdotool getwindowfocus getwindowname} pattern"
      puts $kout ""
      puts $kout "gtcl_commit"
      puts $kout "godel_draw"
      puts $kout "catch {exec xdotool search --name \"\$pattern\" key ctrl+r}"

    close $kout
  }
# }}}
# create exec.gtcl
# {{{
  if ![file exist .godel/exec.gtcl] {
    set kout [open .godel/exec.gtcl w]
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "set pagepath \[file dirname \[file dirname \[info script\]\]\]"
      puts $kout "cd \$pagepath"
      puts $kout ""
      puts $kout "if \[file exist \"\$env(GODEL_DOWNLOAD)/gtcl.tcl\"] {"
      puts $kout "  source  \$env(GODEL_DOWNLOAD)/gtcl.tcl"
      puts $kout "  exec rm \$env(GODEL_DOWNLOAD)/gtcl.tcl"
      puts $kout "} else {"
      puts $kout "  source local.tcl"
      puts $kout "}"
      puts $kout ""
    close $kout
  }
# }}}

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


  if {$env(GODEL_ALONE)} {
# Standalone w3.css
      file mkdir .godel/js
      file copy -force $env(GODEL_ROOT)/etc/css/w3.css                      .godel/
      file copy -force $env(GODEL_ROOT)/scripts/js/godel.js                 .godel/js
      if ![file exist .godel/js/jquery-3.3.1.min.js] {
        #file copy -force $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js      .godel/js
        exec cp $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js      .godel/js
      }
      if ![file exist .godel/js/jquery.dataTables.min.js] {
        #file copy -force $env(GODEL_ROOT)/scripts/js/jquery.dataTables.min.js .godel/js
        exec cp $env(GODEL_ROOT)/scripts/js/jquery.dataTables.min.js .godel/js
      }
      puts $fout "<link rel=\"stylesheet\" type=\"text/css\" href=\".godel/w3.css\">"
      if {$gtype eq "raw"} {
      } else {
        puts $fout "<script src=.godel/js/jquery-3.3.1.min.js></script>"
      }
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
      file mkdir .godel/js
      exec cp $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js      .godel/js
      exec cp $env(GODEL_ROOT)/scripts/js/jquery.dataTables.min.js .godel/js
      exec cp $env(GODEL_ROOT)/scripts/js/godel.js                 .godel/js
      puts $fout "<script src=.godel/js/jquery-3.3.1.min.js></script>"
    } else {
      puts $fout "<link rel=\"stylesheet\" type=\"text/css\" href=\"$env(GODEL_ROOT)/etc/css/w3.css\">"
      if {$gtype eq "raw"} {
      } else {
        puts $fout "<script src=$env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js></script>"
      }
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
    set kout [open .godel/ghtm.tcl w]
      puts $kout "ghtm_top_bar -save"
      puts $kout "gnotes \""
      puts $kout "# \$vars(g:pagename)"
      puts $kout ""
      puts $kout ""
      puts $kout "\""
      puts $kout "#lappend cols \"proc:ltbl_iname g:iname;Name\""
      puts $kout "#lappend cols \"edtable:bday;bday\""
      puts $kout "#lappend cols \"edtable:g:keywords;Keywords\""
      puts $kout "#local_table tbl -c \$cols -serial -dataTables"
      puts $kout "ghtm_ls *"
    close $kout
    source .godel/ghtm.tcl
  }

  if {$env(GODEL_ALONE)} {
    if {$gtype eq "raw"} {
    } else {
      puts $fout "<script src=.godel/js/jquery.dataTables.min.js></script>"
      puts $fout "<script src=.godel/js/godel.js></script>"
    }
  } else {
    if {$env(GODEL_EMB_CSS)} {
      puts $fout "<script src=.godel/js/godel.js></script>"
      if {[info exist dataTables]} {
        puts $fout "<script src=.godel/js/jquery.dataTables.min.js></script>"
        puts $fout "<script>"
        puts $fout "    \$(document).ready(function() {"
        puts $fout "    \$('#tbl').DataTable({"
        puts $fout "       \"paging\": false,"
        puts $fout "       \"info\": false,"
        puts $fout "       \"order\": \[\],"
        puts $fout "    });"
        puts $fout "} );"
        puts $fout "</script>"

      }
    } else {
      if {$gtype eq "raw"} {
      } else {
        puts $fout "<script src=$env(GODEL_ROOT)/scripts/js/godel.js></script>"
        if {[info exist dataTables]} {
          puts $fout "<script src=$env(GODEL_ROOT)/scripts/js/jquery.dataTables.min.js></script>"
          puts $fout "<script>"
          puts $fout "    \$(document).ready(function() {"
          puts $fout "    \$('#tbl').DataTable({"
          puts $fout "       \"paging\": false,"
          puts $fout "       \"info\": false,"
        puts $fout "       \"order\": \[\],"
          puts $fout "    });"
          puts $fout "} );"
          puts $fout "</script>"

        }
      }
    }
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

# TOC
  if {$toc_enable eq "1"} {
    set lines [read_as_list .index.htm]

    set kout [open ".index.htm" w]
    
    foreach line $lines {
      if [regexp {=toc_anchor=} $line] {
        set idcounter 1
        set counter 0
        foreach i $::toc_list {
          set level    [lindex $i 0]
          set id       [lindex $i 1]
          #set css_ctrl [lindex $i 2]
            if {$level eq "1"} {
              incr counter
              set arr($counter,2) 0
              set arr($counter,3) 0
            } elseif {$level eq "2"} {
              if {$prev eq "3"} {
                set arr($counter,3) 0
              }
              incr arr($counter,2)
            } elseif {$level eq "3"} {
              incr arr($counter,3)
            }
            set index $counter.$arr($counter,2).$arr($counter,3)
            regsub -all {\.0} $index {} index
            puts $kout "<div class=L$level><a href=#tocid$idcounter><nobr>$index $id</nobr></a></div>"
            set prev $level

            incr idcounter
        }
      } else {
        puts $kout $line
      }
    }

    close $kout
  }

  if {$target_path == "NA" || $target_path == ""} {
  } else {
    cd $orgpath
  }
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
# split_by
# {{{
proc split_by {afile delimiter} {
  upvar curs curs
  array unset curs *

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
  array unset curs *
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
# obless
# {{{
proc obless {args} {
  global env
  source $env(GODEL_CENTER)/meta.tcl

  set pagename [lindex $args 0]

  regsub -all {,where} [array names meta] {} objs
  set hits [lsearch -all -inline -regexp $objs "$pagename"]
  if [regexp $pagename $hits] {
    # continue
  } else {
    if {[llength $hits] > 1} {
      foreach i $hits {
        puts $i
      }
      return
    }
  }

  set varfile $meta($pagename,where)/.godel/vars.tcl
  if [file exist $varfile] {
    source $varfile
  } else {
    puts "obless: not exist... $varfile"
    return
  }

  set where $meta($pagename,where)

  if [file exist $where/.godel/proc.tcl] {
    source $where/.godel/proc.tcl
  }

  set pagename [lindex $args 0]
  set objname  [lindex $args 1]

  if {$objname == ""} {
    help
  } else {
      godel_draw
      if [file exist $where/$objname/.godel/proc.tcl] {
        source $where/$objname/.godel/proc.tcl
      }
      foreach f $files {
        #file copy -force $where/$objname/$f $f
        exec cp $where/$objname/$f $f
      }
      lsetdyvar . srcpath  $where/$objname
      if [file exist .godel/preset.tcl] {
        source .godel/preset.tcl
      }
  }
}
# }}}
# oget
# {{{
proc oget {args} {
  global env
  source $env(GODEL_CENTER)/meta.tcl

  set pagename [lindex $args 0]

  regsub -all {,where} [array names meta] {} objs
  set hits [lsearch -all -inline -regexp $objs "$pagename"]
  if [regexp $pagename $hits] {
    # continue
  } else {
    if {[llength $hits] > 1} {
      foreach i $hits {
        puts $i
      }
      return
    }
  }

  set varfile $meta($pagename,where)/.godel/vars.tcl
  if [file exist $varfile] {
    source $varfile
  } else {
    puts "oget: not exist... $varfile"
    return
  }

  set where $meta($pagename,where)

  if [file exist $where/.godel/proc.tcl] {
    source $where/.godel/proc.tcl
  }

  set pagename [lindex $args 0]
  set objname  [lindex $args 1]
  set asname   [lindex $args 2]

  if {$objname == ""} {
    puts [exec ls -1 $where]
  } else {
    if {$asname eq ""} {
      if [file exist $objname] {
        puts "Already exist... $objname"
      } else {
        #puts  "cp -r $where/$objname ."
        puts "  building... $objname"
        exec  cp -r $where/$objname .
        lsetdyvar $objname srcpath  $where/$objname
        cd $objname
        if [file exist .godel/preset.tcl] {
          source .godel/preset.tcl
        }
        cd ..
      }
    } else {
      if [file exist $asname] {
        puts "Already exist... $asname"
      } else {
        #puts  "cp -r $where/$objname $asname"
        puts "  building... $asname"
        exec  cp -r $where/$objname $asname
        exec touch $asname/.godel/vars.tcl
        lsetdyvar $asname srcpath  $where/$objname
        lsetvar $asname g:iname    $asname
        lsetvar $asname g:pagename $asname
        lsetvar $asname runpath    [pwd]/$asname
        cd $asname
        if [file exist .godel/preset.tcl] {
          source .godel/preset.tcl
        }
        cd ..
      }
    }
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

  # -bless
# {{{
  set opt(-bless) 0
  set idx [lsearch $args {-bless}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-bless) 1
  }
# }}}
  if {$opt(-bless)} {
    set target $args
    godel_draw
    lsetdyvar . srcpath $where/$target
    set procfile $where/$target/.godel/proc.tcl
    if ![file exist $procfile] {
      puts "gget: not exist... $procfile"
      return
    } else {
      source $procfile
      foreach f $files {
        puts $f
        set dir   [file dirname $f]
        if ![file exist $dir] {
          file mkdir $dir
        } else {
          file copy -force $where/$target/$f $f
        }
      }
    }
    
    return
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
# godel_array_read
# {{{
proc godel_array_read {ifile aname newaname} {
  upvar $newaname arr

  source $ifile

  array set arr [array get $aname]


}
# }}}
# godel_array_save
# {{{
proc godel_array_save {aname ofile {newaname ""}} {
  upvar $aname arr

  if {[file dirname $ofile] != "."} {
    file mkdir [file dirname $ofile]
  }

  set kout [open $ofile w]
    set keys [lsort [array name arr]]
    foreach key $keys {
      set newvalue [string map {\\ {\\}} $arr($key)]
      regsub -all {\[} $key {\\[} key
      regsub -all { } $key {\ } key
      regsub -all {;} $key {\;} key
      regsub -all {\&} $key {\\&} key
      regsub -all {"}  $newvalue {\\"}  newvalue
      regsub -all {\$}  $newvalue {\\$}  newvalue
      regsub -all {\[} $newvalue {\\[}  newvalue
      regsub -all {\]} $newvalue {\\]}  newvalue
      if {$newaname eq ""} {
        puts $kout [format "set %-40s \"%s\"" [set aname]($key) $newvalue]
      } else {
        puts $kout [format "set %-40s \"%s\"" [set newaname]($key) $newvalue]
      }
    }
  close $kout
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
    return "EOF"
    #error "Ran out of list elements."
  }
}
# }}}
# plist
# {{{
proc plist {args} {
  # -indent
# {{{
  set opt(-indent) 0
  set idx [lsearch $args {-indent}]
  if {$idx != "-1"} {
    set indent [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-indent) 1
  } else {
    set indent ""
  }
# }}}
  # -ohandle
# {{{
  set opt(-ohandle) 0
  set idx [lsearch $args {-ohandle}]
  if {$idx != "-1"} {
    set ohandle [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-ohandle) 1
  }
# }}}
  # -file
# {{{
  set opt(-file) 0
  set idx [lsearch $args {-file}]
  if {$idx != "-1"} {
    set ofile [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-file) 1
  }
# }}}
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
    set ll [lsort $ll]
  }

  if {$opt(-ohandle) eq "1"} {
    foreach i $ll {
      puts $ohandle $indent$i
    }
  } elseif {$opt(-file) eq "1"} {
    set kout [open $ofile w]
      foreach i $ll {
        puts $kout $indent$i
      }
    close $kout
  } else {
    foreach i $ll {
      puts $indent$i
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
# meta_indexing
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

  array unset meta *

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
# lgrep_inc
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
# read_as_list
# {{{
# read a file and retrun a list
proc read_as_list {args} {
  # -filter
# {{{
  set opt(-filter) 0
  set idx [lsearch $args {-filter}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-filter) 1
  }
# }}}
  set afile [lindex $args 0]
  set fin [open $afile r]
    if {$opt(-filter) eq "1"} {
      while {[gets $fin line] >= 0} {
        regsub {^\s*} $line {} line
        regsub {\s$}  $line {} line
        lappend lines $line
      }
    } else {
      while {[gets $fin line] >= 0} {
        lappend lines $line
      }
    }
  close $fin

  if [info exist lines] {
    return $lines
  } else {
    return ""
  }
}
# }}}
# read_as_data
# {{{
proc read_as_data {ifile} {
  set kin [open $ifile r]
    set data [read $kin]
  close $kin
  return $data
}
# }}}

if [info exist env(GODEL_PLUGIN)] {
  if [file exist $env(GODEL_PLUGIN)] {
    source $env(GODEL_PLUGIN)
  }
}

# vim:fdm=marker
