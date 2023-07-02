ghtm_top_bar -save -js

source genflist.tcl

#ghtm_panel_begin
#  pathbar 4
#ghtm_panel_end

set dirroot [lvars . dirroot]
set dirlist [lvars . dirlist]

set dds [split $dirroot /]

for {set i 1} {$i < [llength $dds]} {incr i} {
  set fullpath [join [lrange $dds 0 $i] /]
  ghtm_set_value dirroot $fullpath -name [file tail $fullpath]
}

puts $fout <br>
ghtm_set_value maxdepth 1 -name depth1
ghtm_set_value maxdepth 2 -name depth2
ghtm_set_value maxdepth 3 -name depth3
ghtm_set_value maxdepth 4 -name depth4

puts $fout <br>

if {$dirlist eq ""} {
} else {
  foreach dir $dirlist {
    puts $fout "<button class=\"w3-ripple w3-btn w3-white w3-border w3-border-blue w3-round-large\" onclick=\"change_dir('$dir','$dirroot/')\">$dir</button><br>"
  }
}
puts $fout <br>

  #gexe_button genflist.tcl -name genflist -cmd
  set rows ""
  lappend rows dirroot
  lappend rows pattern
  #lappend rows maxdepth
  var_table

puts $fout "<button class=\"w3-ripple w3-btn w3-white w3-border w3-border-blue w3-round-large\" onclick=\"clear_input()\">clear</button><br>"


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
lappend atcols "size;size"
lappend atcols "mtime;mtime"
lappend atcols "proc:fname ;fname"
lappend atcols "proc:at_remote_open     ; O"

atable at.tcl -dataTables

