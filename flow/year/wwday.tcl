#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
# chkmd
proc chkmd {} {
  upvar row row
  upvar fout fout

  set mdfiles [glob -nocomplain $row*/*.md]

  if {$mdfiles eq ""} {
    puts $fout "<td></td>"
  } else {
    set cwd [pwd]
    puts $fout "<td bgcolor=yellow onclick=\"cmdline('$cwd','gvim','$mdfiles')\"></td>"

  }
}
# date
# {{{
proc date {} {
  upvar row row
  upvar fout fout
  upvar svars svars

  set bgcolor [gvar $row bgcolor]
  if {$bgcolor eq "NA"} {
    set bgcolor ""
  }
  set date    [gvar $row date]
  set today [clock format [clock seconds] -format {%Y-%m-%d}]
  if {$date eq $today} {
    regsub {\d\d\d\d-} $date {} date
    puts $fout "<td bgcolor=w3-pale-blue>$date</td>"
  } else {
    regsub {\d\d\d\d-} $date {} date
    puts $fout "<td bgcolor=$bgcolor>$date</td>"
  }
}
# }}}

sql2svars -uname code

#parray svars

file delete $env(HOME)/o.html

set fout [open "$env(HOME)/o.html" w]

set trows ""
foreach i $rows {
  #if [regexp {\-} $i] {
  #  #puts $svars($i,notes)
  #  lappend trows $i
  #}

  #if [regexp {\-01\-|\-02\-|\-03\-} $i] {
  #  lappend trows $i
  #}

  #if [regexp {\-10\-|\-11\-|\-12\-} $i] {
  #  lappend trows $i
  #}
  lappend trows $i

}

set rows $trows

#foreach row $rows {
#  regexp {\.(\d)} $row -> wday
#  puts $wday
#  puts $fout "<div>"
#  puts $fout "$row"
#  puts $fout "</div>"
#}

puts $fout {
<style>
.dbox {
  min-width:150px;
  max-width:150px;
  border-right: solid 1px;
  border-bottom: solid 1px;
  border-color:#c8b7a6;
}
.wwbox {
  min-width:40px;
  max-width:150px;
  border-right: solid 1px;
  border-left: solid 1px;
  border-bottom: solid 1px;
  border-color:#c8b7a6;
  text-align:center;
  align-content:center;
  background-color:#8785a2;
  color:white;
}
</style>
}

#set today [exec date "+%Y/%m/%d"]
set today [clock format [clock seconds] -format {%m-%d}]
puts $today

while {[llength $rows] > 0} {
  puts $fout "<div style='display:flex;flex-wrap:wrap;gap:0px;margin-bottom:0px;'>"

  regexp {\d\d\d\d\-\d\d\-\d\d\_(\d\d)} [lindex $rows 0] -> workweek
  puts $fout "<div class='wwbox'>$workweek</div>"
  foreach i [list 1 2 3 4 5 6 0] {
    regexp {\.(\d)} [lindex $rows 0] -> wday

    if {$i eq $wday} {
      set row [lshift rows]
      set notes $svars($row,notes)
      if {$notes eq "NA"} {
        set notes ""
      }
      regexp {\d\d\d\d\-(\d\d\-\d\d)} $svars($row,date) -> day
      set ww $svars($row,ww)

# day color
      set bgcolor white

      if {$notes ne ""} {
        set bgcolor #f6f6f6
      }

      if {$i eq "0" || $i eq "6"} {
        set bgcolor #ffe2e2
      } 
      if {$day eq $today} {
        set bgcolor lightblue
      }

      #puts $fout "<div class='dbox' style='display:flex;flex-wrap:column'>"
      puts $fout "<div class='dbox' style='display:flex;flex-direction:column;background-color:$bgcolor'>"
# ww(day)
        puts $fout "<a href=$row/.index.htm style='text-decoration:none'>"
        puts $fout "<div><pre>$day</pre></div>"
        puts $fout "</a>"
# notes
        puts $fout "<div style='min-height:24px;
        white-space:pre;font-size:14px;font-family:monospace'
        contenteditable=true
        key='notes' idname='code' idvalue='$row' onblur=\"jsetvar(this,'$row')\"
        >$notes</div>"
      puts $fout "</div>"


    } else {
      puts $fout "<div class='dbox'></div>"
    }
  }
  puts $fout "</div>"
}


# vim:fdm=marker
