ghtm_top_bar -save
gnotes "
# $vars(g:pagename)
"
#ghtm_ls at.tcl
if [file exist "class.tcl"] {
  source class.tcl
}

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
  lappend colist  "colnotes     ed:notes           notes"
  lappend colist  "collnpage    proc:at_lnpage     lnpage"
  lappend colist  "colopen      proc:at_open       O"
  lappend colist  "colmove      ed:move            move"
  lappend colist  "colname      name               name"
}

toolarea_begin

  gexe_button update.tcl -name update -cmd -nowin
  gexe_button move.tcl -name move -cmd -nowin
  ghtm_padding 40px
  ghtm_onoff level1  -name level1
  ghtm_padding 40px
  if [file exist "colist.tcl"]  { puts $fout "<a href=colist.tcl type=text/txt>colist.tcl</a>" }
  if [file exist "at.tcl"]  { puts $fout "<a href=at.tcl type=text/txt>at.tcl</a>" }
  if [file exist "class.tcl"] { puts $fout "<a href=class.tcl type=text/txt>class.tcl</a>" }

gnotes {Sortby}
  ghtm_set_value sortby name  -name name
  ghtm_set_value sortby mtime -name mtime
  ghtm_set_value sortby last  -name last

gnotes {Columns}
foreach i $colist {
  set key  [lindex $i 0]
  set cmd  [lindex $i 1]
  set name [lindex $i 2]

  batch_onoff $key -name $name
}
toolarea_end

foreach i $colist {
  set key  [lindex $i 0]
  set cmd  [lindex $i 1]
  set name [lindex $i 2]

  atcols_onoff "$key ; $cmd ; $name"
}

atable at.tcl -css table1 -sortby $sortby -sortopt "-decreasing" -noid -num -dataTables


