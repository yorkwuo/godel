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
gexe_button newrow.tcl -name new -nowin
ghtm_onoff coldel -name Del
ghtm_onoff search -name Search
ghtm_onoff disppath -name Path
ghtm_onoff colurl -name URL
ghtm_onoff dispatfile -name atfile

if {[lvars . disppath] eq "1"} {
  puts $fout "<p>[pwd]</p>"
}
if {[lvars . dispatfile] eq "1"} {
  puts $fout "<a href=at.tcl type=text/txt>at.tcl</a>"
}

source at.tcl


set atcols ""
atcols_onoff "coldel;proc:bton_delete;D"
atcols_onoff "colurl;proc:alinkurl;url"
lappend atcols "type;type"
lappend atcols "ed:name;name"
lappend atcols "proc:alinkname;name"

if {[lvars . search] eq "1"} {
  atable at.tcl -dataTables -noid -sortby g:iname -sortopt {-increasing} -num
} else {
  atable at.tcl -noid -sortby g:iname -sortopt {-increasing} -num
}

# vim:fdm=marker
