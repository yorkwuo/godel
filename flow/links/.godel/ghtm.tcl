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

toolarea_begin
  gexe_button newrow.tcl -name new -nowin
  ghtm_onoff dispedit    -name Edit
  #ghtm_onoff coldel     -name Del
  ghtm_onoff search      -name Search
  ghtm_onoff disppath    -name Path
  ghtm_onoff dispatfile  -name atfile
  ghtm_onoff toolarea    -name toolarea
  ghtm_onoff incr        -name incr
toolarea_end

if {[lvars . incr] eq "1"} {
  set direction "-increasing"
} else {
  set direction "-decreasing"
}

if {[lvars . disppath] eq "1"} {
  puts $fout "<p>[pwd]</p>"
}
if {[lvars . dispatfile] eq "1"} {
  puts $fout "<a href=at.tcl type=text/txt>at.tcl</a>"
}

source at.tcl


set atcols ""
atcols_onoff "dispedit         ; proc:bton_delete ; D"
atcols_onoff "dispedit         ; proc:alinkurl    ; url"
atcols_onoff "dispedit         ; ed:name          ; name"
lappend atcols "ed:type           ; type"
lappend atcols "proc:alinkname ; name"

if {[lvars . search] eq "1"} {
  atable at.tcl -dataTables -noid -sortby id -sortopt $direction -num
} else {
  atable at.tcl -noid -sortby id -sortopt $direction -num
}

# vim:fdm=marker
