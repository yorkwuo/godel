ghtm_top_bar -save -js

ghtm_varbox -name Year -key year

puts $fout "<div style='display:flex;gap:20px;margin-bottom:15px'>"
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


# dayrange
# {{{
proc dayrange {backward foreward} {
  set year [file tail [pwd]]

  set rows ""
  set today [exec date "+%Y/%m/%d"]
  set start_date [exec date "+%Y/%m/%d" -d "$today - $backward days"]
  set day_counts [expr $backward + $foreward]

  for {set i 0} {$i < $day_counts} {incr i} {
      set dd [exec date "+%Y-%m-%d_%V.%w" -d "$start_date + $i days"]
      set d2 [exec date "+%Y-%m-%d" -d "$start_date + $i days"]
      lappend rows $dd
      set diff [datediff "$year/12/31" $d2]
      if {$diff < 0} {
        break
      } else {
        lappend dirs $dd
      }
  }
  set ::ltblrows $rows
}
# }}}
# date
# {{{
proc date {} {
  upvar row row
  upvar celltxt celltxt

  set bgcolor [lvars $row bgcolor]
  if {$bgcolor eq "NA"} {
    set bgcolor ""
  }
  set date    [lvars $row date]
  set today [clock format [clock seconds] -format {%Y-%m-%d}]
  if {$date eq $today} {
    regsub {\d\d\d\d-} $date {} date
    set celltxt "<td bgcolor=w3-pale-blue>$date</td>"
  } else {
    regsub {\d\d\d\d-} $date {} date
    set celltxt "<td bgcolor=$bgcolor>$date</td>"
  }
}
# }}}

puts $fout "<div id=result></div>"

#set cols ""
#lappend cols "proc:chkmd;M"
#lappend cols "proc:date;date"
#lappend cols ww
#lappend cols "ed:jieqi;節氣"
#lappend cols "ed:key;K"
#lappend cols "ed:notes;notes"
##lappend cols "ed:tw_holiday;TW"
#lappend cols "ed:us_holiday;US"
#lappend cols "ed:png_holiday;PNG"
#local_table tbl -c $cols -dataTables -serial

# vim:fdm=marker
