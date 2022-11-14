ghtm_top_bar -save
gnotes "
# $vars(g:pagename)

[pwd]
"

if [file exist "keywords.tcl"] {
  source keywords.tcl
}
ghtm_panel_begin
  gexe_button update.tcl -name update -cmd
  bton_set -key sortby -name mtime -value mtime
  bton_set -key sortby -name name  -value name
ghtm_panel_end

set sortby [lvars . sortby]

ghtm_panel_begin
  bton_onoff -key open -name open
  bton_onoff -key mtime -name mtime
  bton_onoff -key author -name author
  bton_onoff -key S -name S
  bton_onoff -key fdel -name fdel
  bton_onoff -key last -name last
  bton_onoff -key keywords -name keywords
  bton_onoff -key title -name title
  bton_onoff -key name -name name
ghtm_panel_end

set atcols ""
atcols_onoff "mtime;mtime;mtime"
atcols_onoff "author;author;author"
atcols_onoff "S;proc:at_fdel_status;S"
atcols_onoff "fdel;proc:at_fdel;fdel"
atcols_onoff "last;last;last"
atcols_onoff "keywords;keywords;keywords"
atcols_onoff "open;proc:at_open;O"
atcols_onoff "title;title;title"
atcols_onoff "name;name;name"
#lappend atcols "Vs;Vs"
#lappend atcols "path;path"

atable at.tcl -css table2 -dataTables -sortby $sortby -sortopt "-decreasing" -noid

#atable at.tcl

