ghtm_top_bar -save -anew
gnotes "
# $vars(g:pagename)

"
toolarea_begin
  batch_onoff col_del      -name D
  batch_onoff col_tick     -name T
  batch_onoff col_title    -name title
  batch_onoff col_notes    -name notes
  batch_onoff col_keywords -name keywords

  ghtm_padding 40px

  batch_onoff dispatfile  -name atfile
  batch_onoff incr        -name incr
  batch_onoff search      -name Search

  ghtm_padding 40px

  batch_onoff toolarea    -name toolarea

  if {[lvars . atfile] eq "NA"} {
    puts $fout "<a href=at.tcl type=text/txt>at.tcl</a>"
  }
  if [file exist keywords.tcl] {
    puts $fout "<a href=keywords.tcl type=text/txt>keywords.tcl</a>"
  }
  if [file exist atcols.tcl] {
    puts $fout "<a href=atcols.tcl type=text/txt>atcols.tcl</a>"
  }
toolarea_end

# keywords
if [file exist keywords.tcl] { source keywords.tcl }

# atcols
if [file exist atcols.tcl] {
  source atcols.tcl
} else {
  set atcols ""
  atcols_onoff "col_del      ; proc:bton_delete ; D"
  atcols_onoff "col_tick     ; proc:abton_tick  ; T"
  atcols_onoff "col_title    ; ed:title         ; title"
  atcols_onoff "col_notes    ; ed:notes         ; notes"
  atcols_onoff "col_keywords ; ed:keywords      ; keywords"
}

atable at.tcl -noid -num -sortby id -sortopt {-ascii -decreasing} -dataTables
#atable at.tcl -noid -num -sortby id -sortopt {-ascii -increasing} -dataTables

