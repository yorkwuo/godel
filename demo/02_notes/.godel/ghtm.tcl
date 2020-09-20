ghtm_top_bar -save -filter 1

ghtm_newnote

proc flist {} {
  upvar celltxt celltxt
  upvar row     row

  set celltxt "<td><a href=$row/.godel/ghtm.tcl type=text/txt>ghtm</a></td>"
}

lappend cols g:pagename
lappend cols "proc:flist;flist"
lappend cols edtable:g:title
lappend cols g:iname

local_table tbl -c $cols -sortby "g:iname;d"

