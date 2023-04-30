ghtm_top_bar -save
gnotes "
# $vars(g:pagename)

"
toolarea_begin
  gexe_button new.tcl -name new -nowin
  batch_onoff coldel      -name Del
  batch_onoff search      -name Search
  batch_onoff disppath    -name Path
  batch_onoff dispatfile  -name atfile
  batch_onoff toolarea    -name toolarea
  batch_onoff incr        -name incr
toolarea_end

# keywords
if [file exist keywords.tcl] { source keywords.tcl }

# atcols
if [file exist atcols.tcl] {
  source atcols.tcl
} else {
  set atcols ""
  lappend atcols "proc:bton_delete ; D"
  lappend atcols "ed:title         ; title"
  lappend atcols "ed:keywords      ; keywords"
  #lappend atcols "proc:abton_tick  ; T"
}

atable at.tcl -noid -num -sortby id -sortopt {-ascii -decreasing} -dataTables
#atable at.tcl -noid -num -sortby id -sortopt {-ascii -increasing} -dataTables

