ghtm_top_bar -save -new
set sortby [lvars . sortby]
set search [lvars . search]

pathbar [lvars . pathvar_depth]

#------------------------------------
# Class
#------------------------------------
  if [file exist "class.tcl"] {
    source class.tcl
  }

#------------------------------------
# Columns OnOff
#------------------------------------
#toolarea_begin

  batch_onoff col_class    -name class
  batch_onoff coldel       -name D
  batch_onoff coltick      -name T
  batch_onoff col_cdate    -name cdate
  batch_onoff col_iname    -name iname
  batch_onoff col_ghtm     -name ghtm
  batch_onoff col_title    -name title
  batch_onoff col_notes    -name notes
  batch_onoff col_keywords -name keywords

  ghtm_padding 40px

  batch_onoff search   -name Search
  batch_onoff toolarea -name toolarea
  if [file exist "cols.tcl"]  { puts $fout "<a href=cols.tcl type=text/txt>cols.tcl</a>" }
  if [file exist "class.tcl"] { puts $fout "<a href=class.tcl type=text/txt>class.tcl</a>" }
#toolarea_end

#------------------------------------
# Columns
#------------------------------------
#if [file exist cols.tcl] {
#  source cols.tcl
#} else {
#  cols_onoff "col_class;ed:class;Class"
#  cols_onoff "coldel;proc:bton_delete;D"
#  cols_onoff "coltick;proc:bton_tick;T"
#  cols_onoff "col_cdate;cdate;cdate"
#  cols_onoff "col_iname;g:iname;iname"
#  cols_onoff "col_ghtm;proc:ltbl_lnfile .godel/ghtm.tcl ghtm;ghtm"
#  #cols_onoff "col_title;proc:ltbl_iname g:pagename;g:pagename"
#  set cols "ed:g:pagename;g:pagename"
#  cols_onoff "col_notes;ed:notes;Notes"
#  cols_onoff "col_keywords;ed:g:keywords;Keywords"
#}
  set cols ""
  lappend cols "ed:class                              ; Class"
  lappend cols "proc:bton_delete                      ; D"
  lappend cols "proc:bton_tick                        ; T"
  #lappend cols "cdate                                 ; cdate"
  #lappend cols "g:iname                               ; iname"
  #lappend cols "proc:ltbl_lnfile .godel/ghtm.tcl ghtm ; ghtm"
  lappend cols "ed:notes                              ; Notes"
  lappend cols "ed:g:keywords                         ; Keywords"
  lappend cols "ed:g:pagename                         ; g:pagename"

#------------------------------------
# Table Options
#------------------------------------
set options "-serial "
append options "-sortby $sortby "
if {$search eq "1"} {
  append options "-dataTables"
}

if ![info exist cols] {
  lappend cols "g:iname;iname"
}
local_table tbl -c $cols {*}$options


# vim:fdm=marker
