ghtm_top_bar -save
gnotes "
# $vars(g:pagename)

[pwd]
"
gexe_button update.tcl -cmd

if [file exist "keywords.tcl"] {
  source keywords.tcl
}

set atcols ""
lappend atcols "mtime;mtime"
lappend atcols "proc:at_open;O"
lappend atcols "proc:at_fdel_status;fdel"
lappend atcols "proc:at_fdel;fdel"
lappend atcols "last;last"
#lappend atcols "name;name"
#lappend atcols "Vs;Vs"
lappend atcols "keywords;keywords"
#lappend atcols "path;path"

atable at.tcl -css table2 -dataTables
#atable at.tcl

