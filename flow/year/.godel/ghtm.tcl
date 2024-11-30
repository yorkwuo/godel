ghtm_top_bar -save -js

if [file exist local.tcl] {
  source local.tcl
}

ghtm_varbox -name Year -key year

puts $fout "<div style='display:flex;gap:20px'>"
  ghtm_onoff Q1 -name Q1
  ghtm_onoff Q2 -name Q2
  ghtm_onoff Q3 -name Q3
  ghtm_onoff Q4 -name Q4
  linkbox -ed -name ghtm -target .godel/ghtm.tcl
  linkbox -ed -name face1 -target face1.tcl
  linkbox -ed -name wwday -target wwday.tcl
  gexe_button create_days.tcl   -name create_days -f create_days.tcl
  gexe_button create_table.tcl  -name create_sql -f  create_table.tcl
  gexe_button sql_insert.tcl    -name insert -f sql_insert.tcl
  gexe_button "sqlitestudio dbfile.db" -name dbfile -nowin
puts $fout "</div>"


puts $fout "<div id=result></div>"

# vim:fdm=marker
