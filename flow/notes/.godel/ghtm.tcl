ghtm_top_bar -save
set sortby [lvars . sortby]
set search [lvars . search]

gnotes "
# $vars(g:pagename)
"

toolarea_begin
#  set rows ""
#  lappend rows sortby
#  var_table
#
  gexe_button newnote.tcl -nowin -name "new"
  ghtm_onoff coldel -name Del
  ghtm_onoff search -name Search
  ghtm_onoff path -name Path
  ghtm_onoff toolarea -name toolarea
toolarea_end

if {[lvars . path] eq "1"} {
  puts $fout <p>[pwd]</p>
}

if {[lvars . coldel] eq "1"} { lappend cols "proc:bton_delete;D" }

if [file exist cols.tcl] {
  source cols.tcl
} else {
  lappend cols "ed:class;Class"
  lappend cols "ed:g:pagename;Title"
  lappend cols "ed:g:keywords;Keywords"
}

set options "-serial "
append options "-sortby $sortby "
if {$search eq "1"} {
  append options "-dataTables"
}

local_table tbl -c $cols {*}$options


# vim:fdm=marker
