
proc list_svg {fname} {
  upvar fout fout

  puts $fout "<a href=$fname type=text/svg>$fname</a><br>"
  set kin [open $fname r]
  set content [read $kin]
  puts $fout $content
  close $kin
}

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
proc ghtm_filter_ls {} {
  upvar fout fout
  puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">" 
  puts $fout "<input type=text id=filter_input onKeyPress=filter_ghtmls(event) placeholder=\"Search...\">"
  puts $fout "</div>" 
}
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
proc fdiff {} {
  upvar vars  vars
  upvar files files

  source .godel/dyvars.tcl
  if ![info exist dyvars(srcpath)] {
    puts "Error: vars not exist... \$dyvars(srcpath)"
    return
  }
  set srcpath $dyvars(srcpath)

  foreach f $files {
    set dir [file dirname $srcpath/$f]
    if [file exist $dir] {
      catch {exec diff $f $srcpath/$f | wc -l} result
      if {$result > 0} {
        puts "\033\[0;92m# $f\033\[0m"
        puts [lindex $result 0]
        puts "tkdiff $f $srcpath/$f"
        puts "cp     $f $srcpath/$f"
        puts "cp     $srcpath/$f $f"
      }

    } else {
      if {[file tail $dir] eq ".godel"} {
        puts "gdir [file dirname $dir]"
      } else {
        puts "mkdir $dir"
      }
    }
    #puts $result
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
proc fpush {} {
  upvar vars vars
  upvar files files
  source .godel/dyvars.tcl
  if ![info exist dyvars(srcpath)] {
    puts "Error: dyvars not exist... \$dyvars(srcpath)"
    return
  }
  set srcpath $dyvars(srcpath)

  foreach f $files {
    puts "cp $f $srcpath/$f"
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
proc ghtm_keyword_button {tablename column keyword} {
  global fout
  puts $fout "<button onclick=filter_table_keyword(\"$tablename\",$column,\"$keyword\")>$keyword</button>"
}
# }}}
# ghtm_ls
# {{{
proc ghtm_ls {pattern {description ""}} {
  upvar env env
  upvar fout fout

  #puts $fout "<div><h5>Filelist$description<a href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_list_files.tcl] type=text/txt>(script)</a></h5></div>"
  set flist [lsort [glob -nocomplain -type d $pattern]]
  puts $fout <p>
  #puts $fout [pwd]/$pattern
  set count 1
  foreach full $flist {
    set fname [file tail $full]
    set mtime [file mtime $full]
    set timestamp [clock format $mtime -format {%Y-%m-%d %H:%M}]
    set fsize [file size $full]
    set fsize [num_symbol $fsize M]
    puts $fout [format "<div class=ghtmls><pre style=background-color:lightblue>%-3s %s %-5s %s</pre>" $count $timestamp $fsize "<a class=keywords href=\"$full\">$fname</a><br></div>"]
    incr count
  }
  puts $fout </p>

  set flist [lsort [glob -nocomplain -type f $pattern]]
  puts $fout <p>
  #puts $fout [pwd]/$pattern
  set count 1
  foreach full $flist {
    set fname [file tail $full]
    set mtime [file mtime $full]
    set timestamp [clock format $mtime -format {%Y-%m-%d %H:%M}]
    set fsize [file size $full]
    set fsize [num_symbol $fsize M]
    puts $fout [format "<div class=ghtmls><pre style=background-color:white>%-3s %s %-5s %s</pre>" $count $timestamp $fsize "<a class=keywords href=\"$full\" type=text/txt>$fname</a><br></div>"]
    incr count
  }
  puts $fout </p>
  
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

  if [file exist .godel/dyvars.tcl] {
    source .godel/dyvars.tcl
  } else {
    set dyvars(last_updated) Now
  }

  set timestamp [clock format [clock seconds] -format {%Y-%m-%d_%H:%M}]
# default flow_name
  #if ![info exist flow_name] {
  #  set flow_name default
  #}

  set cwd [pwd]
  #file copy -force $env(GODEL_ROOT)/scripts/js/godel.js .godel/js
  #exec cp $env(GODEL_ROOT)/scripts/js/godel.js .godel/js
  #file copy -force $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js .godel/js
  #exec cp $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js .godel/js

  #puts $fout "<script src=.godel/js/jquery-3.3.1.min.js></script>"
  #puts $fout "<script src=.godel/js/godel.js></script>"
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
  #puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/godel.js]></script>"
  #puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js]></script>"
  #puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/prism/prism.js]></script>"

  puts $fout "<ul id=stickymenu class=solidblockmenu>"
  puts $fout "<li><a href=.godel/ghtm.tcl type=text/txt>Edit</a></li>"
  puts $fout "<li><a href=.godel/vars.tcl type=text/txt>Value</a></li>"
  if {$opt(-save)} {
    if {$saveid eq ""} {set saveid "save"}
  puts $fout "<li><button id=\"$saveid\" style=\"margin: 10px 6px\">Save</button></li>"
  }
  if {$opt(-filter)} {
  puts $fout "<li><input type=text id=filter_table_input onkeyup=filter_table(\"tbl\",$tblcol,event) placeholder=\"Search...\"></li>"
  }
  puts $fout "<li><a href=../.index.htm>Parent</a></li>"
  puts $fout "<li><a href=.godel/draw.gtcl type=text/gtcl>Draw</a></li>"
  #puts $fout "<li style=float:right><a href=.main.htm>TOC</a></li>"
  puts $fout "<li style=float:right><a href=.godel/open.gtcl type=text/gtcl>Open</a></li>"
  puts $fout "<li style=float:right><a href=.index.htm type=text/txt>HTML</a></li>"
  puts $fout "<li style=float:right><a>$timestamp</a></li>"
  puts $fout "</ul>"
  puts $fout "<br>"
#  puts $fout "<div class=\"w3-bar w3-border w3-indigo w3-medium\">"
## Edit
#  puts $fout "  <div><a href=.godel/ghtm.tcl type=text/txt class=\"w3-bar-item w3-button w3-hover-red\">Edit</a></div>"
## Values
#  puts $fout "  <div><a href=.godel/vars.tcl type=text/txt class=\"w3-bar-item w3-button w3-hover-red\">Values</a></div>"
## Draw
#  puts $fout "  <div><a href=.godel/draw.gtcl type=text/gtcl class=\"w3-bar-item w3-button w3-hover-red\">Draw</a></div>"
## Parent
#  puts $fout "  <div><a href=../.index.htm class=\"w3-bar-item w3-button w3-hover-red\">Parent</a></div>"
## 
#  #puts $fout "  <div><div id=\"div\" class=\"w3-bar-item w3-button w3-hover-red\" style=\"width:20px;height:20px;\" contenteditable=\"true\"></div></div>"
## TOC
#  puts $fout "  <div><a href=.main.htm  class=\"w3-bar-item w3-button w3-hover-red\">TOC</a></div>"
#  set path_help     [tbox_cygpath $env(GODEL_ROOT)/docs/help/.index.htm]
#  set path_pagelist [tbox_cygpath $env(GODEL_META_CENTER)/pagelist/.index.htm]
#  set path_draw     [tbox_cygpath $env(GODEL_ROOT)/plugin/gdraw/gdraw_$flow_name.tcl]
#  puts $fout "<div class=\"w3-dropdown-click w3-right\">"
#  puts $fout "  <button onclick=\"myFunction()\" class=\"w3-button w3-hover-red\">More</button>"
#  puts $fout "  <div id=\"Demo\" class=\"w3-dropdown-content w3-bar-block w3-card-4\">"
#  #puts $fout "    <a href=\".main.htm\"                     class=\"w3-bar-item w3-button\">Table of Content</a>"
#  puts $fout "    <a href=\".index.htm\"      type=text/txt class=\"w3-bar-item w3-button\">HTML</a>"
#  #puts $fout "    <a href=\"$path_help\"                    class=\"w3-bar-item w3-button\">Help</a>"
#  #puts $fout "    <a href=\"$path_pagelist\"                class=\"w3-bar-item w3-button\">Pagelist</a>"
#  puts $fout "    <a href=\".godel/proc.tcl\" type=text/txt class=\"w3-bar-item w3-button\">Proc</a>"
#  puts $fout "  </div>"
#  puts $fout "</div>"
  
  #puts $fout "  <div class=\"w3-bar-item w3-button w3-hover-red w3-right\">$timestamp</div>"

#  puts $fout "</div>"


  #puts $fout "<textarea rows=10 cols=70 id=\"text_board\" style=\"display:none;font-size:10px\"></textarea>"

  #puts $fout "<script>"
  #puts $fout "function myFunction() {"
  #puts $fout "    var x = document.getElementById(\"Demo\");"
  #puts $fout "    if (x.className.indexOf(\"w3-show\") == -1) {"
  #puts $fout "        x.className += \" w3-show\";"
  #puts $fout "    } else { "
  #puts $fout "        x.className = x.className.replace(\" w3-show\", \"\");"
  #puts $fout "    }"
  #puts $fout "}"
  #
  #set server $env(GODEL_SERVER)
  #set pwd    [pwd]
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
  # }}}

# Start creating table...
#  if {$opt(-css)} {
#    puts $fout "<table class=$css_class id=$name>"
#  } else {
#    puts $fout "<table class=table2 id=$name>"
#  }
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
  if {$opt(-edit)} {
    puts $fout "<th>e</th>"
    puts $fout "<th>v</th>"
  }
  if {$opt(-serial)} {
    puts $fout "<th>Num</th>"
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

    ## Create row_items for sorting
    set row_items {}
    foreach row $rows {
      #puts $row
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

    if {$opt(-edit)} {
      puts $fout "<td><a href=\"$row/.godel/ghtm.tcl\" type=text/txt>e</a></td>"
      puts $fout "<td><a href=\"$row/.godel/vars.tcl\" type=text/txt>v</a></td>"
    }
    if {$opt(-serial)} {
      puts $fout "<td>$serial</td>"
    }
    #----------------------
    # For each table column
    #----------------------
    foreach col $columns {
      set celltxt {}
      # Remove column width
      regsub {;\S+} $col {} col

      # Get column data
      #puts "$row $col"
      #puts "$row/[file dirname $col]"
      # img:
      if [regexp {img:} $col] {
        regsub {img:} $col {} col
        append celltxt "<td><a href=$row/images/cover.jpg><img height=100px src=$row/images/cover.jpg></a></td>"
      # proc:
      } elseif [regexp {proc:} $col] {
        regsub {proc:} $col {} col
        set procname $col
        #cd $row
        eval $procname
        #cd ..
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
          append links "<a href=\"$f\" type=text/txt>$name</a>\n"
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
      # a:
      } elseif [regexp {a:} $col] {
        regsub {a:} $col {} col
        set col_data [lvars $row $col]
        if [file exist $col_data] {
          append celltxt "<td><a href=$col_data type=text/txt>$col_data</a></td>"
        } else {
          append celltxt "<td>NA: $col_data</td>"
        }
      # ln:
      } elseif [regexp {ln:} $col] {
        regsub {ln:} $col {} col
        regexp {=(\S+)$} $col -> key
        regsub {=\S+$} $col {} col

        if {$key == ""} {
          set disp $col
        } else {
          set disp [lvars $row $key]
        }
        set fname $row/$col
        if [file exist $fname] {
          append celltxt "<td><a href=$fname type=text/txt>$disp</a></td>"
        } else {
          append celltxt "<td>NA: $col</td>"
        }
      # lnf:
      } elseif [regexp {lnf:} $col] {
        regsub {lnf:} $col {} col
        regexp {=(\S+)$} $col -> disp
        regsub {=\S+$} $col {} col

        set fname $row/$col
        if [file exist $fname] {
          append celltxt "<td><a href=$fname>$disp</a></td>"
        } else {
          append celltxt "<td>NA: $fname</td>"
        }
      # edfile:
      } elseif [regexp {edfile:} $col] {
        regsub {edfile:} $col {} col
        regexp {=(\S+)$} $col -> disp
        regsub {=\S+$} $col {} col

        set fname $row/$col
        if [file exist $fname] {
          append celltxt "<td><a href=$fname type=text/txt>$disp</a></td>"
        } else {
          append celltxt "<td>NA: $fname</td>"
        }
      # invisible:
      } elseif [regexp {invisible:} $col] {
        regsub {invisible:} $col {} col
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
        append celltxt "<td>$col_data</td>"
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

        # linkcol
        if {$col == $linkcol} {
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
    puts $kout "#lappend cols g:pagename"
    puts $kout "#lappend cols edtable:g:keywords"
    puts $kout "#local_table tbl -c \$cols"
    puts $kout "ghtm_list_files *"
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

  # Comment out to disable global gl
  #if ![info exist meta] {
  #  foreach i $env(GODEL_META_SCOPE) { mload $i }
  #}

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

  ghtm_table_nodir tbl 0
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
    #set delim {,}
    set delim {:}
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
  set flist [glob -nocomplain $env(GODEL_PLUGIN)/*/*.tcl]
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
    godel_init_vars    g:iname       [file tail [pwd]]
  } else {
    godel_init_vars    g:keywords    ""
    godel_init_vars    g:pagename    [file tail [pwd]]
    godel_init_vars    g:iname       [file tail [pwd]]
  }
# }}}

  file mkdir .godel

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
#  puts $fout "<style>"
#  set fin [open $env(GODEL_ROOT)/etc/css/w3.css r]
#    while {[gets $fin line] >= 0} {
#      puts $fout $line
#    }
#  close $fin
#  puts $fout "</style>"
## }}}

  if {$env(GODEL_ALONE)} {
# Standalone w3.css
# {{{
    exec cp $env(GODEL_ROOT)/etc/css/w3.css .godel/w3.css
    puts $fout "<link rel=\"stylesheet\" type=\"text/css\" href=\".godel/w3.css\">"
# }}}
  } else {
# Link to Godel's central w3.css
# {{{
    puts $fout "<link rel=\"stylesheet\" type=\"text/css\" href=\"$env(GODEL_ROOT)/etc/css/w3.css\">"
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

  set kout [open .godel/dyvars.tcl w]
  close $kout
  set kout [open .godel/vars.tcl w]
  close $kout
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
#: split_by
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
          puts stderr "\033\[0;92m$txt\033\[0m"
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
# fget: flow get
# {{{
proc fget {pagename {flowname ""} {localname ""}} {
  global env
  upvar meta meta
  if ![info exist meta] {
    foreach i $env(GODEL_META_SCOPE) { mload $i }
  }
  
  if [file exist $pagename] {
    set meta($pagename,where) [pwd]/$pagename
  }

  foreach i $env(GODEL_META_SCOPE) { mload $i }
  if {$pagename == "."} {
    set meta(.,where) .
  }
  source $meta($pagename,where)/.godel/vars.tcl
  set where $meta($pagename,where)

  if [file exist $meta($pagename,where)/.godel/proc.tcl] {
    source $meta($pagename,where)/.godel/proc.tcl
  }
  if {$flowname == ""} {
    help
  } else {
    if {$localname eq ""} {
      if [file exist $flowname] {
        puts "Skip: Dir already exist... $flowname"
      } else {
        puts "cp -r $where/$flowname ."
        exec cp -r $where/$flowname .
      }
    } else {
      if [file exist $localname] {
        puts "Skip: Dir already exist... $localname"
      } else {
        puts "cp -r $where/$flowname $localname"
        exec cp -r $where/$flowname $localname
      }
    }
  }
}
# }}}
# gget
# {{{
proc gget {pagename args} {
  global env
  upvar meta meta
  if ![info exist meta] {
    foreach i $env(GODEL_META_SCOPE) { mload $i }
  }
  
  if [file exist $pagename] {
    set meta($pagename,where) [pwd]/$pagename
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
#: pcollection_list
# {{{
proc pcollection_list {ll} {
  foreach_in_collection i $ll {
    puts [get_attribute $i full_name]
  }
}
# }}}
#@> Tool Box
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
      #set meta($i,class)        $vars(g:class)
      set meta($i,keywords)     [lsort [concat $vars(g:keywords)]]
      #set meta($i,pagesize)     $vars(pagesize)
      set meta($i,where)        $vars($i,where)
# cdk use "keys" for searching
      if [info exist vars(title)] {
        set meta($i,keys)         [lsort [concat $i $vars(g:keywords) $vars(title)]]
      } else {
        set meta($i,keys)         [lsort [concat $i $vars(g:keywords)]]
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
  source $env(GODEL_META_FILE)
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
      godel_array_save meta $env(GODEL_META_FILE)
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
      godel_array_save meta $env(GODEL_META_FILE)
      cd $org_path
      return 1
    }
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
