ghtm_top_bar -save
gnotes "
# $vars(g:pagename)

[pwd]
"
ghtm_ls at.tcl
if [file exist "class.tcl"] {
  source class.tcl
}
ghtm_panel_begin
  gexe_button update.tcl -name update -cmd -nowin
  gexe_button move.tcl -name move -cmd -nowin
  ghtm_set_value sortby name  -name name
  ghtm_set_value sortby mtime -name mtime
  ghtm_set_value sortby last  -name last
  ghtm_onoff level1  -name level1
  if [file exist "at.tcl"]  { puts $fout "<a href=at.tcl type=text/txt>at.tcl</a>" }
  if [file exist "class.tcl"] { puts $fout "<a href=class.tcl type=text/txt>class.tcl</a>" }

ghtm_panel_end

set sortby [lvars . sortby]

if [file exist colist.tcl] {
  source colist.tcl
} else {
  set colist ""
  lappend colist  "colmtime     mtime              mtime"
  lappend colist  "colauthor    ed:author             author"
  lappend colist  "colfdel      proc:bton_fdelete  FD"
  lappend colist  "collast      last               last"
  lappend colist  "colkeywords  ed:keywords        keywords"
  lappend colist  "colopen      proc:abton_tick     T"
  lappend colist  "coltitle     ed:title           title"
  lappend colist  "colopen      proc:at_open       O"
  lappend colist  "colmove      ed:move            move"
  lappend colist  "colname      name               name"
}

foreach i $colist {
  set key  [lindex $i 0]
  set cmd  [lindex $i 1]
  set name [lindex $i 2]

  ghtm_onoff $key -name $name
  atcols_onoff "$key ; $cmd ; $name"
}

atable at.tcl -css table1 -dataTables -sortby $sortby -sortopt "-decreasing" -noid -num


