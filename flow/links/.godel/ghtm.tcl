ghtm_top_bar -save -anew -js
pathbar 1

ghtm_table_col_onoff tbl D
ghtm_table_col_onoff tbl Link

set js_func2exec ""
lappend js_func2exec "init_table_col_onoff('tbl')"
lappend js_func2exec "init_col_button('tbl')"

# keywords
if [file exist keywords.tcl] {
  source keywords.tcl
}

toolarea_begin
  batch_onoff col_del     -name D
  batch_onoff col_type    -name type

  ghtm_padding 40px

  batch_onoff col_incr       -name incr
  batch_onoff col_search     -name Search
  batch_onoff col_dispatfile -name atfile
  batch_onoff disp_id        -name id

  ghtm_padding 40px

  if {[lvars . col_dispatfile] eq "1"} {
    puts $fout "<a href=at.tcl type=text/txt>at.tcl</a>"
  }

  ghtm_padding 40px

  batch_onoff toolarea   -name toolarea

toolarea_end

if {[lvars . incr] eq "1"} {
  set direction "-increasing"
} else {
  set direction "-decreasing"
}
if {[lvars . disp_id] eq "1"} {
  set disp_id "-id"
} else {
  set disp_id "-noid"
}

source at.tcl


set atcols ""
atcols_onoff "col_del  ; proc:bton_delete ; D"
atcols_onoff "col_type ; ed:type          ; type"
lappend atcols "proc:alinkurl    ; Link"
lappend atcols "proc:alinkname ; name"

if {[lvars . search] eq "1"} {
  atable at.tcl -dataTables $disp_id -sortby id -sortopt $direction -num
} else {
  atable at.tcl $disp_id -sortby id -sortopt $direction -num
}

# vim:fdm=marker
