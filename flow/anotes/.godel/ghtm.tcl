ghtm_top_bar -save
gnotes "
# $vars(g:pagename)

"
gexe_button newnote.tcl -name new -nowin
# keywords
if [file exist keywords.tcl] {
  source keywords.tcl
}

if [file exist atcols.tcl] {
  source atcols.tcl
} else {
  set atcols ""
  lappend atcols "ed:title         ; title"
  lappend atcols "ed:keywords      ; keywords"
  lappend atcols "proc:bton_delete ; D"
  #lappend atcols "proc:abton_tick  ; T"
}

atable at.tcl -noid -num -sortby name -sortopt {-ascii -decreasing} -dataTables

