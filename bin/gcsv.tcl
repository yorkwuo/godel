#!/usr/bin/tclsh
source ~/godel.tcl

proc ghtm_top_bar {args} {
}
# local_table
proc local_table {name args} {
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

  if {$opt(-save)} {
  puts "<button id=\"save\">Save</button>"
  }
  if {$opt(-fontsize)} {
    puts "<style>"
    puts ".table1 td, .table1 th {"
    puts "font-size : $fontsize;"
    puts "}"
    puts "</style>"
  }
# Table Headers
# {{{
  if {$opt(-serial)} {
    puts "<th>Num</th>"
  }
  foreach col $columns {
    set colname ""
    regexp {;(\S+)} $col -> colname

    if {$colname == ""} {
      set colname $col
    } 
    lappend csvcolname "$colname"
  }
  puts [join $csvcolname ,]
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
    set csvrow {}

    # row_style_proc
    if {$opt(-row_style_proc)} {
      row_style_proc
    }


    if {$opt(-serial)} {
      puts "<td><a href=$row/.index.htm>$serial</a></td>"
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
        set coverfile [glob -nocomplain $row/cover.*]
        if {$coverfile eq ""} {
          set coverfile "cover.jpg"
        }
        append celltxt "<td><a href=$coverfile><img height=100px src=$coverfile></a></td>"
      # exe_button:
      } elseif [regexp {exe_button:} $col] {
        regsub {exe_button:} $col {} col
        set execmd [lvars $row execmd]
        #append celltxt "<td><a href=$coverfile><img height=100px src=$coverfile></a></td>"
        append celltxt "<td><a href=$row/.$execmd.gtcl class=\"w3-btn w3-teal\" type=text/gtcl>$execmd</a><a class=\"w3-button w3-lime\" href=$row/$execmd type=text/txt>cmd</a></td>"

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
          if [regexp {\.pdf} $name] {
            append links "<a href=\"$f\" type=text/pdf>$name</a>\n"
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
        append celltxt "$col_data"
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
          set col_data "$col_data"
        }

        append celltxt "$col_data"
      }
#      puts -nonewline ,$celltxt
      lappend csvrow $celltxt
    }
    puts [join $csvrow ","]

    incr serial
  }

}
proc ghtm_ls {args} {
}
proc gnotes {args} {
}

source .godel/ghtm.tcl

# vim:fdm=marker
