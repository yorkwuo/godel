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
  gexe_button update.tcl -name update -cmd
  #bton_set -key sortby -name last -value last
  #bton_set -key sortby -name mtime -value mtime
  #bton_set -key sortby -name name  -value name
ghtm_panel_end

set sortby [lvars . sortby]

ghtm_panel_begin
  ghtm_onoff open     -name open
  ghtm_onoff mtime    -name mtime
  ghtm_onoff author   -name author
  ghtm_onoff fdel     -name fdel
  ghtm_onoff last     -name last
  ghtm_onoff keywords -name keywords
  ghtm_onoff title    -name title
  ghtm_onoff name     -name name
ghtm_panel_end

set atcols ""
atcols_onoff "mtime;mtime;mtime"
atcols_onoff "author;author;author"
atcols_onoff "fdel;proc:bton_fdelete;FD"
atcols_onoff "last;last;last"
atcols_onoff "keywords;keywords;keywords"
atcols_onoff "open;proc:at_open;O"
atcols_onoff "title;title;title"
atcols_onoff "name;name;name"
#lappend atcols "Vs;Vs"
#lappend atcols "path;path"

atable at.tcl -css table2 -dataTables -sortby $sortby -sortopt "-decreasing" -noid

#atable at.tcl

