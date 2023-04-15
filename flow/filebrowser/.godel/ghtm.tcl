ghtm_top_bar -save

ghtm_panel_begin
  pathbar 4
ghtm_panel_end

set rows ""
lappend rows pattern
lappend rows maxdepth
var_table

gexe_button genflist.tcl -name genflist -cmd

set dirroot [lvars . dirroot]

proc fname {} {
  upvar row row
  upvar celltxt celltxt
  upvar atvar atvar

  set dirroot [lvars . dirroot]
  set path [get_atvar $row,path]
  set type [get_atvar $row,type]
  set txt  "<a href=$dirroot/$path type=text/txt>$path</a>"

  if {$type eq "d"} {
    set celltxt "<td bgcolor=lightblue>$path</td>"
  } else {
    set celltxt "<td>$txt</td>"
  }
}

set atcols ""
lappend atcols "proc:fname ;fname"

atable at.tcl -dataTables

