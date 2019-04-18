
proc gdall {} {
  set dirs [glob -type d *]
  foreach dir $dirs {
    puts $dir
    cd $dir
    godel_draw
    cd ..
  }
}

# deln: de-link
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

# html_rows_sort
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


# make_table
proc make_table {rows header} {
  upvar fout fout

  puts $fout "<table class=table1>"
  puts $fout $header

  foreach row $rows {
    set row_ctrl [lindex $row end]
    set row [lreplace $row end end]

    set col_size [llength $row]
    puts -nonewline $fout "<tr $row_ctrl>"
    for {set i 0} {$i < $col_size} {incr i} {
      set data [lindex $row $i]
# Do nothing to data if <td> already specified
      if {[regexp {<td} $data]} {
        puts -nonewline $fout "$data"
      } else {
        puts -nonewline $fout "<td>$data</td>"
      }
    }
    puts $fout "</tr>"
  }
  puts $fout "<table>"
}

proc time_now {} {
  set timestamp [clock format [clock seconds] -format {%Y-%m-%d_%H-%M_%S}]
  return $timestamp
}
# glist
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
    set nlist {*}$args
  }

  puts $fout "<div class=\"gnotes w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"
# Title
  if {$opt(-t)} {
    puts $fout "<h1>$title</h1>"
  }
# List pages
  foreach page $nlist {
    if {$opt(-k)} {
      set disp [gvars -l $page $key]
    } else {
      set disp [gvars -l $page g:pagename]
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
  # -n 
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
    }
  }

  if ![info exist meta] {
    foreach i $env(GODEL_META_SCOPE) { mload $i }
  }

  set ilist [list]
  foreach i [lsort [array name meta *,where]] {
    regsub ",where" $i "" i
    lappend ilist $i
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
proc todo_table {ilist} {
  upvar fout fout 

  foreach i $ilist {
    source $i/.godel/vars.tcl
    if [info exist vars(done)] {
    } else {
      set vars(done) 0
    }
    if {$vars(done)} {
    } else {
      lappend tlist [list $vars(g:pagename) $vars(priority) $vars(title) $vars(done)]
    }
    godel_array_reset vars
  }

  puts $fout "<table class=table1>"
  foreach t [lsort -index 1 $tlist] {
    set page [lindex $t 0]
    set prio [lindex $t 1]
    set done [lindex $t 3]
    set titl [lindex $t 2]
    if {$prio == "1"} {
      puts $fout "<tr bgcolor=pink>"
    } elseif {$prio == "2"} {
      puts $fout "<tr bgcolor=cyan>"
    } else {
      puts $fout "<tr>"
    }
    puts $fout "<td><a href=$page/.index.htm>$page</a></td>"
    puts $fout "<td>$prio</td>"
    if {$done} {
      puts $fout "<td>O</td>"
    } else {
      puts $fout "<td></td>"
    }
    puts $fout "<td>$titl</td>"
    puts $fout "</tr>"
  }
  puts $fout "</table>"
}
proc pagelist {{sort_by by_updated}} {
# ghtm_pagelist by_updated/by_size
  global env
  upvar fout fout
  source $env(GODEL_META_CENTER)/meta.tcl
  source $env(GODEL_META_CENTER)/indexing.tcl
  array set vars [array get meta]
# ilist = pagelist

  #set ilist [lmap i [array name meta *,where] {regsub ",where" $i ""}]
  set ilist [list]
  foreach i [array name meta *,where] {
    regsub ",where" $i "" i
    lappend ilist $i
  }

#@>Foreach Pages in pagelist
# $ilist = page name list
  foreach i $ilist {
    set location $vars($i,where)
# vars,href
    set vars($i,href) "<a href=\"[tbox_cygpath $vars($i,where)/.index.htm]\" class=w3-text-blue>$i</a>"
# vars,last_updated
    if [info exist vars($i,last_updated)] {
      #regsub {^\d\d\d\d-} $vars($i,last_updated) {} vars($i,last_updated)
    } else {
      set vars($i,last_updated) 1111-11-11_1111
    }

    lappend pairs [list $i $vars($i,last_updated)]
# size_pairs
    if [info exist vars($i,page_size)] {
      if {$vars($i,page_size) == "NA"} {
        set vars($i,page_size) 0
        lappend size_pairs [list $i $vars($i,page_size)]
      } else {
        lappend size_pairs [list $i $vars($i,page_size)]
      }
    } else {
      set vars($i,page_size) 0
      lappend size_pairs [list $i $vars($i,page_size)]
    }
  }
  set arr(by_updated) [lsort -index 1 -decreasing $pairs]
  set arr(by_size)    [lsort -index 1 -decreasing -integer $size_pairs]


  set num 1
  foreach pair $arr($sort_by) {
    set name [lindex $pair 0]
# rowlist
    lappend rowlist $num
    set vars($num,name)     "$vars($name,href)"
    #puts $vars($num,name)
    set ghtm      "$vars($name,where)/.godel/ghtm.tcl type=text/txt"
    set vars_href "$vars($name,where)/.godel/vars.tcl type=text/txt"
    set vars($num,ghtm)     "ghtm=>$ghtm"
    set vars($num,vars)     "vars=>$vars_href"
    set vars($num,last)     $vars($name,last_updated)
    if [info exist vars($name,page_size)] {
      set vars($num,size)     $vars($name,page_size)
    } else {
      set vars($num,size)     ""
    }
    if [info exist vars($name,keywords)] {
      set vars($num,keywords) [concat $name $vars($name,keywords)]
    } else {
      set vars($num,keywords) ""
    }
    incr num
  }

# columnlist
  set columnlist [list]
  lappend columnlist [list name name]
  #lappend columnlist [list ghtm ghtm]
  #lappend columnlist [list vars vars]
  lappend columnlist [list last last]
  lappend columnlist [list size size]
  lappend columnlist [list keywords keywords]

  ghtm_table_nodir pagelist 0
}
proc get_srcpath {infile} {
  set orgpath [pwd]
  cd [file dirname $infile]
  set srcpath [pwd]
  cd $orgpath
  return $srcpath
}
proc ptses_chkver {ses_path} {
  set fin [open $ses_path/cmd_log r]
    set data [read $fin]
  close $fin

  regexp {\/(\w-\d\d\d\d\.\d\d-.*?)\/} $data whole version
  puts $version
}
proc ge {cmd args} {
  eval $cmd {*}$args
}
#----------------
# compare list a with b
#----------------
proc listcomp {a b} {
  set diff {}
  foreach i $a {
    if {[lsearch -exact $b $i]==-1} {
      lappend diff $i
    }
  }
  return $diff
}

# gmd
# {{{
proc gmd {fname} {
  global env
  upvar fout fout
  upvar vars vars
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

  gnotes $content
}
# }}}

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
#@> gnotes
# {{{
proc gnotes {content} {
  global env
  upvar fout fout
  upvar vars vars
  upvar count count
  upvar meta meta

# To allow `\' to display in code block
  regsub -all {\\ \n} $content "\\\n" content

# @) Get vars values
  set matches [regexp -all -inline {@\)(\S+)} $content]
  foreach {g0 g1} $matches {
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

# Markdown convertion
  set aftermd [::gmarkdown::convert $content]

  regsub -line -all {^<p>@\? (.*)</p>} $aftermd {<span class=keywords style=color:red>\1</span>} aftermd

  regsub -all {&lt;b&gt;NA&lt;/b&gt;} $aftermd <b>NA</b> aftermd

# @~ Link to gpage
  set matches [regexp -all -inline {@~(\S+)} $aftermd]
  foreach {whole iname} $matches {
# Tidy up iname likes `richard_dawkins</p>'
    regsub {<\/p>} $iname {} iname

    set addr [gpage_where $iname]
    set pagename [gvars $iname g:pagename]
    set atxt "<a href=$addr>$pagename</a>"
    regsub -all "@~$iname" $aftermd $atxt aftermd
  }

# @! Link to gpage as badge
  set matches [regexp -all -inline {@!(\S+)} $aftermd]
  foreach {whole iname} $matches {
# Tidy iname likes `richard_dawkins</p>'
    regsub {<\/p>} $iname {} iname

    set addr [gpage_where $iname]
    set pagename [gvars $iname g:pagename]
    set atxt "<a class=hbox2 href=$addr>$pagename</a>"
    regsub -all "@!$iname" $aftermd $atxt aftermd
  }

# @img() img
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

  puts $fout "<div class=\"gnotes w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"
  puts $fout $aftermd
  puts $fout "</div>"
}
# }}}
# grow
# {{{
proc grow {content} {
  upvar fout fout
  upvar vars vars
  upvar grow_column_width grow_column_width

  set cc [wsplit $content {#r}]

  puts $fout "<div class=\"w3-cell-row gnotes w3-pale-blue w3-leftbar w3-border-blue\">"
  set num 0
  foreach i $cc {
    if [regexp {^\n$} $i] {
    } else {
      set aa [::gmarkdown::convert $i]
      regsub -line -all {<p>@\? (.*)</p>} $aa {<span class=keywords style=color:red>\1</span>} aa
      set w [lindex $grow_column_width $num]
      if {$w == ""} {
        puts $fout "<div class=\"w3-container w3-cell w3-rightbar\">"
      } else {
        puts $fout "<div class=\"w3-container w3-cell w3-rightbar\" style=\"width:$w%\">"
      }
      #puts $fout "<div class=\"w3-container w3-cell w3-leftbar\">"
      puts $fout $aa
      puts $fout "</div>"
      incr num
    }
  }
  puts $fout "</div>"
}
# }}}

proc plant {pp} {
  global env
  puts $pp
  set org_path [pwd]
  cd $pp
  godel_draw
  cd $org_path
}

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
      puts $fout "<a href=\"$p\"><img src=\"$p\" style=width:$size><p style=font-size:10px>$p</p></a>"
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
  if [file exist $env(GODEL_META_CENTER)/gvi_list.tcl] {
    source       $env(GODEL_META_CENTER)/gvi_list.tcl
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
  if [file exist $env(GODEL_META_CENTER)/gok_list.tcl] {
    source       $env(GODEL_META_CENTER)/gok_list.tcl
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
            puts stderr [format "%-3s %-35s %s" $num $i $meta($i,keywords)]
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

  # -l (local)
  set opt(-l) 0
  set idx [lsearch $args {-l}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-l) 1
  }
  
  set keywords $args

  if {$opt(-l)} {
    if [file exist .godel/indexing.tcl] {
      source .godel/indexing.tcl
    } else {
      puts "Error: Not exist... .godel/indexing.tcl "
    }
  }

  if ![info exist meta] {
    foreach i $env(GODEL_META_SCOPE) { mload $i }
  }

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
    if {[llength $found_names] > 1} {
      foreach i $found_names {
        if [info exist meta($i,keywords)] {
          puts stderr [format "%-35s = %s" $i $meta($i,keywords)]
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
# get_pagelist
# {{{
proc get_pagelist {{keywords ""}} {
  global env
  upvar meta meta
  if ![info exist meta] {
    foreach i $env(GODEL_META_SCOPE) { mload $i }
  }

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
  return $found_names

}
# }}}
# ghtm_plot_line1
# {{{
proc ghtm_plot_line1 {name alist} {
  upvar fout fout
  file mkdir .godel/chart
  gnuplot_trend1_script .godel/chart/$name.dat \
                        .godel/chart/$name \
                        .godel/chart/$name.png

  # Create dat file
  set counter 1
  set kout [open .godel/chart/$name.dat w]
  foreach i $alist {
    puts $kout "$counter $i"
    incr counter
  }
  close $kout

  catch {exec tcsh -fc "gnuplot -c .godel/chart/$name.plt"}

  puts $fout "<img src=.godel/chart/$name.png>"
  puts $fout "<a href=.godel/chart/$name.tcl>ctrl</a>"
}
# }}}
#@> Table
#@=tbl_get_rows
proc tbl_get_rows {tname} {
  upvar vars global
  return $vars(gtable,$tname,rowlist)
}
#@=tbl_get_cols
proc tbl_get_cols {tname} {
  upvar vars vars
  return $vars(gtable,$tname,columnlist)
}
#@=tbl_set_col_attr
proc tbl_set_col_attr {tname collist attr} {
  upvar vars vars
  foreach col $collist {
    set vars(gtable,$tname,$col,attr) $attr
  }
}
#@=money_convert
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
#@=tbl_add_value
proc tbl_add_value {key value} {
  upvar vars vars
  set vars($key) $value
}
#@=tbl_add_values_to_row
# {{{
proc tbl_add_values_to_row {tname row_name values} {
  upvar vars vars
  foreach column  $vars(gtable,$tname,columnlist) value $values {
    if {$value == "NA"} {
      # keep it as original
    } else {
      set vars($row_name,$column) $value
    }
  }
}
# }}}
#@=tbl_add_values_to_col
# {{{
proc tbl_add_values_to_col {tname col_name values} {
  upvar vars vars
  foreach row  $vars(gtable,$tname,rowlist) value $values {
    if {$value == "NA"} {
      # keep it as original
    } else {
      set vars($row,$col_name) $value
    }
  }
}
# }}}
proc tbl_copy {from to} {
  upvar vars vars
  set vars(gtable,$to,rowlist) $vars(gtable,$from,rowlist)
  set vars(gtable,$to,columnlist) $vars(gtable,$from,columnlist)
}
proc tbl_rm {tname} {
  upvar vars vars
  unset vars(gtable,$tname,rowlist)
  unset vars(gtable,$tname,columnlist)
}
proc tbl_add_column {tblname location column_names} {
}
proc tbl_set_cols {tname columnlist} {
  upvar vars vars
  set   vars(gtable,$tname,columnlist) $columnlist
  #puts $vars(gtable,$tname,columnlist)
}
proc tbl_set_rows {tname rowlist} {
  upvar vars vars
  regsub {#.*?\n} $rowlist {} rowlist
  set   vars(gtable,$tname,rowlist) $rowlist
  #puts $vars(gtable,$tname,rowlist)
}

proc tbl_sum_column {tname column} { }
proc tbl_average_column {tname column} { }
proc tbl_norm_column {tname column newcol location} { }
#proc tbl_sum_column {tname column} { }
#proc tbl_sum_column {tname column} { }


proc tbl_get_column {tname column} {
  upvar vars vars
  set rlist [list]
  foreach row $vars(gtable,$tname,rowlist) {
    if [info exist vars($row,$column)] {
      lappend rlist $vars($row,$column)
    } else {
      lappend rlist "NA"
    }
  }
  return $rlist
}
# Read file in to line list
proc read_timing_rpt_file {fname} {
  upvar vars vars

  set fin [open $fname r]
    set data [read $fin]
    set lines [split $data \n]
  close $fin

# Extract information from star(*) header
# We need below information to know how many lines to suck-in in each foreach
# -inputs_pins
# -nets
  set lstar1 [lgrep_index $lines {\*\*} 0]
  set lstar2 [lgrep_index $lines {\*\*} [expr $lstar1 + 1]]
  set topheader [lrange $lines $lstar1 $lstar2]
# -inputs_pins
  if {[lsearch -regexp $topheader -input_pins] >= 0} {
    set vars(-input_pins) 1
  } else {
    set vars(-input_pins) 0
  }
# -nets
  if {[lsearch -regexp $topheader -nets] >= 0} {
    set vars(-nets) 1
  } else {
    set vars(-nets) 0
  }

# extract timing paths from $lines and store in $apaths
  set next_search_lineno 0
  while {$next_search_lineno >= 0} {
    set apath_pack [extract_a_timing_path $lines $next_search_lineno "Startpoint:" "^  slack"]

    set next_search_lineno [lindex $apath_pack 0]
    if {$next_search_lineno == "-1"} {
      break
    }
    lappend apaths  [lindex $apath_pack 1]
  }
  return $apaths
}

#@=extract_a_timing_path
proc extract_a_timing_path {lines start_index path_begin_keyword path_end_keyword} {
# User lrange to extract a path
# lines: full timing path lines
# start_index: search start from $start_index
# Path begin with keyword: $path_begin_keyword
# Path end   with keyword: $path_end_keyword
# Return a list contains [next_line_no, apath]
  # line startpoint
  set lstartpoint [lgrep_index $lines {Startpoint:} $start_index]
  # line slack
  set lslack      [lgrep_index $lines {^  slack}    [expr $lstartpoint + 1]]
  if {$lstartpoint == "-1" || $lslack == "-1"} {
    return [list "-1" "-1"]
  } else {
    set apath       [lrange $lines $lstartpoint $lslack]
    return [list [expr $lslack + 1] $apath]
  }
}

proc reset_vars {} {
  upvar instin     instin     
  upvar instout    instout    
  upvar cell       cell       
  upvar fanout     fanout     
  upvar net_cap    net_cap    
  upvar in_tran    in_tran    
  upvar out_tran   out_tran   
  upvar cell_delay cell_delay 
  upvar cell_derate cell_derate 
  upvar net_derate net_derate 

  set instin       NA
  set instout      NA
  set cell         NA
  set fanout       NA
  set net_cap      NA
  set in_tran      NA
  set out_tran     NA
  set cell_delay   NA
  set cell_derate  NA
  set net_derate   NA
}
# dict_set
# {{{
# instin
# instout
# cell
# fanout
# net_cap
# in_tran
# out_tran
# cell_delay
proc dict_set {} {
  upvar dd dd
  upvar instin     instin     
  upvar instout    instout    
  upvar cell       cell       
  upvar fanout     fanout     
  upvar net_cap    net_cap    
  upvar in_tran    in_tran    
  upvar out_tran   out_tran   
  upvar cell_delay cell_delay 
  upvar net_derate net_derate
  upvar cell_derate cell_derate

  dict set dd instin      $instin    
  dict set dd instout     $instout   
  dict set dd cell        $cell      
  dict set dd fanout      $fanout    
  dict set dd net_cap     $net_cap   
  dict set dd in_tran     $in_tran   
  dict set dd out_tran    $out_tran  
  dict set dd cell_delay  $cell_delay
  dict set dd cell_derate $cell_derate
  dict set dd net_derate  $net_derate
}
# }}}

proc lpush {stack value} {
  upvar $stack list
  lappend list $value
}

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

# ghtm_new_html
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

# ghtm_toc
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
  ghtm_new_html toc

# Create main.htm
  set kout [open .main.htm w]
    puts $kout {<!DOCTYPE html>}
    puts $kout {<html> <head>}
    puts $kout "<title>$vars(g:pagename)</title>"
    puts $kout {<meta charset=utf-8>}
    puts $kout {<frameset cols=25%,75%>}
    puts $kout {　　<frame src=.toc.htm name=leftFrame >}
    puts $kout {　　<frame src=.index.htm name=rightFrame >}
    puts $kout {</frameset>}
    puts $kout {</head> <body> </body> </html>}
  close $kout
}

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

proc gpage_where {pagename} {
  global env env
  upvar meta meta

  if [info exist meta] {
  } else {
    mload default
  }
  if {$env(GODEL_IN_CYGWIN)} {
    if [info exist meta($pagename,where)] {
      return [tbox_cygpath $meta($pagename,where)]/.index.htm
    } else {
      return ".index.htm"
    }
  } else {
    return $meta($pagename,where)/.index.htm
  }
}
proc gpage_value {pagename attr} {
  global env
  source $env(GODEL_META_FILE)
  source $meta($pagename,where)/.godel/vars.tcl
  if [info exist vars($attr)] {
    return $vars($attr)
  } else {
    #puts "Error: $pagename,bday not exist..."
    return "NA"
  }
}

proc num_symbol {num {symbol NA}} {
  set s(K) 1000
  set s(W) 10000
  set s(M) 1000000
  set s(Y) 100000000
  set s(B) 1000000000
  set s(T) 1000000000000
  regsub -all {,} $num {} num
  return [format_3digit [expr $num/$s($symbol)]]$symbol
}

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
proc gxml_exe {} {
# process xml
# <root>
# <command> </command>
# </root>
  exec tcsh -fc "xclip -o > ~/.tmp.gexe"

  set fin [open ~/.inst.xml r]
  set doc [dom parse [read $fin]]
  close $fin

  set root [$doc documentElement]

  set nodes [$root selectNodes /inst/command/text()]
  foreach node $nodes {
    set cmd [$node nodeValue]
    catch {eval $cmd}
    puts $cmd
  }
  puts "Done Execution!"
}

proc tmu {tagname attr args} {
# tmu: tcl markup
# example:
# tmu a:2- "href=foo/index.htm" foo
# -> <a href=foo/index.html>foo</a>
  set c [split $tagname :]
  set tag    [lindex $c 0] 
  set indent [lindex $c 1]
  if [regexp {\-} $indent] {
    set newline ""
  } else {
    set newline "\n"
  }
  regsub {\-} $indent {} indent

  set space [string repeat "  " $indent]

  if {$attr == ""} {
    set txt "$space<$tag>$newline"
  } else {
    set txt "$space<$tag $attr>$newline"
  }

  foreach i $args {
    append txt "$i$newline"
  }

  if {$newline == ""} {
    append txt "</$tag>"
  } else {
    append txt "$space</$tag>"
  }
  return $txt
}


proc chklist_co {type} {
  global env

  if {$type == ""} {
    set ilist [glob -nocomplain $env(CLCENTER)/*]
    foreach i $ilist {
      puts [file tail $i]
    }
    return
  }

  set ilist [glob -nocomplain $env(CLCENTER)/$type/*]
  file mkdir chklist/$type
  foreach i $ilist {
    set chkitem [file tail $i]
    puts $chkitem
    file delete -force     chklist/$type/$chkitem
    file copy   -force $i  chklist/$type
  }

  godel_draw chklist
}
proc godel_touch {fname} {
  if ![file exist $fname] {
    close [open $fname w]
  }
}
proc chklist_new {chkitem} {
  global env
  #puts $chkitem
  if {$chkitem == ""} {
    puts "Usage: chklist-new `APR-01'"
    return
  }
  set c [split $chkitem -]
  set type [lindex $c 0]
  file mkdir chklist/$type/$chkitem
  set kout [open chklist/$type/$chkitem/description.txt w]
  puts $kout "<pre>"
  puts $kout "</pre>"
  close $kout
  godel_touch chklist/$type/$chkitem/comment.txt
  godel_touch chklist/$type/$chkitem/clvars.tcl

# time_creation
  set clvars(time_creation) [clock format [clock seconds] -format {%Y-%m-%d_%H%M}]
  set clvars($type-$chkitem,owner) Nobody
  set clvars($type-$chkitem,status) ""
  godel_array_save clvars chklist/$type/$chkitem/clvars.tcl

  cd chklist/$type/$chkitem
  godel_draw chkitem
  cd ../../../
  godel_draw chklist
}
proc chklist_ci {} {
  global env
  if ![file exist chklist] {
    puts "Error: there is no chklist directory..."
    return
  }
  set ilist [glob chklist/*]
  foreach i $ilist {
    set type [file tail $i]
    file mkdir $env(CLCENTER)/$type
  }

  set ilist [glob chklist/*/*]
  foreach i $ilist {
    regsub {chklist\/} $i {} i
    file delete -force $env(CLCENTER)/$i
    file copy -force chklist/$i $env(CLCENTER)/$i
  }
}

proc chklist_owner {owner} {
  upvar fout fout
  global env
  set flist [glob $env(CLCENTER)/*/*/clvars.tcl]
  foreach f $flist {
    source $f
  }
  #parray clvars
  set ilist [glob $env(CLCENTER)/*/*/description.txt] 
# Sort chkitems
  set ilist [lsort -increasing $ilist]
  foreach i $ilist {
    set chkno [godel_get_path_elem $i end-1]
    #puts $chkno
    if [info exist clvars($chkno,owner)] {
      if {[regexp $owner $clvars($chkno,owner)]} {
        puts $chkno
      }
    }
  }



}
# chklist_table
# {{{
proc chklist_table {{sort -increasing}} {
  upvar fout fout
  set flist [glob -nocomplain chklist/*/*/clvars.tcl]
  foreach f $flist {
    source $f
  }

  set ilist [glob chklist/*/*/description.txt] 
# Sort chkitems
  set ilist [lsort $sort $ilist]
  puts $fout "<table class=\"table1\">"
  puts $fout "<thead>"
  puts $fout "<th>Check No.</th>"
  puts $fout "<th>Description</th>"
  puts $fout "<th>Status</th>"
  puts $fout "<th>Comment</th>"
  puts $fout "<th></th>"
  puts $fout "<th>Owner</th>"
  puts $fout "</thead>"
  foreach i $ilist {
    set chkno [godel_get_path_elem $i end-1]
    set dir [file dirname $i]
    if ![info exist clvars($chkno,status)] { set clvars($chkno,status) "" }
    #if {$clvars($chkno,status) == "pass"} {
    #  puts $fout "<tr bgcolor=lime>"
    #} elseif {$clvars($chkno,status) == "fail"} {
    #  puts $fout "<tr bgcolor=red>"
    #} elseif {$clvars($chkno,status) == "waive"} {
    #  puts $fout "<tr bgcolor=grey>"
    #} else {
    #  puts $fout "<tr>"
    #}
# chkitem
    puts $fout "<td>"
    puts $fout "<a href=$dir/.index.htm>$chkno</a>"
    puts $fout "</td>"
# description.txt
    puts $fout "<td>"
    set fin [open $i r]
      while {[gets $fin line] >= 0} {
        puts $fout $line
      }
    #puts $fin "description"
    close $fin
    puts $fout "</td>"
# radios
    if {$clvars($chkno,status) == "pass"} {
      puts $fout "<td bgcolor=LawnGreen>"
    } elseif {$clvars($chkno,status) == "fail"} {
      puts $fout "<td bgcolor=Tomato>"
    } elseif {$clvars($chkno,status) == "waive"} {
      puts $fout "<td bgcolor=LightGrey>"
    } else {
      puts $fout "<td>"
    }
    puts $fout "<form>"
    if ![info exist clvars($chkno,owner)] { set clvars($chkno,owner) "" }
    if {$clvars($chkno,status) == "pass"}  { set passchk  checked } else {set passchk  ""}
    if {$clvars($chkno,status) == "fail"}  { set failchk  checked } else {set failchk  ""}
    if {$clvars($chkno,status) == "waive"} { set waivechk checked } else {set waivechk ""}
    puts $fout " <input type=\"radio\" name=\"${chkno},status\" value=\"pass\"  $passchk> Pass<br>"
    puts $fout " <input type=\"radio\" name=\"${chkno},status\" value=\"fail\"  $failchk> Fail<br>"
    puts $fout " <input type=\"radio\" name=\"${chkno},status\" value=\"waive\" $waivechk> Waive"
    puts $fout "</form> "
    puts $fout "</td>"

# comment.txt
    puts $fout "<td>"
    set fin [open $dir/comment.txt r]
      while {[gets $fin line] >= 0} {
        puts $fout $line
      }
    close $fin
    puts $fout "</td>"
# edit comment.txt
    puts $fout "<td>"
    puts $fout "<a href=$dir/comment.txt type=text/txt>e</a>"
    puts $fout "</td>"
# owner
    puts $fout "<td>"
    puts $fout "<form>"
    puts $fout " <input type=\"text\" name=\"${chkno},owner\" value=\"$clvars($chkno,owner)\">"
    puts $fout "</form> "
    puts $fout "</td>"

    puts $fout "</tr>"
  }
  puts $fout "</table>"
  #puts $fout "<table class=\"table1\">"


  #puts $fout "</table>"
}
# }}}
proc chklist_set {chkno_type value} {
  set c [split $chkno_type -]
  set dir [lindex $c 0]
  set c [split $chkno_type ,]
  set chkno [lindex $c 0]
  set type  [lindex $c 1]
  set path chklist/$dir/$chkno
  #puts $path
  ##cd $path
  source $path/clvars.tcl
  set clvars($chkno_type) $value
  #set clvars(last_updated) [clock format [clock seconds] -format {%Y-%m-%d_%H%M}]
  godel_array_save clvars $path/clvars.tcl
}

proc godel_get_path_elem {path index} {
  set c [split $path /]
  set column_string [lindex $c $index]
  return $column_string
}

#: godel_merge_proc
# {{{
proc godel_merge_proc {plist ofile} {
  set fout [open "m.tcl" w]
  foreach p $plist {
    set fin [open "dc_tcl/$p.tcl"]
      puts $fout "#: $p"
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

#: godel_split_proc
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
proc godel_file_join {args} {
  foreach i $args {
    puts $i
  }
}
#: godel_split_by_proc
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

    if [regexp {^#: } $line] {
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
# set:restrict
# from a and not in b
proc setop_restrict {a b} {
  set o {}
  foreach i $a {
    if {[lsearch $b $i] < 0} {lappend o $i}
  }
  return $o
}
# Both in a and b
proc setop_intersection {a b} {
  set o {}
  foreach i $a {
    if {[lsearch $b $i] >= 0} {lappend o $i}
  }
  return $o
}
# All element in a and b once i.e. join
proc setop_union {a b} {
  set o {}
  foreach i $a {
    if {[lsearch $b $i] < 0} {lappend o $i}
  }
  set o [concat $o $b]
  return $o
}

proc math_average {alist} {
  expr ([join $alist +])/[llength $alist].
}
proc math_sum {alist} {
  expr ([join $alist +])
}
# {{{
proc gdnew {name} {
  global env
  puts $name
  set kout [open $env(GODEL_ROOT)/plugin/gdraw/gdraw_$name.tcl w]
    puts $kout "lappend define(installed_flow) $name"
    puts $kout "proc gdraw_${name} \{\} \{"
      puts $kout "  global env
      puts $kout "  set kout \[open .godel/ghtm.tcl w\]"
      puts $kout "    puts \$kout \"set flow_name $name\""
      puts $kout "    puts \$kout \"ghtm_top_bar\""
      puts $kout "  close \$kout"
    puts $kout "\}"
  close $kout
}
# }}}
proc gdrm {name} {
  global env
  puts $name
  if [file exist $env(GODEL_ROOT)/plugin/gdraw/gdraw_$name.tcl] {
    puts "Delete `$name'"
    file delete $env(GODEL_ROOT)/plugin/gdraw/gdraw_$name.tcl
  } else {
    puts "`$name' not exist..."
  }
}
proc gflu_topdown {} {
}
# gflu
# {{{
proc gflu {virus degree {action ""}} {
  file copy -force $virus ~/.virus

  if {$degree == "1"} {
    cd ../
    set victims [glob */$virus]
  } elseif {$degree == "2"} {
    cd ../../
    set victims [glob */*/$virus]
  } elseif {$degree == "3"} {
    cd ../../../
    set victims [glob */*/*/$virus]
  } elseif {$degree == "4"} {
    cd ../../../..
    set victims [glob */*/*/*/$virus]
  }

  if {$action == ""} {
    foreach victim $victims {
      puts $victim
    }
  } elseif {$action == "kill"} {
    foreach victim $victims {
      puts "$victim .....Kill"
      file copy -force ~/.virus $victim
    }
  }
}
# }}}
#@> Godel Fundamental
#@=godel_draw
# {{{
proc godel_draw {{ghtm_proc NA} {force NA}} {
  package require gmarkdown
  upvar vars vars
  global env
  upvar argv argv
  upvar just_draw just_draw
  upvar bvars bvars
  set ::toc_list [list]

  if {$ghtm_proc == "clean"} {
    file delete -force -- .godel .index.htm
    return
  }

  # source plugin script
  set flist [glob $env(GODEL_PLUGIN)/*/*.tcl]
  foreach f $flist {
    #puts $f
    source $f 
  }
  if [info exist env(GODEL_USER_PLUGIN)] {
    set flist [glob -nocomplain $env(GODEL_USER_PLUGIN)/*.tcl]
    foreach f $flist { source $f }
  }

  if {$ghtm_proc == "list"} {
    puts "Installed flow:"
    foreach i $define(installed_flow) {
      puts "    $i"
    }
    return
  }

  # default vars
  if [file exist .godel/vars.tcl] {
    source .godel/vars.tcl
    #godel_init_vars    g:where       [pwd]
    godel_init_vars    g:keywords    ""
    godel_init_vars    g:class       ""
    godel_init_vars    g:pagename    [file tail [pwd]]
    godel_init_vars    g:iname       [file tail [pwd]]
  } else {
    #godel_init_vars    g:where       [pwd]
    godel_init_vars    g:keywords    ""
    godel_init_vars    g:class       ""
    godel_init_vars    g:pagename    [file tail [pwd]]
    godel_init_vars    g:iname       [file tail [pwd]]
  }

  file mkdir .godel
  # .index.htm
  global fout
  set fout [open ".index.htm" w]

  puts $fout "<!DOCTYPE html>"
  puts $fout "<html>"
  puts $fout "<head>"
  puts $fout "<title>$vars(g:pagename)</title>"

# Copy to local to make page sharing easier. Viwer don't need to have Godel installed.
  #file copy -force $env(GODEL_ROOT)/etc/css/w3.css .godel/

  #file copy -force $env(GODEL_ROOT)/scripts/js/prism/themes/prism-twilight.css .godel/
  #puts $fout "<link rel=\"stylesheet\" href=.godel/w3.css>"
  #puts $fout "<link rel=\"stylesheet\" href=.godel/prism-twilight.css data-noprefix/>"

# Link to global w3.css
  #puts $fout "<link rel=\"stylesheet\" href=[tbox_cygpath $env(GODEL_ROOT)/etc/css/w3.css]>"

# Hardcode w3.css in .index.htm so that you have all in one file.
  puts $fout "<style>"
  set fin [open $env(GODEL_ROOT)/etc/css/w3.css r]
    while {[gets $fin line] >= 0} {
      puts $fout $line
    }
  close $fin
  puts $fout "</style>"
  #puts $fout "<link rel=\"stylesheet\" href=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/prism/themes/prism-twilight.css] data-noprefix/>"
  puts $fout "<meta charset=utf-8>"
  puts $fout "</head>"
  puts $fout "<body>"

  if {$force == "force"} {
      if [tbox_procExists gdraw_$ghtm_proc] {
        #puts "Check out `$ghtm_proc' ghtm.tcl..."
        gdraw_$ghtm_proc
      } else {
        #puts "Check out `default' ghtm.tcl"
        gdraw_default
      }
# ghtm.tcl is executed here.
      #puts "Execute ghtm.tcl..."
      source .godel/ghtm.tcl
  } else {
    if [file exist .godel/ghtm.tcl] {
# ghtm.tcl is executed here.
      #puts "Execute ghtm.tcl..."
      source .godel/ghtm.tcl
    } else {
      if [tbox_procExists gdraw_$ghtm_proc] {
        puts "Check out `$ghtm_proc'..."
        gdraw_$ghtm_proc
      } else {
        #puts "Check out `default' ghtm.tcl"
        gdraw_default
      }
# ghtm.tcl is executed here.
      #puts "Execute ghtm.tcl..."
      source .godel/ghtm.tcl
    }
  }
  puts $fout "</body>"
  puts $fout "</html>"

  close $fout

  if [file exist .godel/dyvars.tcl] {
    source .godel/dyvars.tcl
  }
  set dyvars(last_updated) [clock format [clock seconds] -format {%Y-%m-%d_%H%M}]
  godel_array_save dyvars .godel/dyvars.tcl
  godel_array_save vars   .godel/vars.tcl

  godel_array_reset vars
}
# }}}
#@=godel_re_import
# godel_re_import
# {{{
proc godel_re_import {gpath} {
  puts $gpath
  upvar env    env

  # source plugin script
  set flist [glob $env(GODEL_PLUGIN)/*/*.tcl]
  foreach f $flist { source $f }
  if [info exist env(GODEL_USER_PLUGIN)] {
    set flist [glob -nocomplain $env(GODEL_USER_PLUGIN)/*.tcl]
    foreach f $flist { source $f }
  }

  file delete -force $env(GODEL_CENTER)/$gpath/.godel/ghtm.tcl

  source $env(GODEL_CENTER)/$gpath/.godel/vars.tcl

  if [info exist vars(srcpath)] {
    puts $vars(srcpath)
  }

  set argv "$vars(flow_name) $gpath"
  godel_import
}
# }}}
#@=godel_import
# godel_import
# {{{
proc godel_import {} {
# {{{
  global env
  upvar argv argv

  # source plugin script
  set flist [glob $env(GODEL_PLUGIN)/*/*.tcl]
  foreach f $flist { source $f }
  if [info exist env(GODEL_USER_PLUGIN)] {
    set flist [glob -nocomplain $env(GODEL_USER_PLUGIN)/*.tcl]
    foreach f $flist { source $f }
  }

  set flow_name [lindex $argv 0]
  set dir  [lindex $argv 1]

  # Print installed flows
  if {$flow_name == ""} {
    puts "Installed flow:"
    foreach i $define(installed_flow) {
      puts "    $i"
    }
    return
  }

  # Print supported files
  if {$dir == ""} {
    foreach f $define($flow_name,filelist) {
      puts [format "%-20s %s" [lindex $f 0] [lindex $f 1]]
    }
    return
  }

# Mapped file name and whether exist
  if {[tbox_path_length $dir] == 2} {
    set stage  [file tail $dir]
    set module [file dirname $dir]
    puts [format "\033\[0;36m%-20s %-33s %s\033\[0m" "Required" "Mapped to" "Stage"]
    foreach f $define($flow_name,filelist) {
      #puts $f
      set fname [lindex $f 0]
      set mapped [godel_mapped_fname $fname]
      puts [format "%-20s (%s)%-30s %s" $fname [lindex $mapped 1] [lindex $mapped 0] [lindex $mapped 2]]
    }
    return
  }

  set pp [lindex $argv 1]
# To assure full path is specificed
  regsub -all {\/} $pp { } pplist
  if {[llength $pplist] != "4"} {
    puts "Error: $pp"
    puts "You might miss corner directory."
    return
  }
# }}}
  set corner          [file tail $pp]
  set version         [file tail [file dirname $pp]]
  set path            [file dirname [file dirname $pp]]
  set stage           [file tail $path]
  set module          [file tail [file dirname $path]]
  set srcpath         [pwd]
  set vars(module)   $module
  set vars(stage)    $stage
  set vars(corner)   $corner
  set vars(version)  $version
  set vars(flow_name) $flow_name
  set vars(srcpath)   $srcpath

  godel_create_dir4
  cd $env(GODEL_CENTER)/$module/$stage/$version/$corner
 
 # Init
  if [info exist define($stage,init)] {
     puts "\033\[0;36mInit .godel/vars.tcl...\033\[0m"
     puts "     source $define($stage,init)"
     source $define($stage,init)
  } elseif [info exist define(default,init)] {
     puts "\033\[0;36mInit .godel/vars.tcl...\033\[0m"
     puts "     source $define(default,init)"
     source $define(default,init)
  }
  godel_array_save vars .godel/vars.tcl

  puts "\033\[0;36mCooking...(gdraw_$flow_name)\033\[0m"
  godel_draw $flow_name
  godel_complete_vars
  godel_htmdraw

  cd $srcpath
}
# }}}
#@=godel_redraw
# {{{
proc godel_redraw {pp} {
  global env

  # source plugin script
  set flist [glob $env(GODEL_PLUGIN)/*/*.tcl]
  foreach f $flist {
    #puts $f
    source $f 
  }
  if [info exist env(GODEL_USER_PLUGIN)] {
    set flist [glob -nocomplain $env(GODEL_USER_PLUGIN)/*.tcl]
    foreach f $flist { source $f }
  }

  regsub -all {^CENTER\/} $pp "" pp
  regsub -all {\/} $pp { } pplist
  cd $env(GODEL_CENTER)/$pp

  set module  [lindex $pplist 0]
  set stage   [lindex $pplist 1]
  set version [lindex $pplist 2]
  set corner  [lindex $pplist 3]

  puts "godel_redraw..."
  set size [llength $pplist]
  incr size
    for {set i $size} {$i >= 1} {incr i -1} {
      puts "  $i"
      puts "    godel_update_vars$i"
                godel_update_vars$i
      puts "    godel_asic_index$i"
                godel_asic_index$i
      cd ..
    }
    exec tcsh -fc "rm -rf ~/.promoted/vars.tcl"
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
# godel_mapped_fname
# {{{
proc godel_mapped_fname {fname} {
  upvar define define
  upvar stage  stage
  upvar module module

  if       [info exist define($fname,$stage,$module)] {
    set mapped $define($fname,$stage,$module)
    set key $stage,$module
  } elseif [info exist define($fname,$stage)] {
    set mapped $define($fname,$stage)
    set key $stage
  } elseif [info exist define($fname,default)] {
    set mapped $define($fname,default)
    set key "default"
  } else {
    set mapped $fname
    set key "NA"
  }

  if [file exist $mapped] {
    return "$mapped O $key"
  } else {
    return "$mapped X $key"
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
# godel_list
# {{{
proc godel_list {pp {prefix ""} {postfix ""}} {
  global env
  regsub -all {\/} $pp { } pplist
  cd $env(GODEL_CENTER)/$pp
  if {[llength $pplist] == "3"} {
    set klist [glob -nocomplain */index5.htm]
  } elseif {[llength $pplist] == "2"} {
    set klist [glob -nocomplain */index4.htm]
  } elseif {[llength $pplist] == "1"} {
    set klist [glob -nocomplain */index3.htm]
  } elseif {[llength $pplist] == "0"} {
    set klist [glob -nocomplain */index2.htm]
  }
  
  foreach k $klist {
    lappend dlist [file dirname $k]
  }
  
  foreach d $dlist {
    puts "$prefix $d $postfix"
  }
}
# }}}
# godel_remove_list_element
# {{{
proc godel_remove_list_element {alist elename} {
  return [lsearch -all -inline -not -exact $alist $elename]
}
# }}}
# godel_delete
# {{{
proc godel_delete {} {
# under construction...
  global env
  upvar argv argv
  set pp [lindex $argv 0]
  cd $env(GODEL_CENTER)/$pp/..

# Version
# {{{
  puts [pwd]
  source .godel/vars.tcl
  #parray vars
  foreach {key value} [array get vars] {
    if [regexp "$vername," $key] {
      unset vars($key)
    }
  }
  set vars(version_list) [godel_remove_list_element $vars(version_list) $vername]
# latest_version
  if [info exist vars(latest_version)] {
    set vars(latest_version) [lindex [lsort -decreasing $vars(version_list)] 0]
  } else {
    set vars(latest_version) $version
  }
# current_version
  if {$vars(current_version) == $vername} {
    set vars(current_version) $vars(latest_version)
  }
  godel_array_save vars .godel/vars.tcl
# }}}  
# Stage
# {{{
  cd ..
  godel_array_reset vars
  puts [pwd]
  source .godel/vars.tcl
  #parray vars
  foreach {key value} [array get vars] {
    if [regexp "$vername," $key] {
      unset vars($key)
    }
  }
  godel_array_save vars .godel/vars.tcl
# }}}  
# Module
# {{{
  cd ..
  godel_array_reset vars
  puts [pwd]
  source .godel/vars.tcl
  #parray vars
  foreach {key value} [array get vars] {
    if [regexp "$vername," $key] {
      unset vars($key)
    }
  }
  godel_array_save vars .godel/vars.tcl
# }}}  
  exec tcsh -fc "rm -rf $env(GODEL_CENTER)/$pp"
}
# }}}
# godel_index4_corner_td
# {{{
proc godel_index4_corner_td {cornerlist color} {
  upvar define define
  upvar fout fout
  foreach corner $cornerlist {
    set fname $define(pt,corner_name,$corner)
    if [file exist $fname/index5.htm] {
      puts $fout "<td bgcolor=$color><a href=$fname/index5.htm>$corner</a></td>"
    } else {
      puts $fout "<td bgcolor=$color>$corner</td>"
    }
  }
}
# }}}
# godel_evolve
# {{{
proc godel_evolve {ver} {
  global env
  source $env(GODEL_CENTER)/.godel/vars.tcl

  regsub -all {\/} $ver { } new
  set module [godel_get_column $new 0]

  set palist [list]
# palist will be set here
  godel_get_parent $module $ver

  godel_evolve_htm

}
# }}}
# godel_get_parent
# {{{
proc godel_get_parent {module son} {
  upvar vars vars
  upvar palist palist

  regsub -all {\/} $son {,} son
  set parent $vars($son,parent)

  regsub -all {\/} $parent {,} parent
  set parent $module,$parent

  if [info exist vars($parent,parent)] {
    lappend palist $parent
    return [godel_get_parent $module $parent]
  } else {
    lappend palist $parent
    return $parent
  }
}
# }}}
# godel_checkout
# {{{
proc godel_checkout {ipath} {
  global env

  set backup_dir [pwd]
  cd $env(GODEL_CENTER)
  set ilist [glob -nocomplain */sta/*/*/inputs]
  set ilist2 [glob -nocomplain */*/*/inputs]
  set ilist [concat $ilist $ilist2]

  cd $backup_dir

  if {$ipath == ""} {
    foreach i $ilist {
      set pp [file dirname $i]
      puts "gco $pp"
    }
  } else {
    #set pp [file dirname $ipath]
    file mkdir export/$ipath
    #file copy $env(GODEL_CENTER)/$ipath/inputs/* export/$ipath
    exec tcsh -fc "cp -rf $env(GODEL_CENTER)/$ipath/inputs/* export/$ipath"
    exec tcsh -fc "cp -rf $env(GODEL_CENTER)/$ipath/.godel/vars.tcl export/$ipath"
  }
}
# }}}
#: godel_list_uniq_add
# {{{
proc godel_list_uniq_add {varname value} {
  upvar $varname var
  lappend var $value
  set var [lsort [lsort -unique $var]]
}
# }}}
#: godel_array_add_prefix
# {{{
proc godel_array_add_prefix {arrname prefix} {
  upvar $arrname arr
  foreach {key value} [array get arr] {
    set arr($prefix,$key) $value
    unset arr($key)
  }
}
# }}}
#: godel_write_list_to_file
# {{{
proc godel_write_list_to_file {ilist ofile} {
  set fout [open $ofile w]
  foreach i $ilist {
    puts $fout $i
  }
  close $fout
}
# }}}
#: split_by
# {{{
proc split_by {content delimiter} {
# Remove leading space
      regsub -all {^\s+} $line "" line
# Replace space with #
      regsub -all {\s+} $line "#" line
      set c [split $line #]
      return $c
}
# }}}
#: godel_split_by_space
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
#: godel_histogram
# {{{
proc godel_histogram {} {
  godel_get_current_value syn nvp_wns.dat
  godel_histogram2_script "nvp_wns.dat" "nvp_wns.png" "NVP/WNS"
  catch {exec tcsh -fc "gnuplot -c histogram.plt"}
}

proc godel_get_current_value {stage ofile} {
  puts [pwd]
  set fout [open $ofile w]
  set flist [lsort [glob *]]
  foreach f $flist {
    if {[file type $f] == "directory"} {
# get vars(current_version)
      godel_array_reset vars
      if [file exist $f/$stage/.godel/vars.tcl] {
        source $f/$stage/.godel/vars.tcl
        if [info exist vars(current_version)] {
# get all vars values
          source $f/$stage/$vars(current_version)/.godel/vars.tcl
          puts $fout "$f $vars(nvp) $vars(wns)"
        }
      }
    }
  }

  close $fout
}
# }}}
#: godel_trend_data
# {{{
proc godel_trend_data {key} {

  set fout [open "trend.dat" w]

  set flist [lsort [glob *]]
  foreach f $flist {
    if {[file type $f] == "directory"} {
      source $f/.godel/vars.tcl
      puts $fout "$f $vars($key)"
    }
  }

  close $fout
}
# }}}
#: godel_split_by
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
#: godel_get_vars
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

proc todo_set {args} {
  set todopath [gvars todo where]
# Go to todo directory
  cd $todopath

  set gpage [lindex $args 0]
  set attr  [lindex $args 1]
  set value [lindex $args 2]

  set env(GODEL_META_FILE) ./localmeta.tcl
  source ./localmeta.tcl
# Create localmeta.tcl/indexing.tcl
  #exec genmeta.tcl > localmeta.tcl
  #meta_indexing indexing.tcl

# Set title/keywords
  gset $gpage $attr $value
  #gset $todonum g:keywords $keywords
}

proc todo_create {args} {
  set todopath [gvars todo where]
  # -k (keyword)
  set opt(-k) 0
  set idx [lsearch $args {-k}]
  if {$idx != "-1"} {
    set keywords [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-k) 1
  }
  # -p (priority)
  set opt(-p) 0
  set idx [lsearch $args {-p}]
  if {$idx != "-1"} {
    set priority [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-p) 1
  }

  set title [lindex $args 0]

# Create todo directory
  set todonum [clock format [clock seconds] -format {%Y-%m-%d_%H-%M_%S}]
  puts $todonum
  file mkdir $todopath/$todonum
  cd $todopath/$todonum
  godel_draw todo

# Go to todo directory
  cd $todopath

  set env(GODEL_META_FILE) ./localmeta.tcl
  godel_array_reset meta
# Create localmeta.tcl/indexing.tcl
  exec genmeta.tcl > .godel/lmeta.tcl
  source .godel/lmeta.tcl
  #meta_indexing indexing.tcl
  #mindex .godel/lmeta.tcl

# Set title/keywords
  gset $todonum title $title
  if ![info exist keywords] {
    set keywords ""
  }
  gset $todonum g:keywords $keywords

  if ![info exist priority] {
    set priority 1
  }
  if ![info exist done] {
    set done 0
  }
  gset $todonum priority   $priority
  gset $todonum done       $done
  
# Create localmeta.tcl/indexing.tcl
  exec genmeta.tcl > .godel/lmeta.tcl
  #exec lind.tcl
  mindex .godel/lmeta.tcl
}

# todo_list, tlist
# {{{
proc todo_list {args} {
  global env
  set todo_path [gvars todo where]
  godel_array_reset meta
  source $todo_path/.godel/lmeta.tcl
  source $todo_path/.godel/indexing.tcl

  set ilist [list]
  foreach i [lsort [array name meta *,where]] {
    regsub ",where" $i "" i
    lappend ilist $i
  }

  set found_names [list]

  set keywords $args

# Search pagelist
  foreach i $ilist {
    set found 1
# Is it match with keyword
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
    if {[llength $found_names] > 1} {
      foreach i $found_names {
        set done [gvars $i done]
        if {$done == ""} {set done 0}
        if {$done == "NA"} {set done 0}
        if {!$done} {
          if [info exist meta($i,keywords)] {
            set pagename [gvars $i g:pagename]
            set priority [gvars $i priority]
            set keywords [gvars $i g:keywords]
            set title    [gvars $i title]
            #puts stderr  [format "%s (%s) %s. (%s)" $pagename $priority $title $keywords]
            lappend dlist [list $pagename $priority $keywords $title]
          } else {
          }
        } else {
          continue
        }
      }

      set klist [lsort -index 1 $dlist]
      foreach i $klist {
        set pagename [lindex $i 0]
        set priority [lindex $i 1]
        set keywords [lindex $i 2]
        set title    [lindex $i 3]
        set txt  [format "%s (%25s) (%s) (%s)" $pagename $keywords $priority $title]
        if {$priority == "1"} {
          puts stderr "\033\[0;35m$txt\033\[0m"
        } elseif {$priority == "2"} {
          puts stderr "\033\[0;36m$txt\033\[0m"
        } else {
          puts stderr $txt
        }
      }
      #puts stderr $dlist
# If only 1 page found, cd to it
    } else {
      puts "cd $meta($found_names,where)"
      #puts "found $found_names"
    }
  }

} ;# todo_list end
# }}}
#@>gget
# {{{
proc gget {pagename args} {
  global env
  upvar meta meta
  if ![info exist meta] {
    foreach i $env(GODEL_META_SCOPE) { mload $i }
  }

# source user plugin
  if [info exist env(GODEL_USER_PLUGIN)] {
    set flist [glob -nocomplain $env(GODEL_USER_PLUGIN)/*.tcl]
    foreach f $flist { source $f }
  }

  #source $env(GODEL_META_FILE)
  foreach i $env(GODEL_META_SCOPE) { mload $i }
  #puts $meta($pagename,where)
  if {$pagename == "."} {
    set meta(.,where) .
  }
  source $meta($pagename,where)/.godel/vars.tcl
  set where $meta($pagename,where)

  if [file exist $meta($pagename,where)/.godel/proc.tcl] {
    source $meta($pagename,where)/.godel/proc.tcl
  }
  if {$args == ""} {
    help
    #foreach i $vars(gget:list) {
    #  puts [format "%-30s : %s" [lindex $i 0] [lindex $i 1]]
    #}
  } else {
    {*}$args
  }
}
# }}}

# and_hit
proc and_hit {patterns target} {
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
proc mscope {args} {
  # -w
  set opt(-w) 0
  set idx [lsearch $args {-w}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-w) 1
  }

  if {$opt(-w)} {
    puts $args
  } else {
    puts "$args default"
  }
}
# mload
proc mload {args} {
  global env env
  upvar meta meta
  # -w overwrite
  set opt(-w) 0
  set idx [lsearch $args {-w}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-w) 1
  }
  # -g global
  set opt(-g) 0
  set idx [lsearch $args {-g}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-g) 1
  }
  # -a
  #set opt(-a) 0
  #set idx [lsearch $args {-a}]
  #if {$idx != "-1"} {
  #  set args [lreplace $args $idx $idx]
  #  set opt(-a) 1
  #}

  proc get_where {name} {
    global env env
    source $env(GODEL_META_FILE)
    if {$name == "default"} {
      return "default"
    } else {
      return $meta($name,where)
    }
  }
  set page $args
# where
  set page_where [get_where $page]

  if {$opt(-w)} {
    godel_array_reset meta
  } else {
    if {$opt(-g)} {
      source $env(GODEL_META_CENTER)/indexing.tcl
    }
  }

# source 
  if {$page_where == "default"} {
    source $env(GODEL_META_FILE)
    source $env(GODEL_META_CENTER)/indexing.tcl
  } else {
    source $page_where/.godel/indexing.tcl
  }
}
# gvars
# {{{
proc gvars {args} {
  global env env
  upvar meta meta
# source user plugin
  if [info exist env(GODEL_USER_PLUGIN)] {
    set flist [glob -nocomplain $env(GODEL_USER_PLUGIN)/*.tcl]
    foreach f $flist { source $f }
  }
  # -l (local)
  set opt(-l) 0
  set idx [lsearch $args {-l}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-l) 1
  }
  if ![info exist meta] {
    if $opt(-l) {
      source .godel/lmeta.tcl
    } else {
      foreach i $env(GODEL_META_SCOPE) { mload $i }
    }
  }
  # -k (keyword)
  set opt(-k) 0
  set idx [lsearch $args {-k}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-k) 1
  }
  # -d (delete)
  set opt(-d) 0
  set idx [lsearch $args {-d}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-d) 1
  }
  # -t (tvars)
  set opt(-t) 0
  set idx [lsearch $args {-t}]
  if {$idx != "-1"} {
    set tvar_name [lindex $args [expr $idx + 1]]
    set args   [lreplace $args $idx [expr $idx + 1]]
    set opt(-t) 1
  }
  
  set pagename [lindex $args 0]
  if {$pagename == ""} {
    source .godel/vars.tcl
    parray vars
    return
  } elseif {$pagename == "."} {
    #source .godel/vars.tcl
    set meta($pagename,where) .
  }
  set args [lreplace $args 0 0]
  set vname    $args

  #meta_load tcl_cmds -a
  #meta_load tcl_cmds -w
  #foreach f $env(GODEL_META_FILE) {
  #  source $f
  #}
  if [info exist meta($pagename,where)] {
  } else {
    #puts "Error: meta($pagename,where) not exist..."
    return
  }
  source $meta($pagename,where)/.godel/vars.tcl
  set where $meta($pagename,where)
  set vars(where) $where

  set vlist ""
# if no key specified, display all keys and values
  if {$vname == ""} {
    parray vars
    return
  } else {
# if -k enable, display all matched keys
    if {$opt(-k)} {
      foreach name [lsort [array names vars]] {
        if [and_hit $vname $name] {
          puts [format "%-20s = %s" $name $vars($name)]
          lappend klist [list $name $vars($name)]
          set vlist [concat $vlist $vars($name)]
        }
      }
# return value of query key
    } else {
      if [info exist vars($vname)] {
        set vlist $vars($vname)
        #return $vars($vname)
      } else {
        return NA
      }
    }
  }

  if $opt(-d) {
    if [info exist klist] {
      foreach k $klist {
        set key [lindex $k 0]
        unset vars($key)
      }
      unset vars(where)
      godel_array_save vars $meta($pagename,where)/.godel/vars.tcl
    }
  }
  
  if $opt(-t) {
    eval "gset tvars $tvar_name \"$vlist\""
  }
  #fullpath $vlist

  return $vlist
}
# }}}
# gset
# {{{
proc gset {args} {
  upvar env env
  upvar meta meta
  # -l (local)
# {{{
  set opt(-l) 0
  set idx [lsearch $args {-l}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-l) 1
  }
# }}}

  if {$opt(-l)} {
    if [file exist .godel/indexing.tcl] {
      source .godel/indexing.tcl
    } else {
      puts "Error: Not exist... .godel/indexing.tcl "
    }
  }

  if ![info exist meta] {
    foreach i $env(GODEL_META_SCOPE) { mload $i }
  }

  # -p (path)
  set opt(-p) 0
  set idx [lsearch $args {-p}]
  if {$idx != "-1"} {
    set path [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-p) 1
  }
  # -f (file)
  set opt(-f) 0
  set idx [lsearch $args {-f}]
  if {$idx != "-1"} {
    set infile [lindex $args [expr $idx + 1]]
    set args [lreplace $args $idx [expr $idx + 1]]
    set opt(-f) 1
  }

  set pagename [lindex $args 0]
  if {$pagename == "."} {
    set meta($pagename,where) .
  }
  source $meta($pagename,where)/.godel/vars.tcl
  set where $meta($pagename,where)
  
  if {$opt(-p)} {
    set key      [file tail $path]
    set value    $path
    set vars($key) $value
  } elseif {$opt(-f)} {
    set ilist [read_file_ret_list $infile]
    foreach i $ilist {
      set key      [file tail $i]
      set value    $i
      set vars($key) $value
    }
  } else {
    set key      [lindex $args 1]
    set value    [lindex $args 2]
    set vars($key) $value
  }

  godel_array_save vars $where/.godel/vars.tcl

}
# }}}
#: godel_init_vars
# {{{
proc godel_init_vars {key value} {
  upvar vars vars
  if [info exist vars($key)] {
    #return $vars($key)
    return
  } else {
    set vars($key) $value
  }
}
# }}}
#: godel_puts
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
#: godel_version_trend_chart
# {{{
proc godel_version_trend_chart {} {
# Executed in Version Level
  global env
  #source $env(DQI_ROOT)/custom/trend.tcl
  set index2_files [glob */index2.htm]

  foreach i $index2_files {
    set module [file dirname $i]
    if [info exist vars(trend,dc,$module)] {
      #puts $module
      set fout [open $module/.tmp w]
      cd $module
# source .godel/vars.tcl of each version
      foreach ver $vars(trend,dc,$module) {
        #puts $ver
        source "$ver/.godel/vars.tcl"
# write to .tmp
        puts $fout "$ver $vars(wns)"
        gen_trend_plt ofile title corner
      }
      close $fout
      catch {exec tcsh -fc "gnuplot -c trend.plt"}
      cd ..
    }
  }
}
# }}}
#: godel_array_save
# {{{
proc godel_array_save {aname ofile} {
  upvar $aname arr
  #parray arr
  if {[file dirname $ofile] != "."} {
    file mkdir [file dirname $ofile]
  }
  set fout [open $ofile w]
    set keys [lsort [array name arr]]
    foreach key $keys {
      regsub -all {"} $arr($key) {\\"}  newvalue
      regsub -all {\[} $newvalue {\\[}  newvalue
      regsub -all {\]} $newvalue {\\]}  newvalue
      puts $fout [format "set %-40s \"%s\"" [set aname]($key) $newvalue]
    }
  close $fout
}
# }}}
#: godel_array_reset
# {{{
proc godel_array_reset {arrname} {
  upvar $arrname arr
  array unset arr *
}
# }}}
#: godel_array_rm
# {{{
proc godel_array_rm {arrname pattern} {
  upvar $arrname arr
  foreach {key value} [array get arr $pattern] {
    unset arr($key)
  }
}
# }}}
#: gnuplot_trend1_script
# {{{
proc gnuplot_trend1_script {idata chart_name ofile} {

  if [file exist $chart_name.tcl] {
    source $chart_name.tcl
  } else {
    set chart($chart_name,title)    $chart_name
    set chart($chart_name,label_x)  "version" 
    set chart($chart_name,label_y)  "nvp" 
    set chart($chart_name,yrange)   "0:" 
  }

  set fout [open "$chart_name.plt" w]
    puts $fout "set term png truecolor medium size 800,200"
    puts $fout "set output \"$ofile\""
    puts $fout "set xlabel \"$chart($chart_name,label_x)\""
    puts $fout "set ylabel \"$chart($chart_name,label_y)\""
    puts $fout "set title  \"$chart($chart_name,title)\""
    puts $fout "set grid"
    puts $fout "set yrange \[$chart($chart_name,yrange)\]"
    puts $fout "plot \"$idata\" using 0:2:xticlabels(1) with linespoints lc 3 lw 2 pt 7 ps 1 notitle, \\"
    puts $fout "     \"\"                     using 0:2:2 with labels center offset 0,1 notitle"
  close $fout

  godel_array_save chart $chart_name.tcl
}
# }}}
#: godel_trend2_script
# {{{
proc godel_trend2_script {idata chart_name ofile} {
  # Use .godel/vars.tcl to send vars(chart,*) this procedure
  if [file exist .godel/vars.tcl] {source .godel/vars.tcl}

  if ![info exist vars(chart,$chart_name,title)]    { set vars(chart,$chart_name,title)    "No title" }
  if ![info exist vars(chart,$chart_name,label_x)]  { set vars(chart,$chart_name,label_x) "WW" }
  if ![info exist vars(chart,$chart_name,label_y)]  { set vars(chart,$chart_name,label_y) "NVP" }
  if ![info exist vars(chart,$chart_name,yrange)]   { set vars(chart,$chart_name,yrange)   "0:" }
  if ![info exist vars(chart,$chart_name,line_title1)]  { set vars(chart,$chart_name,line_title1) "line1" }
  if ![info exist vars(chart,$chart_name,line_title2)]  { set vars(chart,$chart_name,line_title2) "line2" }

  set fout [open "$chart_name.plt" w]
    puts $fout "set term png truecolor medium size 1000,250"
    puts $fout "set output \"$ofile\""
    puts $fout "set xlabel \"$vars(chart,$chart_name,label_x)\""
    puts $fout "set ylabel \"$vars(chart,$chart_name,label_y)\""
    puts $fout "set title  \"$vars(chart,$chart_name,title)\""
    puts $fout "set grid"
    puts $fout "set yrange \[$vars(chart,$chart_name,yrange)\]"
    puts $fout "plot \"$idata\" using 0:2:xticlabels(1) with linespoints lc 3 lw 2 pt 7 ps 1 title \"$vars(chart,$chart_name,line_title1)\", \\"
    puts $fout "     \"$idata\" using 0:2:2 with labels center offset 0,1 notitle, \\"
    puts $fout "     \"$idata\" using 0:3:xticlabels(1) with linespoints lc 4 lw 2 pt 7 ps 1 title \"$vars(chart,$chart_name,line_title2)\", \\"
    puts $fout "     \"$idata\" using 0:3:3 with labels center offset 0,1 notitle"
  close $fout

  godel_array_save vars .godel/vars.tcl
}
# }}}
#: godel_histogram2_script
# {{{
proc godel_histogram2_script {indata ograph title} {
  upvar vars vars

  if ![info exist vars(histogram2,title)]    { set vars(histogram2,title)    "No title" }
  if ![info exist vars(histogram2,label_y1)] { set vars(histogram2,label_y1) "NVP" }
  if ![info exist vars(histogram2,label_y2)] { set vars(histogram2,label_y2) "WNS" }
  if ![info exist vars(histogram2,yrange)]   { set vars(histogram2,yrange)   "0:" }

  set fout [open "histogram2.plt" w]
    puts $fout "set title \"$title\""
    puts $fout "set term png truecolor size 1000,400 medium"
    puts $fout "set output \"$ograph\""
    puts $fout "set style data histogram"
    puts $fout "set style histogram clustered gap 1"
    puts $fout "set style fill transparent solid 0.4 border"
    puts $fout "set grid"
    puts $fout "set size 1,1"
    puts $fout "set ylabel  \"$vars(histogram2,label_y1)\""
    puts $fout "set y2label \"$vars(histogram2,label_y2)\""
    puts $fout "set ytics nomirror"
    puts $fout "set y2tics"
    puts $fout "set yrange \[$vars(histogram2,yrange)\]"
    puts $fout "plot \"$indata\" using 2:xticlabels(1) axis x1y1  title \"$vars(histogram2,label_y1)\", \\"
    puts $fout "     \"$indata\" using 0:2:2 with labels center offset -3,1 notitle, \\"
    puts $fout "     \"$indata\" using 3:xticlabels(1) axis x1y2  title \"$vars(histogram2,label_y2)\", \\"
    puts $fout "     \"$indata\" using 0:3:3 with labels center offset  3,1 axis x1y2 notitle"
   close $fout

}
# }}}
#: godel_histogram_line_script
# {{{
proc godel_histogram_line_script {indata chart_name ograph} {
# indata    : input data
# chart_name: chart name
# ograph    : file name of the generated png file
  # Use .godel/vars.tcl to send vars(chart,*) this procedure
  if [file exist chart.tcl] {source chart.tcl}

  if ![info exist vars(chart,$chart_name,title)]       { set vars(chart,$chart_name,title)       "No title" }
  if ![info exist vars(chart,$chart_name,label_histo)] { set vars(chart,$chart_name,label_histo) "NVP" }
  if ![info exist vars(chart,$chart_name,label_line)]  { set vars(chart,$chart_name,label_line)  "WNS" }
  if ![info exist vars(chart,$chart_name,yrange)]      { set vars(chart,$chart_name,yrange)      "0:" }
  if ![info exist vars(chart,$chart_name,y2range)]     { set vars(chart,$chart_name,y2range)     "0:" }

  set fout [open "$chart_name.plt" w]
    #puts $fout "set title \"$vars(chart,$chart_name,title)\""
    puts $fout "set term png truecolor size 800,200 medium"
    puts $fout "set output \"$ograph\""
    puts $fout "set style data histogram"
    puts $fout "set style histogram clustered gap 1"
    puts $fout "set style fill transparent solid 0.4 border"
    puts $fout "set grid"
    puts $fout "set size 1,1"
    puts $fout "set ylabel  \"$vars(chart,$chart_name,label_histo)\""
    puts $fout "set y2label \"$vars(chart,$chart_name,label_line)\""
    puts $fout "set ytics nomirror"
    puts $fout "set y2tics"
    puts $fout "set yrange  \[$vars(chart,$chart_name,yrange)\]"
    puts $fout "set y2range \[$vars(chart,$chart_name,y2range)\]"
    puts $fout "plot \"$indata\" using 0:2:4:xticlabels(1) with boxes lc variable axis x1y1  title \"$vars(chart,$chart_name,label_histo)\", \\"
    puts $fout "     \"$indata\" using 0:2:2 with labels center offset -3,1 notitle, \\"
    puts $fout "     \"$indata\" using 3:xticlabels(1) with linespoints lc 3 lw 2 pt 7 ps 1 axis x1y2  title \"$vars(chart,$chart_name,label_line)\", \\"
    puts $fout "     \"$indata\" using 0:3:(sprintf(\"-%d\",\$\$3)) with labels center offset -0.5,2 axis x1y2 notitle lc 3"

   close $fout

   godel_array_save chart chart.tcl
}
# }}}
#: godel_histogram_color_script
# {{{
proc godel_histogram_color_script {indata chart_name ograph} {

  if [file exist .chart/$chart_name.tcl] {
    source .chart/$chart_name.tcl
  } else {
    set chart(histogram_color,title)       $chart_name
    set chart(histogram_color,label_x)     "Corners"
    set chart(histogram_color,label_y)      "NVP"
    set chart(histogram_color,yrange)      "0:"
  }

  set fout [open ".chart/$chart_name.plt" w]
    puts $fout "set title \"$chart(histogram_color,title)\""
    puts $fout "set term png truecolor size 1000,200 medium"
    puts $fout "set output \"$ograph\""
    puts $fout "set style data histogram"
    puts $fout "set style histogram clustered gap 1"
    puts $fout "set style fill solid 0.4 border"
    puts $fout "set grid"
    puts $fout "set xlabel \"$chart(histogram_color,label_x)\""
    puts $fout "set ylabel \"$chart(histogram_color,label_y)\""
    puts $fout "set yrange \[$chart(histogram_color,yrange)\]"
    puts $fout "set xtics offset character -10, 0, 0"
    puts $fout "plot \"$indata\" using 0:2:3:xticlabels(1)  with boxes lc variable notitle, \\"
    puts $fout "     \"$indata\" using 0:2:2 with labels center offset 0,1 notitle"
   close $fout

  godel_array_save chart .chart/$chart_name.tcl
}
# }}}
#: lshift
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
#: godel_shift
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
#: godel_get_column
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
#: plist
# {{{
proc plist {ll} {
  #foreach i $ll {
  #  puts $i
  #}
  foreach i [lsort $ll] {
    puts $i
  }
}
# }}}
#: pcollection_list
# {{{
proc pcollection_list {ll} {
  foreach_in_collection i $ll {
    puts [get_attribute $i full_name]
  }
}
# }}}

#@> Path Summary
#:@=godel_ps
# {{{
proc godel_ps {corner eda {infile NA}} {
  #upvar vars vars
  upvar curs curs

  if [file exist .godel/vars.tcl] {source .godel/vars.tcl}

# Check file exist
  if {$infile == "NA"} {
    set infile vios.rpt
  }
  if [file exist $infile] {
  } else {
    puts "Error: Not exist.. $infile"
    return
  }

# Extraction values from vios.rpt and store in vars
  if {$eda == "cdn"} {
    godel_ps_report_constraint_cdn $infile
    godel_ps_path_categorizing
    godel_ps_attach_corner_name $corner
    godel_ps_attach_skew        $corner
    godel_ps_attach_clock_edge
    godel_ps_gen_summary        $corner "path_summary.rpt"
  } else {
    godel_ps_report_constraint $infile
    godel_ps_path_categorizing
    godel_ps_attach_corner_name $corner
    godel_ps_attach_skew        $corner
    godel_ps_attach_clock_edge
    godel_ps_gen_summary        $corner "path_summary.rpt"
  }

  godel_array_rm curs *,all
  godel_array_save curs cc.tcl
  godel_array_save vars .godel/vars.tcl
}
# }}}
#: godel_ps_gen_summary
# {{{
proc godel_ps_gen_summary {corner ofile} {
  upvar vars vars
  upvar 1 curs curs
  if [file exist .godel/vars.tcl] {
    source ./.godel/vars.tcl
  }
  #puts  $owner(TOP,PUBCP,aon_clk_wcdma_pubcp)
  
  file mkdir split/$corner
  set fout  [open "$ofile" w]
  #set fowner [open "./owner.tcl" w]
  set count 0
  for {set i 1} {$i <= $curs(size)} {incr i} {
      set scat $curs($i,startpoint,cat)
      set ecat $curs($i,endpoint,cat)
      set eclk $curs($i,to_clock)
      set g    $curs($i,path_group)
      incr count
# Create a new array `att' telling you that for a scat,ecat,eclk triplet, how many id are there.
      lappend att($scat,$ecat,$eclk) $count
  }
  puts $fout "# Total NVP: $curs(size)"
  #puts $fout2 "# Total NVP: $curs(size)"
# Iterate each category (TOP,GPU,PUB0...)
  set from_list "$curs(cat_list) IN"
  set to_list   "$curs(cat_list) OUT"
  # From
  set summ_rows [list]
  foreach i $from_list {
    # To
    foreach j $to_list {
      # Collect IDs from a for example: TOP,PUB0,abcclk
      set mm [array names att $i,$j,*]
      foreach m $mm {
        regsub "$i,$j," $m "" pgroup
        regsub -all "\/" $pgroup "-" name
        regsub -all {'}  $name {_neg}    name
        set ids $att($m)
        set nvp 0; # this will be set in sort_by_slack proc
        set ids_wns [godel_ps_sort_by_slack curs $ids]
        set wns [lindex [lindex $ids_wns 1] 0]
        if {$wns == 0} {
        } else {
          set worst_id [lindex [lindex $ids_wns 0] 0]
          set lau_edge $curs($worst_id,launch_edge)
          set cap_edge $curs($worst_id,capture_edge)
          set skew     $curs($worst_id,skew)
          set lau_clock $curs($worst_id,from_clock)
          set fname "split/$corner/${i}_${j}_$name.rpt"
          if [info exist owner($i,$j,$pgroup)] {
            set who $owner($i,$j,$pgroup)
          } else {
            set who "NA"
            #puts $fowner "set owner($i,$j,$pgroup) \"\""
          }
          #puts        [format "%-8s %-8s %-8s %-7.f %-6d %-6d %-40s" $i $j $who $wns $nvp $skew $pgroup]
          #puts        [format "%-8s %-8s %-7.f %-6.f %-6.f %-40s" $i $j $wns $nvp $skew $pgroup]
          #lappend summ_rows [format "%-6s %-6s %-20s %-7.f %-6d %-6d %-37s %-37s %-5d %-5d %s" $i $j $who $wns $nvp $skew $lau_clock $pgroup $lau_edge $cap_edge $fname]
          lappend summ_rows [format "%-6s %-6s %-7.f %-6.f %-6.f %-37s %-37s %-5.f %-5.f %s" $i $j $wns $nvp $skew $lau_clock $pgroup $lau_edge $cap_edge $fname]
          godel_ps_write_by_id  curs $fname  [lindex $ids_wns 0]
          #write_by_id2 curs $fname2 [lindex $ids_wns 0]
        }
      }
    }
  }
  # Sort by slack
  set cc [lsort -index 2 -integer $summ_rows]
  set wns [lindex [lindex $cc 0] 2]
  #puts $fout [format "# %-6s %-6s %-18s %-7s %-6s %-6s %-40s %-40s %-5s %-5s" From To Owner WNS NVP Skew LauClk CapClk LauEdge CapEdge]
  puts $fout [format "# %-6s %-6s %-7s %-6s %-6s %-40s %-40s %-5s %-5s" From To WNS NVP Skew LauClk CapClk LauEdge CapEdge]
  foreach t $curs(cat_list) {
    puts $fout "# $t"
    foreach c $cc {
      set index0 [lindex $c 0]
      set index1 [lindex $c 1]
      set index3 [lindex $c 3]
      set index7 [lindex $c 7]
      if {$index1 == $t && $index1 != "OUT" && $index0 != "IN"} {
        puts $fout $c
        if [info exist owner($index0,$index1,$index7)] {
        } else {
          #puts $fowner "# $index3"
          #puts $fowner "set owner($index0,$index1,$index7) \"\""
        }
      }
    }
  }
  puts $fout "# IN"
  foreach c $cc {
    set index0 [lindex $c 0]
    set index1 [lindex $c 1]
    set index3 [lindex $c 3]
    set index7 [lindex $c 7]
    if {$index0 == "IN"} {
      puts $fout $c
      if [info exist owner($index0,$index1,$index7)] {
      } else {
        #puts $fowner "# $index3"
        #puts $fowner "set owner($index0,$index1,$index7) \"\""
      }
    }
  }
  puts $fout "# OUT"
  foreach c $cc {
    set index0 [lindex $c 0]
    set index1 [lindex $c 1]
    set index3 [lindex $c 3]
    set index7 [lindex $c 7]
    if {$index1 == "OUT"} {
      puts $fout $c
      if [info exist owner($index0,$index1,$index7)] {
      } else {
        #puts $fowner "# $index3"
        #puts $fowner "set owner($index0,$index1,$index7) \"\""
      }
    }
  }
  close $fout
  #close $fowner
  set vars(nvp) $curs(size)
  set vars(wns) $wns
  godel_array_save vars .godel/vars.tcl
}
# }}}
#: godel_ps_attach_clock_edge
# {{{
proc godel_ps_attach_clock_edge {} {
  upvar curs curs
  for {set i 1} {$i <= $curs(size)} {incr i} {
    #set from_clock $curs($i,from_clock)
    #set to_clock   $curs($i,to_clock)
    #regsub -all {'} $from_clock {} from_clock
    #regsub -all {'} $to_clock {} to_clock
    #set flag_launch  0
    #set flag_capture 0
    #foreach line $curs($i,all) {
    #  regsub -all {'} $line {} line
    #  if {!$flag_launch} {
    #    if {[regexp "clock $from_clock ..... edge.\\s\+(\\S\+)" $line whole matched]} {
    #        set curs($i,launch_edge) $matched
    #        set flag_launch 1
    #    }
    #  } elseif {!$flag_capture} {
    #    if {[regexp "clock $to_clock ..... edge.\\s\+(\\S\+)" $line whole matched]} {
    #        set curs($i,capture_edge) $matched
    #        set flag_capture 1
    #    }
    #  }
    #}
    #if [info exist curs($i,launch_edge)] {
    #} else {
    #  puts "$i no launch_edge...set it to 0"
      set curs($i,launch_edge) 0
    #}
    #if [info exist curs($i,capture_edge)] {
    #} else {
    #  puts "$i no capture_edge...set it to 0"
      set curs($i,capture_edge) 0
    #}
  }
}
# dio_report_constraint
# redirect ./reports/gba.report_constraint.rpt           {report_constraint -max_delay -all_violators -nosplit}
# redirect ./reports/verbose.gba.report_constraint.rpt   {report_constraint -max_delay -all_violators -nosplit -verbose}
# redirect ./reports/pba.report_timing.rpt             {report_timing     -pba_mode exhaustive -crosstalk_delta -voltage -slack_lesser_than 0 -derate -delay max -input -net -max 1000 -nosplit}
# redirect ./reports/pba.report_constraint.rpt         {report_constraint -max_delay -all_violators -pba_mode exhaustive -nosplit }
# 
# }}}
#: godel_ps_attach_skew
# {{{
proc godel_ps_attach_skew {corner} {
  upvar curs curs
  for {set i 1} {$i <= $curs(size)} {incr i} {
    if [info exist curs($i,capture_clock_latency)] {  } else { set curs($i,capture_clock_latency) 0}
    if [info exist curs($i,launch_clock_latency)] {  } else {  set curs($i,launch_clock_latency) 0}
    set curs($i,skew) [expr $curs($i,capture_clock_latency) - $curs($i,launch_clock_latency)]
  }
}
# }}}
#: godel_ps_attach_corner_name
# {{{
proc godel_ps_attach_corner_name {corner} {
  upvar curs curs
  for {set i 1} {$i <= $curs(size)} {incr i} {
    set curs($i,corner) $corner
  }
}
# }}}
#: godel_ps_path_categorizing
# {{{
proc godel_ps_path_categorizing {} {
  upvar curs curs
  for {set i 1} {$i <= $curs(size)} {incr i} {
# startpoint
    set inst $curs($i,startpoint)
    set cat [godel_ps_inst_catgorize $curs($i,startpoint)]
    if {$cat == "TOP"} {
      if [info exist curs($inst,inport)] {
        set curs($i,startpoint,cat) IN
      } else {
        set curs($i,startpoint,cat) TOP
      }
    } else {
        set curs($i,startpoint,cat) $cat
    }
# endpoint
    set inst $curs($i,endpoint)
    set cat [godel_ps_inst_catgorize $curs($i,endpoint)]
    if {$cat == "TOP"} {
      if [info exist curs($inst,outport)] {
        set curs($i,endpoint,cat) OUT
      } else {
        set curs($i,endpoint,cat) TOP
      }
    } else {
        set curs($i,endpoint,cat) $cat
    }
  }
  set curs(cat_list) "TOP "
}
# }}}
#: godel_ps_report_constraint
# {{{
proc godel_ps_report_constraint {fname} {
  upvar curs curs
  #split_by AllVio_ver.rpt
  godel_split_by $fname "Startpoint:"
  set count $curs(size)
  #puts "Path count: $count"
  set process_no 0
  # foreach path
  for {set i 1} {$i <= $count} {incr i} {
    if {[expr $i%100]} {
    } else {
      incr process_no
      puts $process_no
    }
    set endpoint na
    set startpoint na
    set startlist ""
    set endlist ""
    # Puts path into ilist
    set ilist $curs($i,all)
    #set curs($i,corner) $corner
    set previous ""
    set flag_clock_network_delay 0
    # Iterate lines in a path
    while {[llength $ilist]} {
      set path_line [godel_shift ilist]
      # startpoint
      if {[regexp {Startpoint: (\S+)} $path_line whole matched]}      {
        if [regexp {input port} $path_line] {
          set curs($matched,inport) 1
        }
        set curs($i,startpoint,nopin) $matched 
        set startpoint $matched
        # remove []
        regsub -all {\[} $startpoint {\\[} startpoint
        regsub -all {\]} $startpoint {\\]} startpoint
        # clock at 1st line
        if [regexp {(\S+)\)} $path_line] {
          regexp {(\S+)\)} $path_line whole from_clock
        # clock at 2nd line
        } else {
          set path_line [godel_shift ilist]
          regexp {(\S+)\)} $path_line whole from_clock
          if [regexp {input port} $path_line] {
            set curs($matched,inport) 1
          }
        }
# from_clock
        set curs($i,from_clock) $from_clock 
      }
# endpoint
      if {[regexp {Endpoint: (\S+)} $path_line whole matched]}        {
        if [regexp {output port} $path_line] {
          set curs($matched,outport) 1
        }
        set curs($i,endpoint,nopin)   $matched 
        if [regexp {(\S+)\)} $path_line] {
          regexp {(\S+)\)} $path_line whole to_clock
        } else {
          set path_line [godel_shift ilist]
          regexp {(\S+)\)} $path_line whole to_clock
          if [regexp {output port} $path_line] {
            set curs($matched,outport) 1
          }
        }
# to_clock
        set curs($i,to_clock) $to_clock 
      }
# common_pin
      if {[regexp {Last common pin: (\S+)$} $path_line whole matched]} { set curs($i,common_pin) $matched }
# path_group
      if {[regexp {Path Group: (\S+)$} $path_line whole matched]}      { set curs($i,path_group) $matched }
# path_type
      if {[regexp {Path Type: (\S+)} $path_line whole matched]}       { set curs($i,path_type)  $matched }
# launch_clock_latency
      if {[regexp {clock network delay \(\w+\)\s+(\S+)} $path_line whole matched]} { 
        if {$flag_clock_network_delay == 0} {
          set curs($i,launch_clock_latency)  $matched 
          set flag_clock_network_delay 1
        } else {
          set curs($i,capture_clock_latency)  $matched 
          set flag_clock_network_delay 0
        }
      }
# cppr
      if {[regexp {clock reconvergence pessimism         \s+(\S+) } $path_line whole matched]}  { set curs($i,cppr)  $matched }
# uncertainty
      if {[regexp {uncertainty\s+(\S+) } $path_line whole matched]}  { set curs($i,uncertainty)  $matched }
# slack
      if {[regexp {slack \(.*\)\s+(\S+)} $path_line whole matched]}  { set curs($i,slack)  $matched }
      
      if [regexp "  $startpoint" $path_line] {
        lappend startlist [godel_get_column $path_line 0]
      }
      if [regexp {data arrival time} $path_line] {
        lappend endlist [godel_get_column $previous 0]
      }
# startpoint      
      set curs($i,startpoint) [lindex $startlist 0]
# endpoint
      set curs($i,endpoint)   [lindex $endlist   0]
      set previous $path_line
    }
  }
  #puts $curs(size)
}
# }}}
#: godel_ps_report_constraint_cdn
# {{{
proc godel_ps_report_constraint_cdn {fname} {
  upvar curs curs
  #split_by AllVio_ver.rpt
  godel_split_by $fname "Endpoint:"
  set count $curs(size)
  #puts "Path count: $count"
  set process_no 0
  # foreach path
  for {set i 1} {$i <= $count} {incr i} {
    if {[expr $i%100]} {
    } else {
      incr process_no
      puts $process_no
    }
    set endpoint na
    set startpoint na
    set startlist ""
    set endlist ""
    # Puts path into ilist
    set ilist $curs($i,all)
    #set curs($i,corner) $corner
    set previous ""
    set flag_clock_network_delay 0
    # Iterate lines in a path
    while {[llength $ilist]} {
      set path_line [godel_shift ilist]
# endpoint
      if {[regexp {Endpoint:\s+(\S+)} $path_line whole matched]}        {
        #if [regexp {output port} $path_line] {
        #  set curs($matched,outport) 1
        #}
        regsub -all {\[} $matched {\\[} matched
        regsub -all {\]} $matched {\\]} matched
        set curs($i,endpoint)   $matched 
        #if [regexp {(\S+)\)} $path_line] {
        #  regexp {(\S+)\)} $path_line whole to_clock
        #} else {
        #  set path_line [godel_shift ilist]
        #  regexp {(\S+)\)} $path_line whole to_clock
        #  if [regexp {output port} $path_line] {
        #    set curs($matched,outport) 1
        #  }
        #}
# to_clock
        set curs($i,to_clock) coreclk
      }
      # startpoint
      if {[regexp {Beginpoint: (\S+)} $path_line whole matched]}      {
        #if [regexp {input port} $path_line] {
        #  set curs($matched,inport) 1
        #}
        regsub -all {\[} $matched {\\[} matched
        regsub -all {\]} $matched {\\]} matched
        set curs($i,startpoint) $matched 
        #set startpoint $matched
        # remove []
        #regsub -all {\[} $startpoint {\\[} startpoint
        #regsub -all {\]} $startpoint {\\]} startpoint
        ## clock at 1st line
        #if [regexp {(\S+)\)} $path_line] {
        #  regexp {(\S+)\)} $path_line whole from_clock
        ## clock at 2nd line
        #} else {
        #  set path_line [godel_shift ilist]
        #  regexp {(\S+)\)} $path_line whole from_clock
        #  if [regexp {input port} $path_line] {
        #    set curs($matched,inport) 1
        #  }
        #}
# from_clock
        set curs($i,from_clock) coreclk
      }
# common_pin
      #if {[regexp {Last common pin: (\S+)$} $path_line whole matched]} { set curs($i,common_pin) $matched }
# path_group
      if {[regexp {Path Groups:\s+(\S+)$} $path_line whole matched]}      { set curs($i,path_group) $matched }
# path_type
      #if {[regexp {Path Type: (\S+)} $path_line whole matched]}       { set curs($i,path_type)  $matched }
      set curs($i,path_type) setup
# launch_clock_latency
      if {[regexp {clock network delay \(\w+\)\s+(\S+)} $path_line whole matched]} { 
        if {$flag_clock_network_delay == 0} {
          set curs($i,launch_clock_latency)  $matched 
          set flag_clock_network_delay 1
        } else {
          set curs($i,capture_clock_latency)  $matched 
          set flag_clock_network_delay 0
        }
      }
# cppr
      if {[regexp {clock reconvergence pessimism         \s+(\S+) } $path_line whole matched]}  { set curs($i,cppr)  $matched }
# uncertainty
      if {[regexp {uncertainty\s+(\S+) } $path_line whole matched]}  { set curs($i,uncertainty)  $matched }
# slack
      if {[regexp {Slack Time\s+(-\S+)} $path_line whole matched]}  { set curs($i,slack)  $matched }
      
      #if [regexp "  $startpoint" $path_line] {
      #  lappend startlist [godel_get_column $path_line 0]
      #}
      #if [regexp {data arrival time} $path_line] {
      #  lappend endlist [godel_get_column $previous 0]
      #}
# startpoint      
      #set curs($i,startpoint) [lindex $startlist 0]
# endpoint
      #set curs($i,endpoint)   [lindex $endlist   0]
      set previous $path_line
    }
  }
  #puts $curs(size)
}
# }}}
#: godel_ps_inst_catgorize
# {{{
proc godel_ps_inst_catgorize {inst} {
  set keyinst(u_arm\/)      ARM
  set keyinst(u_usb\/)      USB
  set klist [array names keyinst *]
  set ret ""
  foreach k $klist {
    if [regexp "$k" $inst] {
      set ret $keyinst($k)
    }
  }
  if {$ret == ""} {
    return "TOP"
  } else {
    return $ret
  }
}
# }}}
#: godel_ps_sort_by_slack
# {{{
proc godel_ps_sort_by_slack {corner id} {
  upvar 1 $corner arr
  upvar nvp nvp
  set pairs [list]
  set nvp 0
# Create a pairs
  foreach i $id {
    set skew [expr abs($arr($i,skew))]
    #if {$skew > 500} {
      lappend pairs [list $i $arr($i,slack)]
      incr nvp
    #}
  }
  if {$pairs == ""} {
    set ids 0
    set slk 0
  } else {
# Sort
    set sorted_paires [lsort -index 1 -real $pairs]
# Separate them as two lists
    foreach i $sorted_paires {
      lappend ids [lindex $i 0]
      lappend slk [lindex $i 1]
    }
  }
  return [list $ids $slk]
}
# scan_max_waiver
# }}}
#: godel_ps_write_by_id
# {{{
proc godel_ps_write_by_id {corner fname id} {
  upvar 1 $corner arr
  set fout [open $fname w] 
  foreach i $id {
    puts $fout "Corner     : $arr($i,corner)"
    puts $fout "Slack      : $arr($i,slack)"
    puts $fout "Skew       : $arr($i,skew)"
    #puts $fout "CPPR       : $arr($i,cppr)"
    puts $fout "Launch     : $arr($i,from_clock)"
    puts $fout "Capture    : $arr($i,to_clock)"
    puts $fout "LauEdge    : $arr($i,launch_edge)"
    puts $fout "CapEdge    : $arr($i,capture_edge)"
    puts $fout "LauLatency : $arr($i,launch_clock_latency)"
    puts $fout "CapLatency : $arr($i,capture_clock_latency)"
    if [info exist arr($i,uncertainty)] {
        puts $fout "Uncertainty: $arr($i,uncertainty)"
    } else {
        puts $fout "Uncertainty: NA"
    }
    puts $fout ""
    puts $fout "ID        : $i"
    puts $fout "Startpoit : $arr($i,startpoint)"
    puts $fout "Endpoint  : $arr($i,endpoint)"
    puts $fout ""
    puts $fout "redirect -file k.rpt {report_timing -crosstalk_delta -derate -net -cap -tran -delay $arr($i,path_type) -path_type full_clock_expanded -nos -from $arr($i,startpoint) -to $arr($i,endpoint)}"
    puts $fout "report_timing -delay $arr($i,path_type) -nos -from $arr($i,startpoint) -to $arr($i,endpoint)"
    puts $fout ""
    foreach line $arr($i,all) {
      puts $fout $line
    }
    puts $fout ""
  }
  close $fout
}
# }}}
#: godel_ps_uniquify_endpoints
# {{{
proc godel_ps_uniquify_endpoints {cornerlist} {
  upvar vars vars
  upvar curs curs
  upvar define define
  #upvar cornerlist cornerlist
  #puts $cornerlist
  foreach code $cornerlist {
    if [catch {glob $code*/inputs/vios.rpt}] {
      puts "$code not ready"
# Remove code that are not ready
      set cornerlist [lsearch -all -inline -not -exact $cornerlist $code]
    } else {
      set f [glob $code*/inputs/vios.rpt]
      #set fullname [code2fullname $code]
      set fullname $define(pt,corner_name,$code)
# Complete a curs
      godel_ps_report_constraint $f
      godel_ps_path_categorizing
      godel_ps_attach_corner_name $fullname
      godel_ps_attach_skew $fullname
      godel_ps_attach_clock_edge
# Save `curs' content to `$code'
      array set $code [array get curs]
      unset curs
    }
  }
# Get endpoints from each modes and uniquify them
  set ilist ""
  foreach code $cornerlist {
    array set curs [array get $code]
    set ilist [concat $ilist [godel_ps_get_endpoints]]
    unset curs
  }
  set ilist [lsort -unique $ilist]
  
  set count 1
  set wst_slk 0
  set wst_corner na
  set wst_id 0
# foreach uniquified endpoint
  foreach i $ilist {
    #puts $i
    set slk ""
    set wst_slk 0
    set wst_corner na
    set wst_id 0
    # check each corners
    foreach corner $cornerlist {
      # Same endpoint could returns multiple IDs
      set id [lindex [godel_ps_get_id $corner endpoint $i] 0]
      if {$id == ""} {
      } else {
        set nn ${corner}($id,slack)
        set endp ${corner}($id,endpoint)
        set slk [set $nn]
        if {$slk <= $wst_slk} {
          set wst_slk    $slk
          set wst_corner $corner
          set wst_id     $id
        }
      }
    }
    #puts "$wst_id : $wst_slk : $wst_corner"
    #unset curs
# Create curs array
    foreach {y z} [array get $wst_corner $wst_id,*] {
      if {[regsub "$wst_id," $y "$count," y]} {
        #set array_min_func($y) $z
        set curs($y) $z
      } else {
        puts "wst_id: $wst_id"
        puts "wst_corner: $wst_corner"
        puts "Error: $y, $z"
      }
    }
    incr count
  }
  #set array_min_func(size) [incr count -1]
  set curs(size) [incr count -1]
  #path_categorizing
  set curs(cat_list) "TOP PUB0 GPU CAM PUBCP WTL VSP AP"
}
# uniq_ses
# }}}
#: godel_ps_get_endpoints
# {{{
proc godel_ps_get_endpoints {} {
  #upvar 1 $corner arr
  upvar curs curs
  set ilist ""
  for {set i 1} {$i <= $curs(size)} {incr i} {
    lappend ilist $curs($i,endpoint)
  }
  #set ilist [array names arr *,endpoint]
  return $ilist
}
# cc_report_constraint
# Process report_constraint report and save the result to array `arr'
# }}}
#: godel_ps_get_id
# {{{
proc godel_ps_get_id {corner key value} {
  upvar 1 $corner arr
  regsub -all {\[} $value {\\[} value
  regsub -all {\]} $value {\\]} value
  set id ""
  if [info exist arr(size)] {
    for {set i 1} {$i <= $arr(size)} {incr i} {
      set arrvalue    $arr($i,$key)]
      if {[regexp $value $arrvalue]} {
        lappend id $i
      }
    }
  }
  if {$id ==  ""} {
    return $id
  } else {
    return [lindex [godel_ps_sort_by_slack arr $id] 0]
  }
}
# }}}
#@> Path Analyzer
#@=godel_pa
# {{{
proc godel_pa {infile} {
# Attributes
# slack              : floating
# startpoint         : string
# endpoint           : string
# path_group         : string
# path_type          : string
# cppr               : floating
# uncertainty        : floating
# last_common_inst   : string
# b2_inst            : string list
# b2_inst_count      : int
# b1_inst            : string list
# b1_inst_count      : int
# common_inst        : string
# common_inst_count  : int
# launch_clock_inst  : string list
# capture_clock_inst : string list
# capture_clock_edge : floating
# skew               : NA
# data_path_inst     : string list
# 
#       set vars($netname,fanout) $fanout
#       set vars($netname,netcap) $netcap
#       set vars(launch_inst_list) $inst
#       set vars(launch,$inst,innet) $netname
#       set vars(launch,$inst,inpin) [lindex $cellin 0]
#       set vars(launch,$inst,refname)   [lindex $cellin 1]
#       set vars(launch,$inst,dtrans)    [lindex $cellin 2]
#       set vars(launch,$inst,in_trans)     [lindex $cellin 3]
#       set vars(launch,$inst,net_derate)    [lindex $cellin 4]
#       set vars(launch,$inst,delta)     [lindex $cellin 5]
#       set vars(launch,$inst,net_delay)  [lindex $cellin 6]
#       set vars(launch,$inst,incr_delay_in)  [lindex $cellin 8]
# 
#       set vars(launch,$inst,cell_out_tran)  [lindex $cellout 2]
#       set vars(launch,$inst,cell_derate) [lindex $cellout 3]
#       set vars(launch,$inst,cell_delay)  [lindex $cellout 4]
#       set vars(launch,$inst,incr_delay_out)  [lindex $cellout 6]
#       set netline [split_by_space [shift ilist]]
#       set vars(launch,$inst,outnet) [lindex $netline 0]
# 
# data_path_delay
# skew
# cppr
# uncertainty
# pod(point of divergence): string
# Get path list in curs($path_num,all)
  godel_split_by $infile Startpoint
  set count $curs(size)
  set svars(path_count) $count
  set svars(infile)     $infile

  lappend alist startpoint
  lappend alist endpoint
  lappend alist endpoint_pin
  lappend alist slack
  lappend alist skew
  lappend alist path_group
  lappend alist path_type
  lappend alist cppr
  lappend alist uncertainty
  #lappend alist last_common_inst
  lappend alist b1_inst_count
  lappend alist b2_inst_count
  lappend alist b1_net_sum
  lappend alist b1_cell_sum
  lappend alist b2_net_sum
  lappend alist b2_cell_sum
  lappend alist b1_latency
  lappend alist b2_latency
  lappend alist clock_launch_latency
  lappend alist clock_capture_latency



  file mkdir pa.$infile
# Process each path
  for {set i 1} {$i <= $count} {incr i} {
    puts "Process..$i"
    file mkdir pa.$infile/p$i
    set fout_b1      [open "pa.$infile/p$i/b1.rpt" w]
    set fout_b2      [open "pa.$infile/p$i/b2.rpt" w]
# write out timing path snip for debugging
    godel_write_list_to_file $curs($i,all) pa.$infile/p$i/raw_path.rpt
    godel_array_reset vars
# Main timing path processing proc
    godel_pa_extract_info_list2 $curs($i,all)

    # Branch1
    # {{{
    puts $fout_b1 [format "%10s %10s %10s %10s" in_tran net_delay cell_delay OutNetCap]
    set b1_net_sum 0
    set b1_cell_sum 0
    foreach inst $vars(b1_inst) {
      set net_delay  [format "%.2f" $vars(launch,$inst,net_delay)]
      set cell_delay [format "%.2f" $vars(launch,$inst,cell_delay)]
      #incr b1_net_sum  $net_delay
      set b1_net_sum  [expr $b1_net_sum + $net_delay]
      #incr b1_cell_sum $cell_delay
      set b1_cell_sum [expr $b1_cell_sum + $cell_delay]
      set in_tran    [format "%.2f" $vars(launch,$inst,in_trans)]
      set netname $vars(launch,$inst,outnet)
      set netcap $vars(launch,$netname,netcap)
      puts $fout_b1 [format "%10.f %10.f %10.f %10.f    %s  %10.2f  %s" $in_tran    \
                                                                $net_delay  \
                                                                $cell_delay \
                                                                $netcap     \
                                                                $vars(launch,$inst,refname) \
                                                                $vars(launch,$inst,cell_derate) \
                                                                $inst]
    }
    puts $fout_b1 "net_total : $b1_net_sum"
    puts $fout_b1 "cell_total: $b1_cell_sum"
    set vars(b1_net_sum) $b1_net_sum
    set vars(b1_cell_sum) $b1_cell_sum
    set sumb1 [expr $b1_net_sum + $b1_cell_sum]
    #set vars(b1_cell_delay_ratio) [format "%.2f" [expr double($b1_cell_sum) / $sumb1]]
    close $fout_b1
    # }}}
    # Branch2
    # {{{
    puts $fout_b2 [format "%10s %10s %10s %10s" in_tran net_delay cell_delay OutNetCap]
    set b2_net_sum 0
    set b2_cell_sum 0
    foreach inst $vars(b2_inst) {
      set net_delay  [format "%.2f" $vars(capture,$inst,net_delay)]
      set cell_delay [format "%.2f" $vars(capture,$inst,cell_delay)]
      set in_trans   [format "%.2f" $vars(capture,$inst,in_trans)]
      set b2_net_sum [expr $b2_net_sum + $net_delay]
      set b2_cell_sum [expr $b2_cell_sum + $cell_delay]
      set netname $vars(capture,$inst,outnet)
      set netcap $vars(capture,$netname,netcap)
      puts $fout_b2 [format "%10.f %10.f %10.f %10.f    %s  %10.2f  %s" $in_trans   \
                                                         $net_delay  \
                                                         $cell_delay \
                                                         $netcap \
                                                         $vars(capture,$inst,refname) \
                                                         $vars(capture,$inst,cell_derate) \
                                                         $inst]
    }
    puts $fout_b2 "net_total : $b2_net_sum"
    puts $fout_b2 "cell_total: $b2_cell_sum"
    set vars(b2_net_sum) $b2_net_sum
    set vars(b2_cell_sum) $b2_cell_sum
    set sumb2 [expr $b2_net_sum + $b2_cell_sum]
    #set vars(b2_cell_delay_ratio) [format "%.2f" [expr double($b2_cell_sum) / $sumb2]]
    close $fout_b2
    # }}}
    # data path
    # {{{
    set fout_datapath [open "pa.$infile/p$i/datapath.rpt" w]
      puts -nonewline $fout_datapath [format "%10s "  trans]
      puts -nonewline $fout_datapath [format "%10s "  net]
      puts -nonewline $fout_datapath [format "%10s "  cell]
      puts -nonewline $fout_datapath [format "%10s "  net]
      puts -nonewline $fout_datapath [format "%13s "  incr_in]
      puts -nonewline $fout_datapath [format "%19s "  refname]
      puts -nonewline $fout_datapath [format "%s "    inst]
      puts            $fout_datapath ""
      puts -nonewline $fout_datapath [format "%10s "  ""]
      puts -nonewline $fout_datapath [format "%10s "  delay]
      puts -nonewline $fout_datapath [format "%10s "  delay]
      puts -nonewline $fout_datapath [format "%10s "  cap]
      puts -nonewline $fout_datapath [format "%13s "  delay]
      puts -nonewline $fout_datapath [format "%19s "  ""]
      puts -nonewline $fout_datapath [format "%s "    ""]
      puts            $fout_datapath ""
    foreach inst $vars(data_path_inst) {
      #set netname $vars(launch,$inst,outnet)
      #set netcap $vars(launch,$netname,netcap)
      puts -nonewline $fout_datapath [format "%10.f " $vars(launch,$inst,in_trans)]
      puts -nonewline $fout_datapath [format "%10.f " $vars(launch,$inst,net_delay)]
      puts -nonewline $fout_datapath [format "%10.f " $vars(launch,$inst,cell_delay)]
      puts -nonewline $fout_datapath [format "%10.f " $netcap]
      puts -nonewline $fout_datapath [format "%13.f " $vars(launch,$inst,incr_delay_in)]
      puts -nonewline $fout_datapath [format "%s "    $vars(launch,$inst,refname)]
      puts -nonewline $fout_datapath [format "%s "    $inst]
      puts $fout_datapath ""
    }
    close $fout_datapath
    # }}}

    foreach a $alist {
      set svars(p$i,$a) $vars($a)
    }

    godel_array_save svars "pa.$infile/svars.tcl"
  }

  set fout [open "pa.$infile/startpoints.rpt" w]
  for {set i 1} {$i <= $svars(path_count)} {incr i } {
    puts [format "%s" $svars(p$i,startpoint)]
  }
  close $fout

  # Print index
  set fout [open "index.pa.$infile.htm" w]
  godel_pa_html_header $fout index.pa.$infile.htm
  puts $fout "<pre>"
  for {set i 1} {$i <= $svars(path_count)} {incr i } {
    puts [format "%-4d %-5.f %-4d %-4d %-5.f %s" \
              $i \
              $svars(p$i,slack) \
              $svars(p$i,b2_inst_count) \
              $svars(p$i,b1_inst_count) \
              $svars(p$i,skew) \
              $svars(p$i,endpoint)
    ]
    puts -nonewline $fout "<a href=pa.$infile/p$i/index.htm>$i</a>"
    puts $fout [format "%5.f   %-4d %-4d %-5.f %s" \
              $svars(p$i,slack) \
              $svars(p$i,b2_inst_count) \
              $svars(p$i,b1_inst_count) \
              $svars(p$i,skew) \
              $svars(p$i,endpoint)
    ]
  }
  puts $fout "</pre>"
  #puts $fout "</tbody>"
  #puts $fout "</TABLE>"
  puts $fout "</body>"
  puts $fout "</html>"
  close $fout

  for {set i 1} {$i <= $svars(path_count)} {incr i } {
    set fout [open "pa.$infile/p$i/index.htm" w]
      godel_pa_html_header $fout p$i.index.htm
      puts $fout "<a href=\"raw_path.rpt\" type=\"text/rpt\">raw_path.rpt</a><br>"
      puts $fout "<a href=\"datapath.rpt\" type=\"text/rpt\">datapath.rpt</a><br>"
      puts $fout "<a href=\"b1.rpt\" type=\"text/rpt\">b1.rpt</a><br>"
      puts $fout "<a href=\"b2.rpt\" type=\"text/rpt\">b2.rpt</a><br>"
      puts $fout "<pre>"
      puts $fout [format "%-25s: %.f" Slack                 $svars(p$i,slack)]
      puts $fout [format "%-25s: %s"  Startpoint            $svars(p$i,startpoint)]
      puts $fout [format "%-25s: %s"  Endpoint              $svars(p$i,endpoint)]
      puts $fout [format "%-25s: %s"  Path_Group            $svars(p$i,path_group)]
      puts $fout [format "%-25s: %s"  Path_Type             $svars(p$i,path_type)]
      puts $fout [format "%-25s: %.f" CPPR                  $svars(p$i,cppr)]
      puts $fout [format "%-25s: %.f" Skew                  $svars(p$i,skew)]
      puts $fout [format "%-25s: %.f" Uncertainty           $svars(p$i,uncertainty)]
      puts $fout [format "%-25s: %.f" Clock_Launch_Latency  $svars(p$i,clock_launch_latency)]
      puts $fout [format "%-25s: %.f" Clock_Capture_Latency $svars(p$i,clock_capture_latency)]
      puts $fout [format "%-25s: %.f" B1_Latency            $svars(p$i,b1_latency)]
      puts $fout [format "%-25s: %.f" B2_Latency            $svars(p$i,b2_latency)]
      puts $fout "</pre>"
      #puts $fout "</tbody>"
      #puts $fout "</TABLE>"
      puts $fout "</body>"
      puts $fout "</html>"
    close $fout
  }
}
# }}}
#: godel_pa_extract_info_list2
# {{{
proc godel_pa_extract_info_list2 {alist} {
  upvar vars vars
  godel_pa_cut_in_half_by "data arrival time" $alist
  set first $half(1)
  set second $half(2)
  godel_pa_cut_in_half_by "------" $first
# header
  set vars(header) $half(1)
  set launch_n_data $half(2)
  foreach line $vars(header) {
      # startpoint
      if {[regexp {Startpoint: (\S+)} $line whole matched]}      { set vars(startpoint) $matched }
      # endpoint
      if {[regexp {Endpoint: (\S+)} $line whole matched]}        { set vars(endpoint)   $matched }
      # path_group
      if {[regexp {Path Group: (\S+)$} $line whole matched]}      { set vars(path_group) $matched }
      # path_type
      if {[regexp {Path Type: (\S+)} $line whole matched]}       { set vars(path_type)  $matched }
  }
  godel_pa_cut_in_half_by $vars(startpoint) $launch_n_data

  # launch_clock_path
  set vars(launch_clock_path) $half(1)
  # data_path
  set vars(data_path)         [concat $half(pattern) $half(2)]

  godel_pa_cut_in_half_by "  slack " $second
  # capture_clock_path
  set vars(capture_clock_path) $half(1)

  godel_pa_ext_launch
  godel_pa_ext_capture
  godel_pa_inst_type2_list
}
# }}}
#: godel_pa_collect_inst
# {{{
proc godel_pa_collect_inst {name} {
  upvar vars vars
  set inst [list]
  set ilist $vars($name)
  while {[llength $ilist]} {
    set line [godel_shift ilist]
    set colnum [llength [godel_split_by_space $line]]
    #puts "$colnum $line"
    if {$colnum == 10} {
      lappend inst [file dirname [lindex $line 0]]
    }
  }
  return $inst
}
# }}}
#: godel_pa_inst_type2_list
# {{{
proc godel_pa_inst_type2_list {} {
  upvar vars vars
# common_list
  set vars(data_path_inst)    [godel_pa_collect_inst data_path]
# launch_clock_inst
  set vars(launch_clock_inst) [godel_pa_collect_inst launch_clock_path]
  set vars(launch_clock_inst) [lreplace $vars(launch_clock_inst) end end]
# b1_list
  set vars(b1_inst) $vars(launch_clock_inst)
# capture_clock_inst
  set vars(capture_clock_inst) [godel_pa_collect_inst capture_clock_path]
  set vars(capture_clock_inst) [lreplace $vars(capture_clock_inst) end end]
# b2_list
  set vars(b2_inst) $vars(capture_clock_inst)
# common_inst
  set vars(common_inst) [list]
  set count [llength $vars(launch_clock_inst)]
  if {[llength $vars(capture_clock_inst)] < $count} {
    set count [llength $vars(capture_clock_inst)]
  }
  for {set i 1} {$i <= $count} {incr i} {
    set inst_launch [lindex $vars(launch_clock_inst) $i]
    set inst_capture [lindex $vars(capture_clock_inst) $i]
    if {$inst_launch == $inst_capture} {
      lappend vars(common_inst) $inst_launch
      set vars(b1_inst) [lreplace $vars(b1_inst) 0 0]
      set vars(b2_inst) [lreplace $vars(b2_inst) 0 0]
    } else {
      break
    }
  }
  set vars(common_inst_count) [llength $vars(common_inst)]
  set vars(b1_inst_count) [llength $vars(b1_inst)]
  set vars(b2_inst_count) [llength $vars(b2_inst)]
# capture_clock_edge
  foreach line $vars(capture_clock_path) {
    if [regexp {\s+clock\D+(\d+)} $line whole matched] {
      set vars(capture_clock_edge) $matched
      break
    }
  }
# endpoint_pin
  foreach line [lreverse $vars(data_path)] {
    if [regexp $vars(endpoint) $line whole matched] {
      set vars(endpoint_pin) [godel_get_column $line 0]
      break
    }
  }
  # When the capture is an output pin, the endpoint_pin = endpoint
  if ![info exist vars(endpoint_pin)] {set vars(endpoint_pin) $vars(endpoint)}

  if ![info exist vars(capture,$vars(endpoint),incr_delay_in)] { set vars(capture,$vars(endpoint),incr_delay_in) 0}
  if ![info exist vars(launch,$vars(startpoint),incr_delay_in)] { set vars(launch,$vars(startpoint),incr_delay_in) 0}
  set vars(skew) [expr $vars(capture,$vars(endpoint),incr_delay_in) - $vars(launch,$vars(startpoint),incr_delay_in) + $vars(cppr)]
  set vars(clock_launch_latency)  $vars(launch,$vars(startpoint),incr_delay_in)
  set vars(clock_capture_latency) $vars(capture,$vars(endpoint),incr_delay_in)
  set vars(pod)                   [lindex $vars(common_inst) end]
  if {$vars(pod) == ""} {
    set vars(b1_latency)            0
    set vars(b2_latency)            0
  } else {
    set vars(b1_latency)            [expr $vars(clock_launch_latency) - $vars(launch,$vars(pod),incr_delay_in)]
    set vars(b2_latency)            [expr $vars(clock_capture_latency) - $vars(capture,$vars(pod),incr_delay_in)]
  }

  set vars(launch,$vars(endpoint),cell_delay) 0
}
# }}}
#: godel_pa_cut_in_half_by
# {{{
proc godel_pa_cut_in_half_by {pattern ilist} {
  set flag 0
  upvar half half
  regsub -all {\[} $pattern {\\[} pattern
  regsub -all {\]} $pattern {\\]} pattern

  godel_array_reset half

  foreach i $ilist {
    if {$flag} {
      lappend half(2) $i
    } else {
      lappend half(1) $i
    }

    if [regexp "$pattern" $i] {
      lappend half(pattern) $i
      set flag 1
    } 
    
  }
}
# }}}
#: godel_pa_ext_capture
# {{{
proc godel_pa_ext_capture {} {
  upvar vars vars
# 2 means capture path
  set ilist $vars(capture_clock_path)
  while {[llength $ilist]} {
    set line [godel_shift ilist]
    regsub {<-} $line {} line
    regsub {\(gclock source\)} $line {} line
    set colno [llength [godel_split_by_space $line]]
    #puts "$colno $line"
    if {[regexp {\(net\)} $line]} {
      set netline [godel_split_by_space $line]
      set netname [lindex $netline 0]
      set fanout  [lindex $netline 2]
      set netcap  [lindex $netline 3]
      lappend vars(nets_list) $netname
      set vars(capture,$netname,fanout) $fanout
      set vars(capture,$netname,netcap) $netcap
# cellin
      set cellin [godel_split_by_space [godel_shift ilist]]
      set inst [file dirname [lindex $cellin 0]]
      lappend vars(capture_inst_list) $inst
      set vars(capture,$inst,innet)          $netname
      set vars(capture,$inst,inpin)          [lindex $cellin 0]
      set vars(capture,$inst,refname)        [lindex $cellin 1]
      set vars(capture,$inst,dtrans)         [lindex $cellin 2]
      set vars(capture,$inst,in_trans)       [lindex $cellin 3]
      set vars(capture,$inst,net_derate)     [lindex $cellin 4]
      set vars(capture,$inst,delta)          [lindex $cellin 5]
      set vars(capture,$inst,net_delay)      [lindex $cellin 6]
      set vars(capture,$inst,incr_delay_in)  [lindex $cellin 8]
    }
  }
# cellout line and outnet
  set ilist $vars(capture_clock_path)
  while {[llength $ilist]} {
    set line [godel_shift ilist]
    regsub {\(gclock source\)} $line {} line
    regsub {<-} $line {} line
    
    set colno [llength [godel_split_by_space $line]]
    if {$colno == 8} {
      set cellout [godel_split_by_space $line]]
      set inst [file dirname [lindex $cellout 0]]
      set vars(capture,$inst,cell_out_tran)   [lindex $cellout 2]
      set vars(capture,$inst,cell_derate)     [lindex $cellout 3]
      set vars(capture,$inst,cell_delay)      [lindex $cellout 4]
      set vars(capture,$inst,incr_delay_out)  [lindex $cellout 5]
      set netline [godel_split_by_space [godel_shift ilist]]
      set vars(capture,$inst,outnet)          [lindex $netline 0]
    }

# cppr
    set vars(cppr) 0
    if {[regexp {clock reconvergence pessimism         \s+(\S+) } $line whole matched]}  { set vars(cppr)  $matched }
# uncertainty
    set vars(uncertainty) 0
    if {[regexp {uncertainty\s+(\S+) } $line whole matched]}  { set vars(uncertainty)  $matched }
# slack
    if {[regexp {slack \(.*\)\s+(\S+)} $line whole matched]} {set vars(slack) $matched}
  }
}
# ext_launch
# }}}
#: godel_pa_ext_launch
# {{{
proc godel_pa_ext_launch {} {
  upvar vars vars
# 1 means launch path
  #set ilist $vars(1)
  set ilist [concat $vars(launch_clock_path) $vars(data_path)]

  while {[llength $ilist]} {
    set line [godel_shift ilist]
    regsub {\(gclock source\)} $line {} line
    regsub {<-} $line {} line

    set colno [llength [godel_split_by_space $line]]
    #puts "$colno $line"
    if {[regexp {\(net\)} $line]} {
      set netline [godel_split_by_space $line]
      set netname [lindex $netline 0]
      set fanout  [lindex $netline 2]
      set netcap  [lindex $netline 3]
      lappend vars(nets_list) $netname
      set vars(launch,$netname,fanout) $fanout
      set vars(launch,$netname,netcap) $netcap
# cellin
      set cellin [godel_split_by_space [godel_shift ilist]]
      set inst [file dirname [lindex $cellin 0]]
      lappend vars(launch_inst_list) $inst
      set vars(launch,$inst,innet) $netname
      set vars(launch,$inst,inpin)           [lindex $cellin 0]
      set vars(launch,$inst,refname)         [lindex $cellin 1]
      set vars(launch,$inst,dtrans)          [lindex $cellin 2]
      set vars(launch,$inst,in_trans)        [lindex $cellin 3]
      set vars(launch,$inst,net_derate)      [lindex $cellin 4]
      set vars(launch,$inst,delta)           [lindex $cellin 5]
      set vars(launch,$inst,net_delay)       [lindex $cellin 6]
      set vars(launch,$inst,incr_delay_in)   [lindex $cellin 8]
    }
  }
  #set ilist $vars(1)
  set ilist [concat $vars(launch_clock_path) $vars(data_path)]
  while {[llength $ilist]} {
    set line [godel_shift ilist]
    regsub {\(gclock source\)} $line {} line
    regsub {<-} $line {} line

    set colno [llength [godel_split_by_space $line]]
    if {$colno == 8} {
      set cellout [godel_split_by_space $line]]
      set inst [file dirname [lindex $cellout 0]]
      set vars(launch,$inst,cell_out_tran)   [lindex $cellout 2]
      set vars(launch,$inst,cell_derate)     [lindex $cellout 3]
      set vars(launch,$inst,cell_delay)      [lindex $cellout 4]
      set vars(launch,$inst,incr_delay_out)  [lindex $cellout 6]
      set netline [godel_split_by_space [godel_shift ilist]]
      set vars(launch,$inst,outnet) [lindex $netline 0]
    }
  }
}
# }}}
#: godel_pa_html_header
# {{{
proc godel_pa_html_header {fout title} {
  puts $fout ""
  puts $fout "<html>"
  puts $fout "<HEAD>"
  puts $fout "<title> $title </title>"
  puts $fout "<STYLE>"
  puts $fout "table, th, td {"
  puts $fout "  border: 1px solid black;"
  puts $fout "  border-collapse: collapse;"
  puts $fout "}"
  puts $fout "th, td {"
  puts $fout "  padding: 5px;"
  puts $fout "  text-align: left;"
  puts $fout "}"
  puts $fout "table #t01 tr:nth-child(even) {"
  puts $fout "  background-color: #eee;"
  puts $fout "}"
  puts $fout "table #t01 tr:nth-child(odd) {"
  puts $fout "  background-color: #fff;"
  puts $fout "}"
  puts $fout "table #t01 {"
  puts $fout "  color: white"
  puts $fout "  background-color: black;"
  puts $fout "}"
  puts $fout "td ul li {"
  puts $fout "    padding:0;"
  puts $fout "    margin:0;"
  puts $fout "}"
  puts $fout "</STYLE>"
  puts $fout "</HEAD>"
  puts $fout " <br>"
  puts $fout "<body>"
  #puts $fout "<TABLE width=\"100%\" border=\"1\" id=\"t01\">"
  #puts $fout "<TABLE border=\"1\" id=\"t01\">"
  #puts $fout "<tbody>"
  
}
# }}}
#@> Tool Box
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
# tbox_cygpath
# {{{
proc tbox_cygpath {pp} {
  global env
  if {$env(GODEL_IN_CYGWIN)} {
    if [regexp {^\/} $pp] {
      if [regexp {\/cygdrive\/\w} $pp] {
        regsub {\/cygdrive\/(\w)} $pp {\1:} winpath
      } else {
        #set winpath "C:/cygwin64$pp"
        set winpath "$env(CYGWIN_INSTALL)/$pp"
      }
      set path "file:///$winpath"
    } else {
      set path $pp
    }
  } else {
    set path $pp
  }
  return $path
}
# }}}
# tbox_cyg2unix
# {{{
proc tbox_cyg2unix {pp} {
  global env
  if {$env(GODEL_IN_CYGWIN)} {
    regsub {file:///} $pp {} pp
    regsub {file:/} $pp {} pp
    set path [exec tcsh -fc "cygpath -u $pp"]
  } else {
    regsub {file://} $pp {} pp
    set path $pp
  }

  return $path
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
#: godel_value_scatter
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
#: godel_value_accu
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

# godel_get_vars_value
# {{{
proc godel_get_vars_value {key varsfile} {
  if [file exist $varsfile] {
    source $varsfile
  }
  if [info exist vars($key)] {
    return $vars($key)
  } else {
    return NA
  }
}
# }}}
#@> grun
#@=set_bvars
proc set_bvars {name defalt_value} {
  upvar kout   kout
  upvar bvars  bvars
  if [info exist bvars($name)] {
    puts $kout [format "set %-30s %s" "vars($name)" $bvars($name)]
  } else {
    puts $kout [format "set %-30s %s" "vars($name)" $defalt_value]
  }
}
#@=create_run
proc create_run {path flowname} {
  upvar bvars bvars
  global env
  set orgpath [pwd]
  file mkdir $path
  cd $path
  godel_draw $flowname
  grun_ci;
  cd $orgpath
}
#@=grun_rm
proc grun_rm {{pattern NA} {action NA}} {
  global env
  puts $action
  set mfile $env(GODEL_META_CENTER)/runlist.tcl
  if [file exist $mfile] {
# get array `runlist'
    source $mfile
  }

  if {$pattern == ""} {
  } else {
    foreach i [array names runlist] {
      set run_root $runlist($i)
      if [regexp $pattern $run_root] {
        lappend pathlist $run_root
        lappend namelist $i
      }
    }
  }
  set pathlist [lsort $pathlist]
  foreach i $pathlist {
    if {$action == "delete"} {
      puts "delete..$i"
      file delete -force $i
      foreach name $namelist {
        array unset runlist $name
      }
      godel_array_save runlist $env(GODEL_META_CENTER)/runlist.tcl
    } else {
      puts $i
    }
  }

}
#@=grun_ls
# {{{
proc grun_ls {{pattern .*}} {
# Create vv.tcl, vv.tcl is to be used to draw ghtm table
  global env
  set mfile $env(GODEL_META_CENTER)/runlist.tcl
  if [file exist $mfile] {
# get array `runlist'
    source $mfile
  }
  
  set count 1

  foreach i [array names runlist] {
    set runname [lindex [split $i :] 1]
    if [regexp $pattern $runname] {
      lappend ilist "$runname $i"
    }
  }

# Sort by runname
  set ilist_sorted [lsort -index 0 $ilist]

# Iterate each run in runlist
  foreach item $ilist_sorted {
    set runname [lindex $item 0]
    set i      [lindex $item 1]
    set run_root $runlist($i)

# Because runname can be duplicated, we don't use runname as rowname,
# instead we create 2 digit number as rowname
      set twodigit [format "%02d" $count]
      lappend vv(rowlist) $twodigit

# Source `local.tcl' in run_root. Create array vv($twodigit,)
# local.tcl contains config info of a run
      if [file exist $run_root/local.tcl] {
        source $run_root/local.tcl
        foreach j [array names vars] {
          set vv($twodigit,$j) $vars($j)
          lappend vv(columnlist) $j
        }
      }
# Source `.status.tcl' in run_root. Create array vv($twodigit,)
# .status.tcl contains run status
      if [file exist $run_root/.status.tcl] {
        source $run_root/.status.tcl
        foreach j [array names vars] {
          set vv($twodigit,$j) $vars($j)
        }
        lappend vv(columnlist) $j
      }
      set vv($twodigit,runname) "${runname}=>$run_root/.index.htm"
      
      incr count
      godel_array_reset vars
  }
  set vv(columnlist) [lsort -unique $vv(columnlist)]
  godel_array_save vv vv.tcl

}
# }}}
#@=grun_status
# {{{
proc grun_status {text} {
# TODO:
# grun_status status   killed
# grun_status progress 10%
#
# To be embedded in run script
# Predefined text:
# done
# begin
#

# source .status.tcl here to keep the original values
  if [file exist .status.tcl] {
    source .status.tcl
  }
# Update status
  set vars(status) $text

  set fout [open .status.tcl w]
    foreach key [array names vars] {
      regsub -all {"} $vars($key) {\\"}  newvalue
      puts $fout [format "set %-40s \"%s\"" vars($key) $newvalue]
    }
  close $fout
}
# }}}
#@=grun_ci
# {{{
proc grun_ci {{page_path .}} {
  global env
  set metafile $env(GODEL_META_CENTER)/runlist.tcl
  if [file exist $metafile] {
    source $metafile
  }

  #puts $page_path/.godel/vars.tcl
  source $page_path/.godel/vars.tcl

# pagename
  set pagename $vars(g:pagename)
  
# checked-in meta value
   #puts "Checkin $pagename..."
   regsub -all {\/} $vars(g:where) {_} path2

   set runlist($path2:$pagename)     $vars(g:where)

   godel_array_save runlist $env(GODEL_META_CENTER)/runlist.tcl
}
# }}}
#@=godel_add_class
# {{{
proc godel_add_class {pname value} {
  global env
  source $env(GODEL_META_FILE)

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
#@=godel_set_page_value
# {{{
proc godel_set_page_value {pname attr value} {
  global env
  source $env(GODEL_META_FILE)

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
proc godel_get_page_value {pname attr} {
  global env
  source $env(GODEL_META_FILE)

# Get pname where
  source $mfile
  #puts $meta($pname,where)

# Get pname value
  source $meta($pname,where)/.godel/vars.tcl

  puts $vars(g:keywords)
  return $vars(g:keywords)
}
#@>META
#@=meta_get_page
proc meta_get_pagelist {} {
  global env
  source $env(GODEL_META_FILE)

  set pagelist [list]
  foreach i [array name meta *,where] {
    regsub ",where" $i "" i
    lappend pagelist $i
  }

  return $pagelist
}
#@=mindex
# {{{
proc mindex {metafile} {
  source $metafile

  array set vars [array get meta]

  # lmap is supported in tcl 8.6
  #set ilist [lmap i [array name meta *,where] {regsub ",where" $i ""}]
  set ilist [list]
  foreach i [array name meta *,where] {
    regsub ",where" $i "" i
    lappend ilist $i
  }

  godel_array_reset meta

  foreach i $ilist {
    set varspath   $vars($i,where)/.godel/vars.tcl
    set dyvarspath $vars($i,where)/.godel/dyvars.tcl
    if [file exist $varspath] {
      source $varspath

      if [file exist $dyvarspath] {
        source $dyvarspath
        set meta($i,last_updated) $dyvars(last_updated)
      }
      set meta($i,class)        $vars(g:class)
      set meta($i,keywords)     [lsort [concat $vars(g:keywords) $vars(g:class)]]
      #set meta($i,pagesize)     $vars(pagesize)
      set meta($i,where)        $vars($i,where)
# cdk use "keys" for searching
      if [info exist vars(title)] {
        set meta($i,keys)         [lsort [concat $i $vars(g:keywords) $vars(g:class) $vars(title)]]
      } else {
        set meta($i,keys)         [lsort [concat $i $vars(g:keywords) $vars(g:class)]]
      }
    } else {
      puts "Error: not exist.. $varspath"
    }
  }

  godel_array_save meta [file dirname $metafile]/indexing.tcl
}
# }}}
#@=meta-indexing
# {{{
proc meta_indexing {{ofile NA}} {
  upvar env env
  foreach f $env(GODEL_META_FILE) {
    source $f
  }

  array set vars [array get meta]

  # lmap is supported in tcl 8.6
  #set ilist [lmap i [array name meta *,where] {regsub ",where" $i ""}]
  set ilist [list]
  foreach i [array name meta *,where] {
    regsub ",where" $i "" i
    lappend ilist $i
  }

  godel_array_reset meta

  foreach i $ilist {
    set varspath   $vars($i,where)/.godel/vars.tcl
    set dyvarspath $vars($i,where)/.godel/dyvars.tcl
    if [file exist $varspath] {
      source $varspath

      if [file exist $dyvarspath] {
        godel_array_reset dyvars
        source $dyvarspath
        if [info exist dyvars(last_updated)] {
        set meta($i,last_updated) $dyvars(last_updated)
        }
        if [info exist dyvars(page_size)] {
        set meta($i,page_size)    $dyvars(page_size)
        }
      }
      set meta($i,class)        $vars(g:class)
      set meta($i,keywords)     [lsort [concat $vars(g:keywords) $vars(g:class)]]
# cdk use "keys" for searching
      if [info exist vars(title)] {
        set meta($i,keys)         [lsort [concat $i $vars(g:keywords) $vars(g:class) $vars(title)]]
      } else {
        set meta($i,keys)         [lsort [concat $i $vars(g:keywords) $vars(g:class)]]
      }
    } else {
      puts "Error: not exist.. $varspath"
    }
  }

  if {$ofile == "NA"} {
    godel_array_save meta $env(GODEL_META_CENTER)/indexing.tcl
  } else {
    godel_array_save meta $ofile
  }
}
# }}}
#@=meta_chkin
# {{{
proc meta_chkin {{page_path ""} {hier_level ""}} {
  global env
  source $env(GODEL_META_FILE)
  set org_path [pwd]
# meta value to be checked-in stored in .godel/vars.tcl
  if {$page_path != ""} {
    #cd [tbox_cyg2unix $page_path]
    cd $page_path
  }

  #source .godel/vars.tcl
  set fullpath [pwd]
  set c [split $fullpath /]

# pagename
  if {$hier_level == ""} {
    set pathelem [lrange $c end end]
  } else {
    set pathelem [lrange $c end-$hier_level end]
  }
  
  set pagename [join $pathelem ":"]

# checked-in meta value
  if [info exist meta($pagename,where)] {
    puts "Error: `$pagename' already exist..."
    puts "       $pagename = $meta($pagename,where)"
    cd $org_path
    return 0
  } else {
    puts "Checkin $pagename..."
    set meta($pagename,where)    $fullpath
    godel_array_save meta $env(GODEL_META_FILE)
    cd $org_path
    return 1
  }


}
# }}}
#@=meta_rm
# {{{
proc meta_rm {name} {
  global env
  set mfile $env(GODEL_META_FILE)
  if [file exist $mfile] {
    source $mfile
  }

  array unset meta $name,where

  godel_array_save meta $env(GODEL_META_FILE)
}
# }}}
#@=meta_get_page_where
proc meta_get_page_where {pname} {
  global env
  source $env(GODEL_META_FILE)
  if [info exist meta($pname,where)] {
    return $meta($pname,where)
  } else {
    return NA
  }
}
#@=godel_set_page_vars
proc godel_set_page_vars {pname key value} {
  upvar vars vars
  global env

  set where [meta_get_page_where $pname]
  if {$where == "NA"} {
    puts "Error: no where for $pname"
    return
  }
  #puts $where
  cd $where
  source .godel/vars.tcl

# Set
  set vars($key) $value

  godel_array_save vars .godel.godel/vars.tcl
}

proc file_not_exist_exit {fname} {
  if ![file exist $fname] {
    puts "Error: $fname not exist. Nothing done..."
    exit
  }
}

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

  return $lines
}
# }}}
proc getimg {name {confirm nogo}} {

  set ilist [glob /cygdrive/c/Users/chihkang/Pictures/$name]
  foreach i $ilist {
    puts $i
  }
  if {$confirm == "go"} {
    foreach i $ilist {
      exec tcsh -fc "mv $i ."
    }
  }
}
proc getdownload {name {confirm nogo}} {

  set ilist [glob /cygdrive/c/Users/chihkang/Downloads/$name]
  foreach i $ilist {
    puts $i
  }
  if {$confirm == "go"} {
    foreach i $ilist {
      exec tcsh -fc "mv $i ."
    }
  }
}
proc getdocument {name {confirm nogo}} {

  set ilist [glob /cygdrive/c/Users/chihkang/Documents/$name]
  foreach i $ilist {
    regsub -all {\s} $i {\\ } i
    puts $i
  }
  if {$confirm == "go"} {
    foreach i $ilist {
      regsub -all {\s} $i {\\ } i
      exec tcsh -fc "mv $i ."
    }
  }
}
proc a4_rm_module {module} {
  global env
  source $env(GODEL_ROOT)/bin/gsh_cmds.tcl
  regsub {CENTER\/} $module {} module

  puts "Remove dir.. $env(GODEL_CENTER)/$module"
  cd $env(GODEL_CENTER)
  file delete -force $module

  puts "Remove $module,"
  source .godel/vars.tcl
  remove_keys $module,*
  set vars(module_list) [godel_remove_list_element $vars(module_list) $module]
  godel_array_save vars .godel/vars.tcl
  godel_array_reset vars
}
proc a4_rm_version {a4path} {
  global env
  source $env(GODEL_ROOT)/bin/gsh_cmds.tcl
  regsub {CENTER\/} $a4path {} a4path

  set version [godel_get_path_elem $a4path 2]
  set stage   [godel_get_path_elem $a4path 1]
  set module  [godel_get_path_elem $a4path 0]

  #puts $a4path
  puts "Remove dir.. $env(GODEL_CENTER)/$a4path"
  cd $env(GODEL_CENTER)/$module/$stage
  file delete -force $version

  puts "Remove $version,"
  source .godel/vars.tcl
  remove_keys $version,*
  set vars(version_list) [godel_remove_list_element $vars(version_list) $version]
  godel_array_save vars .godel/vars.tcl
  godel_array_reset vars

  puts "Remove $stage,$version,"
  cd ..
  source .godel/vars.tcl
  remove_keys $stage,$version,*
  set vars($stage,version_list) [godel_remove_list_element $vars($stage,version_list) $version]
  godel_array_save vars .godel/vars.tcl
  godel_array_reset vars

  puts "Remove $module,$stage,$version,"
  cd ..
  source .godel/vars.tcl
  remove_keys $module,$stage,$version,*
  set vars($module,$stage,version_list) [godel_remove_list_element $vars($module,$stage,version_list) $version]
  godel_array_save vars .godel/vars.tcl
  godel_array_reset vars
}

proc godel_load_vars {vpath} {
  global env
  upvar vars vars

  set vpath [tbox_cyg2unix $vpath]

# Load vars.tcl
  source [file dirname $vpath]/.godel/vars.tcl 

# Load gsh_cmd.tcl
  source ~/gsh_cmds.tcl
}

proc godel_copy_vars {vpath} {
  global env
  upvar vars vars

  set vpath [tbox_cyg2unix $vpath]

# Load vars.tcl
  file copy -force [file dirname $vpath]/.godel/vars.tcl  .

}
proc godel_load_gsh_cmds {} {
# Load gsh_cmd.tcl
  source ~/gsh_cmds.tcl
}
# vim:fdm=marker
