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
proc ghtm_keyword_button {tablename column keyword} {
  global fout
  puts $fout "<button onclick=filter_table_keyword(\"$tablename\",$column,\"$keyword\")>$keyword</button>"
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
    } elseif [regexp -nocase {\.png} $fname] {
    } elseif [regexp -nocase {\.md} $fname] {
      #puts $fout "<a href=\"$full\" type=text/png><img src=$full width=30% height=30%></a>"

    } elseif [regexp -nocase {\.docx} $fname] {
      puts $fout "<a href=\"$full\" type=text/docx>$full</a><br>"

    } elseif [regexp -nocase {\.one} $fname] {
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
proc ghtm_top_bar {{type NA}} {
  upvar fout fout
  upvar env env
  upvar vars vars
  upvar flow_name flow_name
  if [file exist .godel/dyvars.tcl] {
    source .godel/dyvars.tcl
  } else {
    set dyvars(last_updated) Now
  }

# default flow_name
  if ![info exist flow_name] {
    set flow_name default
  }

  set cwd [pwd]
  file mkdir .godel/js
  file copy -force $env(GODEL_ROOT)/scripts/js/godel.js .godel/js
  file copy -force $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js .godel/js

  puts $fout "<script src=.godel/js/godel.js></script>"
  puts $fout "<script src=.godel/js/jquery-3.3.1.min.js></script>"
  #puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/godel.js]></script>"
  #puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js]></script>"
  #puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/prism/prism.js]></script>"

  puts $fout "<div class=\"w3-bar w3-border w3-indigo w3-medium\">"
# Edit
  puts $fout "  <div><a href=.godel/ghtm.tcl type=text/txt class=\"w3-bar-item w3-button w3-hover-red\">Edit</a></div>"
# Values
  puts $fout "  <div><a href=.godel/vars.tcl type=text/txt class=\"w3-bar-item w3-button w3-hover-red\">Values</a></div>"
# Draw
  puts $fout "  <div><a href=.godel/draw.gtcl type=text/gtcl class=\"w3-bar-item w3-button w3-hover-red\">Draw</a></div>"
# Parent
  puts $fout "  <div><a href=../.index.htm class=\"w3-bar-item w3-button w3-hover-red\">Parent</a></div>"
# 
  #puts $fout "  <div><div id=\"div\" class=\"w3-bar-item w3-button w3-hover-red\" style=\"width:20px;height:20px;\" contenteditable=\"true\"></div></div>"
# TOC
  puts $fout "  <div><a href=.main.htm  class=\"w3-bar-item w3-button w3-hover-red\">TOC</a></div>"
  set path_help     [tbox_cygpath $env(GODEL_ROOT)/docs/help/.index.htm]
  set path_pagelist [tbox_cygpath $env(GODEL_META_CENTER)/pagelist/.index.htm]
  set path_draw     [tbox_cygpath $env(GODEL_ROOT)/plugin/gdraw/gdraw_$flow_name.tcl]
  puts $fout "<div class=\"w3-dropdown-click w3-right\">"
  puts $fout "  <button onclick=\"myFunction()\" class=\"w3-button w3-hover-red\">More</button>"
  puts $fout "  <div id=\"Demo\" class=\"w3-dropdown-content w3-bar-block w3-card-4\">"
  #puts $fout "    <a href=\".main.htm\"                     class=\"w3-bar-item w3-button\">Table of Content</a>"
  puts $fout "    <a href=\".index.htm\"      type=text/txt class=\"w3-bar-item w3-button\">HTML</a>"
  #puts $fout "    <a href=\"$path_help\"                    class=\"w3-bar-item w3-button\">Help</a>"
  #puts $fout "    <a href=\"$path_pagelist\"                class=\"w3-bar-item w3-button\">Pagelist</a>"
  puts $fout "    <a href=\".godel/proc.tcl\" type=text/txt class=\"w3-bar-item w3-button\">Proc</a>"
  puts $fout "  </div>"
  puts $fout "</div>"
  
  puts $fout "  <div class=\"w3-bar-item w3-button w3-hover-red w3-right\">$dyvars(last_updated)</div>"

  puts $fout "</div>"


  puts $fout "<textarea rows=10 cols=70 id=\"text_board\" style=\"display:none;font-size:10px\"></textarea>"

  puts $fout "<script>"
  puts $fout "function myFunction() {"
  puts $fout "    var x = document.getElementById(\"Demo\");"
  puts $fout "    if (x.className.indexOf(\"w3-show\") == -1) {"
  puts $fout "        x.className += \" w3-show\";"
  puts $fout "    } else { "
  puts $fout "        x.className = x.className.replace(\" w3-show\", \"\");"
  puts $fout "    }"
  puts $fout "}"
  set server $env(GODEL_SERVER)
  set pwd    [pwd]
  #puts $fout "function js_godel_draw() {"
  #puts $fout "  httpRequest = new XMLHttpRequest();"
  #puts $fout "  httpRequest.open('GET', 'http://$server/eval/cd $pwd;godel_draw', true);"
  #puts $fout "  httpRequest.send();"
  #puts $fout "}"
  #puts $fout ""
  #puts $fout "var div = document.getElementById('div');"
  #puts $fout "div.addEventListener('paste', function(e) {"
  #puts $fout "  if(e.clipboardData) {"
  #puts $fout "    for(var i = 0; i < e.clipboardData.items.length; i++ ) {"
  #puts $fout "      var c = e.clipboardData.items\[i];"
  #puts $fout "      var f = c.getAsFile();"
  #puts $fout "      var reader = new FileReader();"
  #puts $fout "      reader.readAsDataURL(f);"
  #puts $fout "      reader.onload = function(e) {"
  #puts $fout "        div.innerHTML  = 'Done';"
  #puts $fout "        var imgbase64 = e.target.result;"
  #puts $fout "    $.ajax({"
  #puts $fout "        type: \"POST\","
  #puts $fout "        url: \"http://localhost:8080/image $pwd\","
  #puts $fout "        data: { "
  #puts $fout "           imgbase64"
  #puts $fout "        }"
  #puts $fout "      }).done(function(responseText) {"
  #puts $fout "        console.log('saved');"
  #puts $fout "      });"
  #puts $fout "      }"
  #puts $fout "    }"
  #puts $fout "  }"
  #puts $fout "});"

  puts $fout "</script>"
}
# }}}
# lkey
# {{{
proc lkey {} {
  set dirs [glob -type d *]
  #puts $dirs
  foreach dir $dirs {
    set varsfile $dir/.godel/vars.tcl
    if {[file exist $varsfile]} {
      source $varsfile
      puts [format "%-10s : %s" $dir $vars(g:keywords)]
    }
  }
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

  set fname $args

# Load waiver
  set waivers {}
  if {$opt(-w)} {
    set kin [open $waivefile r]
  } else {
    if [file exist $fname.waive] {
      set kin [open $fname.waive r]
    } else {
      puts "Error: not exist $fname.waive"
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

# Apply waiver
  set kin [open $fname r]
    while {[gets $kin line] >= 0} {

      set flag_waive 0
      foreach waiver $waivers {
        if [regexp $waiver $line] {
          set flag_waive 1
          break
        }
      }

      if {$flag_waive} {
        incr arr($waiver)
      } else {
        puts $line
      }
    }
  close $kin

# Summary
  parray arr
}
# }}}
# ghtm_filter_table
# {{{
proc ghtm_filter_table {tname column_no} {
  upvar fout fout
  puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">" 
  puts $fout "<input type=text id=filter_table_input onkeyup=filter_table(\"$tname\",$column_no,event) placeholder=\"Search...\" autofocus>"
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

  puts $fout "<div class=\"w3-col\" style=\"width:$size;\">"
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
# lsetvar
# {{{
proc lsetvar {name key value} {
  regsub {\/$} $name {} name

  set varfile $name/.godel/vars.tcl

  if [file exist $varfile] {
 #   puts $varfile
    source $varfile
    set vars($key) $value
  } else {
    puts "Error: not exist... $varfile"
  }

  godel_array_save vars $varfile
}
# }}}
# lsetdyvar
# {{{
proc lsetdyvar {name key value} {
  set varfile $name/.godel/dyvars.tcl

  if [file exist $varfile] {
 #   puts $varfile
    source $varfile
    set dyvars($key) $value
  } else {
    puts "Error: not exist... $varfile"
  }

  godel_array_save dyvars $varfile
}
# }}}
# lvars
# {{{
proc lvars {name {key ""}} {
  if ![file exist $name/.godel/vars.tcl] {
    return NA
  }
  source $name/.godel/vars.tcl
  if {$key == ""} {
    parray vars
  } else {
    if [info exist vars($key)] {
      return $vars($key)
    } else {
      return NA
    }
  }
}
# }}}
# local_table
# {{{
proc local_table {name args} {
  global fout

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
  # -edit (edit)
# {{{
  set opt(-edit) 0
  set idx [lsearch $args {-edit}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-edit) 1
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
  # -column_style_proc (column_style_proc)
# {{{
  set opt(-column_style_proc) 0
  set idx [lsearch $args {-column_style_proc}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-column_style_proc) 1
  }
# }}}
  # -column_data_proc (column_data_proc)
# {{{
  set opt(-column_data_proc) 0
  set idx [lsearch $args {-column_data_proc}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-column_data_proc) 1
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

  # create rows
  # {{{
  if {$opt(-f)} {
    if [file exist $listfile] {
      set rows [read_file_ret_list $listfile]
    } else {
      puts "Errors: Not exist... $listfile"
      return
    }
  } else {
    set flist [lsort [glob -nocomplain */.godel]]
    foreach f $flist {
      lappend rows [file dirname $f]
    }
  }
  # }}}

# Start creating table...
#  if {$opt(-css)} {
#    puts $fout "<table class=$css_class id=$name>"
#  } else {
#    puts $fout "<table class=table2 id=$name>"
#  }
  puts $fout "<style>"
  puts $fout ".table1 td, .table1 th {"
  puts $fout "font-size : $fontsize;"
  puts $fout "}"
  puts $fout "</style>"
  puts $fout "<table class=$css_class id=$name>"
# Table Headers
# {{{
  puts $fout "<tr>"
  if {$opt(-edit)} {
    puts $fout "<th>e</th>"
    puts $fout "<th>v</th>"
  }
  if {$opt(-serial)} {
    puts $fout "<th>serial</th>"
  }
  foreach col $columns {
    set colname ""
    regexp {;(\S+)} $col -> colname

    if {$colname == ""} {
      set colname $col
    } 
    puts $fout "<th>$colname</th>"
  }
  puts $fout "</tr>"
# }}}

  # Sort by...
# {{{
  if {$opt(-sortby)} {
    set index_num 1

    # Create index() array
    foreach col $columns {
      set index($col) $index_num
      incr index_num
    }

    # Create row_items for sorting
    set row_items {}
    foreach row $rows {
      set col_items {}
      foreach col $columns {
        lappend col_items [lvars $row $col ]
      }
      lappend row_items [concat $row $col_items]
    }

    # Sorting...
    set row_items [lsort -index $index($sortby) $sort_direction $row_items]

    # Re-create rows based on sorted row_items
    set rows {}
    foreach i $row_items {
      lappend rows [lindex $i 0]
    }
  }
# }}}

  set serial 1
#--------------------
# For each table row
#--------------------
  foreach row $rows {
    set row_disp 1
    set row_style {}

    # row_style_proc
    if {$opt(-row_style_proc)} {
      row_style_proc $row
    }

    # Control to hide the row
    if {$row_disp == "0"} {
      continue
    } 

    puts $fout "<tr style=\"$row_style\">"

    if {$opt(-edit)} {
      puts $fout "<td><a href=$row/.godel/ghtm.tcl type=text/txt>e</a></td>"
      puts $fout "<td><a href=$row/.godel/vars.tcl type=text/txt>v</a></td>"
    }
    if {$opt(-serial)} {
      puts $fout "<td>$serial</td>"
    }
    #----------------------
    # For each table column
    #----------------------
    foreach col $columns {
      set cols2disp {}
      set column_style {}
      # Remove column width
      regsub {;\S+} $col {} col

      if {$opt(-column_style_proc)} {
        column_style_proc $row $col
      }

      # Get column data
      set col_data [lvars $row $col]

      # linkcol
      if {$col == $linkcol} {
        set col_data "<a href=$row/.index.htm>$col_data</a>"
      }
      # img:
      if [regexp {img:} $col] {
        regsub {img:} $col {} col
        append cols2disp "<td><a href=$row/images/cover.jpg><img height=100px src=$row/images/cover.jpg></a></td>"
      # md:
      } elseif [regexp {md:} $col] {
        regsub {md:} $col {} col
        set fname $row/$col.md
        if [file exist $fname] {
          set aftermd [gmd_file $fname]
          append cols2disp "<td>$aftermd</td>"
        } else {
          set kout [open $fname w]
          close $kout
        }
      # ed:
      } elseif [regexp {ed:} $col] {
        regsub {ed:} $col {} col
        set fname $row/$col
        if [file exist $fname] {
          append cols2disp "<td><a href=$fname type=text/txt>e</a></td>"
        } else {
          append cols2disp "<td></td>"
        }
      } else {
        if {$opt(-column_data_proc)} {
          column_data_proc $row $col
        }
        append cols2disp "<td style=\"$column_style\">$col_data</td>"
      }
      puts $fout $cols2disp
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

  puts $fout "<style>"
  set fin [open $env(GODEL_ROOT)/etc/css/w3.css r]
    while {[gets $fin line] >= 0} {
      puts $fout $line
    }
  close $fin
  puts $fout "</style>"

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
    puts $kout "#list_img 4 100% images/*"
    puts $kout "#local_table tbl -c {g:pagename}"
    puts $kout "ghtm_list_files *"
    puts $kout "#ghtm_filter_notes"
    puts $kout "gnotes {"
    puts $kout ""
    puts $kout "}"
  close $kout

  set kout [open .godel/draw.gtcl w]
    puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
    puts $kout "set pagepath \[file dirname \[file dirname \[info script\]\]\]"
    puts $kout "cd \$pagepath"
    puts $kout "godel_draw"
    puts $kout "exec xdotool search --name \"Mozilla\" key ctrl+r"

  close $kout
}
# }}}
# datediff
# {{{
proc datediff {date2 date1 {type dd}} {
# datediff 2019/3/2 2019/1/3 hh

  set d2 [exec date -d $date2 +%s]
  set d1 [exec date -d $date1 +%s]

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
# make_table
# {{{
proc make_table {rows header} {
  upvar fout fout

  puts $fout "<table class=table1 id=tbl>"
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

  # Comment out to disable global gl
  #if ![info exist meta] {
  #  foreach i $env(GODEL_META_SCOPE) { mload $i }
  #}

  set ilist [list]
  if {$opt(-f)} {
    set kin [open $listfile r]
      while {[gets $kin line] >= 0} {
        lappend ilist $line
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

  # Comment out to disable global gl
  #if ![info exist meta] {
  #  foreach i $env(GODEL_META_SCOPE) { mload $i }
  #}

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
# todo_table
# {{{
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
# }}}
# pagelist
# {{{
proc pagelist {{sort_by by_updated}} {
# ghtm_pagelist by_updated/by_size
  global env
  upvar fout fout
  #source $env(GODEL_META_CENTER)/meta.tcl
  source $env(HOME)/meta.tcl
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
  set kin [open $afile r]
    set ftxt [read $kin]
  close $kin

  #puts $ftxt
  return [::gmarkdown::md_convert $ftxt]
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

  set content [lindex $args 0]
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
#@> gnotes
# {{{
proc gnotes {args} {
  global env
  upvar fout fout
  upvar vars vars
  upvar count count
  upvar meta meta

  # -qnote (quick note)
  set opt(-qnote) 0
  set idx [lsearch $args {-qnote}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-qnote) 1
  }

  set content [lindex $args 0]

  if {$opt(-qnote)} {
    puts $content
  }
  

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

    set addr [gpage_where $iname]
    set pagename [gvars $iname g:pagename]
    set atxt "<a class=hbox2 href=$addr>$pagename</a>"
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

  set keywords $args

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
      regsub {\/} $k {} k
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
# read_timing_rpt_file
# {{{
proc read_timing_rpt_file {fname} {
# Read file in to line list
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
# }}}
#@=extract_a_timing_path
# {{{
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
# }}}
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
# }}}
# num_symbol
# {{{
proc num_symbol {num {symbol NA}} {
  set s(K) 1000
  set s(W) 10000
  set s(M) 1000000
  set s(Y) 100000000
  set s(B) 1000000000
  set s(T) 1000000000000
  if {$num == "NA"} {
    return "NA"
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
# godel_file_join
# {{{
proc godel_file_join {args} {
  foreach i $args {
    puts $i
  }
}
# }}}
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
#@> Godel Fundamental
#@=godel_draw
# {{{
proc godel_draw {{target_path NA}} {
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

  package require gmarkdown
  upvar vars vars
  global env
  upvar argv argv
  upvar just_draw just_draw
  upvar bvars bvars
  set ::toc_list [list]

  # source plugin script
# {{{
  set flist [glob $env(GODEL_PLUGIN)/*/*.tcl]
  foreach f $flist {
    #puts $f
    source $f 
  }
  if [info exist env(GODEL_USER_PLUGIN)] {
    set flist [glob -nocomplain $env(GODEL_USER_PLUGIN)/*.tcl]
    foreach f $flist { source $f }
  }
# }}}

  # default vars
# {{{
  if [file exist .godel/vars.tcl] {
    source .godel/vars.tcl
    godel_init_vars    g:keywords    ""
    godel_init_vars    g:pagename    [file tail [pwd]]
  } else {
    godel_init_vars    g:keywords    ""
    godel_init_vars    g:pagename    [file tail [pwd]]
  }
# }}}

  file mkdir .godel

# draw.gtcl
# {{{
  if ![file exist .godel/draw.gtcl] {
    set kout [open .godel/draw.gtcl w]
      puts $kout "source \$env(GODEL_ROOT)/bin/godel.tcl"
      puts $kout "set pagepath \[file dirname \[file dirname \[info script\]\]\]"
      puts $kout "cd \$pagepath"
      puts $kout "godel_draw"
      puts $kout "exec xdotool search --name \"Mozilla\" key ctrl+r"

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
  puts $fout "<title>$vars(g:pagename)</title>"

# Hardcoded w3.css in .index.htm so that you have all in one file.
# {{{
  puts $fout "<style>"
  set fin [open $env(GODEL_ROOT)/etc/css/w3.css r]
    while {[gets $fin line] >= 0} {
      puts $fout $line
    }
  close $fin
  puts $fout "</style>"
# }}}

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
  puts $fout "<script>"
  if [info exist rwords] {
    puts $fout "var target_words = \["
    foreach rword $rwords {
      puts $fout "\'$rword\',"
    }
    puts $fout "\];"
    puts $fout "word_highlight(target_words)"
  }
  puts $fout "</script>"
# }}}

  puts $fout "</body>"
  puts $fout "</html>"

  close $fout

# dyvars
# {{{
  if [file exist .godel/dyvars.tcl] {
    source .godel/dyvars.tcl
  }
  set dyvars(last_updated) [clock format [clock seconds] -format {%Y-%m-%d_%H%M}]
# }}}

  godel_array_save dyvars .godel/dyvars.tcl
  godel_array_save vars   .godel/vars.tcl

  godel_array_reset vars

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
# todo_set
# {{{
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
# }}}
# todo_create
# {{{
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
  godel_draw

# Go to todo directory
  cd $todopath

# Set title/keywords
  lsetvar $todonum title $title
  if ![info exist keywords] {
    set keywords ""
  }
  lsetvar $todonum g:keywords $keywords

  if ![info exist priority] {
    set priority 1
  }
  if ![info exist done] {
    set done 0
  }
  lsetvar $todonum priority   $priority
  lsetvar $todonum done       $done
  
}
# }}}
# todo_list, tlist
# {{{
proc todo_list {args} {
  global env
  set todo_path [gvars todo where]
  godel_array_reset meta

  set keywords $args
  set varfiles [glob -nocomplain */.godel/vars.tcl]

  foreach varfile $varfiles {
    source $varfile
    set todo [file dirname [file dirname $varfile]]
    lappend todolist $todo
    set meta($todo,keys) "$todo $vars(g:keywords)"
  }

# Search pagelist
  foreach i $todolist {
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
            set pagename [lvars $i g:pagename]
            set priority [lvars $i priority]
            set keywords [lvars $i g:keywords]
            set title    [lvars $i title]
            #puts stderr  [format "%s (%s) %s. (%s)" $pagename $priority $title $keywords]
            lappend dlist [list $pagename $priority $keywords $title]
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
  # -o (open)
# {{{
  set opt(-o) 0
  set idx [lsearch $args {-o}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-o) 1
  }
# }}}

# source user plugin
# {{{
  if [info exist env(GODEL_USER_PLUGIN)] {
    set flist [glob -nocomplain $env(GODEL_USER_PLUGIN)/*.tcl]
    foreach f $flist { source $f }
  }
# }}}

  foreach i $env(GODEL_META_SCOPE) { mload $i }
  if {$pagename == "."} {
    set meta(.,where) .
  }
  source $meta($pagename,where)/.godel/vars.tcl
  set where $meta($pagename,where)

# Open the page with firefox if -o
# {{{
  if {$opt(-o)} {
    cd $where
    puts "kkk"
    exec firefox .index.htm &
    return
  }
# }}}

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
# mscope
# {{{
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
# }}}
# mload
# {{{
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
# }}}
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
# {{{
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
# }}}
  # -k (keyword)
# {{{
  set opt(-k) 0
  set idx [lsearch $args {-k}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-k) 1
  }
# }}}
  # -d (delete)
# {{{
  set opt(-d) 0
  set idx [lsearch $args {-d}]
  if {$idx != "-1"} {
    set args [lreplace $args $idx $idx]
    set opt(-d) 1
  }
# }}}
  # -t (tvars)
# {{{
  set opt(-t) 0
  set idx [lsearch $args {-t}]
  if {$idx != "-1"} {
    set tvar_name [lindex $args [expr $idx + 1]]
    set args   [lreplace $args $idx [expr $idx + 1]]
    set opt(-t) 1
  }
# }}}
  
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

  if [info exist meta($pagename,where)] {
  } else {
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
        if [setop_and_hit $vname $name] {
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
#@>META
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
      set meta($i,keywords)     [lsort [concat $vars(g:keywords) ]]
# cdk use "keys" for searching
      if [info exist vars(title)] {
        set meta($i,keys)         [lsort [concat $i $vars(g:keywords) $vars(title)]]
      } else {
        set meta($i,keys)         [lsort [concat $i $vars(g:keywords) ]]
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
