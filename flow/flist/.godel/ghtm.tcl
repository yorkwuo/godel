ghtm_top_bar -save
gnotes "
# $vars(g:pagename)

[pwd]
"
ghtm_ls at.tcl
if [file exist "keywords.tcl"] {
  source keywords.tcl
}
ghtm_panel_begin
  gexe_button update.tcl -name update -cmd -nowin
  ghtm_set_value sortby name  -name name
  ghtm_set_value sortby mtime -name mtime
  ghtm_set_value sortby last  -name last
ghtm_panel_end

set sortby [lvars . sortby]

ghtm_panel_begin
  ghtm_onoff colopen     -name open
  ghtm_onoff colmtime    -name mtime
  ghtm_onoff colauthor   -name author
  ghtm_onoff colfdel     -name fdel
  ghtm_onoff collast     -name last
  ghtm_onoff colkeywords -name keywords
  ghtm_onoff coltitle    -name title
  ghtm_onoff colname     -name name
ghtm_panel_end

set atcols ""
atcols_onoff "colmtime    ; mtime             ; mtime"
atcols_onoff "colauthor   ; author            ; author"
atcols_onoff "colfdel     ; proc:bton_fdelete ; FD"
atcols_onoff "collast     ; last              ; last"
atcols_onoff "colkeywords ; ed:keywords       ; keywords"
atcols_onoff "coltitle    ; ed:title          ; title"
atcols_onoff "colopen     ; proc:at_open      ; O"
atcols_onoff "colname     ; name              ; name"
#lappend atcols "Vs;Vs"
#lappend atcols "path;path"

atable at.tcl -css table1 -dataTables -sortby $sortby -sortopt "-decreasing" -noid

#atable at.tcl

