ghtm_top_bar -save
pathbar 3
gnotes " # $vars(g:pagename)"
set rows ""
lappend rows "notes"
var_table

set gmdfiles [glob -nocomplain *.gmd]
foreach gmdfile $gmdfiles {
  gmd -f $gmdfile
}
