ghtm_top_bar -save
gnotes " # $vars(g:pagename)"

# keywords
if [file exist keywords.tcl] {
  source keywords.tcl
}

#set indexcol 1
#ghtm_panel_begin
#  ghtm_keyword_button tbl $indexcol ECO
#ghtm_panel_end
gexe_button newrow.tcl -name newrow
ghtm_onoff coldel -name Del
ghtm_onoff search -name Search
ghtm_onoff path -name Path

if {[lvars . path] eq "1"} {
  puts $fout <p>[pwd]</p>
}


source at.tcl

# linkurl
# {{{
proc linkurl {} {
  upvar env     env
  upvar atvar   atvar
  upvar row     row
  upvar celltxt celltxt

  set urlvalue [get_atvar $row,url]

  if {$urlvalue eq "NA"} {
    set celltxt "<td gname=\"$row\" colname=\"url\" contenteditable=\"true\"></td>"
  } else {
    if {[info exist env(GODEL_WSL)] && $env(GODEL_WSL) eq "1"} {
      set celltxt "<td><button onclick=\"chrome_open('$urlvalue')\">url</button></td>"
    } else {
      set celltxt "<td><a href=\"$urlvalue\">url</td>"
    }
  }
}
# }}}

set atcols ""
if {[lvars . coldel] eq "1"} {
  lappend atcols "proc:at_delete;del"
}
lappend atcols "proc:linkurl;url"
lappend atcols "type;type"
lappend atcols "name;name"

if {[lvars . search] eq "1"} {
  atable at.tcl -dataTables -noid -sortby name -sortopt {-increasing}
} else {
  atable at.tcl -noid -sortby name -sortopt {-increasing}
}

# vim:fdm=marker
