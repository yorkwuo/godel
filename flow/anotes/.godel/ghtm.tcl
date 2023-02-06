ghtm_top_bar -save
gnotes "
# $vars(g:pagename)

"
toolarea_begin
  gexe_button newrow.tcl -name new -nowin
  ghtm_onoff coldel      -name Del
  ghtm_onoff search      -name Search
  ghtm_onoff disppath    -name Path
  ghtm_onoff dispatfile  -name atfile
  ghtm_onoff toolarea    -name toolarea
  ghtm_onoff incr        -name incr
toolarea_end

# keywords
if [file exist keywords.tcl] { source keywords.tcl }

# atcols
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

