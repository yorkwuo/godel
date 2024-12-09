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
  set date   [gvar $row date]
  set today  [clock format [clock seconds] -format {%Y-%m-%d}]
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

set Q1 [lvars . Q1]
set Q2 [lvars . Q2]
set Q3 [lvars . Q3]
set Q4 [lvars . Q4]
#parray svars

file delete $env(GTMP)/o.html

set fout [open "$env(GTMP)/o.html" w]

#ghtm_sql_switch -name more1 -key more1

set trows ""
foreach i $rows {
  if {$Q1 eq "1"} {
    if [regexp {\-01\-|\-02\-|\-03\-} $i] {
      lappend trows $i
    }
  }

  if {$Q2 eq "1"} {
    if [regexp {\-04\-|\-05\-|\-06\-} $i] {
      lappend trows $i
    }
  }

  if {$Q3 eq "1"} {
    if [regexp {\-07\-|\-08\-|\-09\-} $i] {
      lappend trows $i
    }
  }

  if {$Q4 eq "1"} {
    if [regexp {\-10\-|\-11\-|\-12\-} $i] {
      lappend trows $i
    }
  }

  #lappend trows $i

}

set rows $trows

puts $fout {
<style>
.dbox {
  min-width:150px;
  max-width:150px;
  border-right: solid 1px;
  border-bottom: solid 1px;
  border-color:#c8b7a6;
}
.dbox_1ww {
  min-width:150px;
  max-width:150px;
  border-top: solid 1px;
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

set today  [clock format [clock seconds] -format {%m-%d}]
set cur_ww [clock format [clock seconds] -format {%V}]

set wcount 1
while {[llength $rows] > 0} {
  if {$wcount eq "1"} {
    set boxclass dbox_1ww
  } else {
    set boxclass dbox
  }
  puts $fout "<div style='display:flex;flex-wrap:wrap;gap:0px;margin-bottom:0px;'>"

# workweek
  regexp {\d\d\d\d\-\d\d\-\d\d\_(\d\d)} [lindex $rows 0] -> workweek
  if {$workweek eq $cur_ww} {
    puts $fout "<div class='wwbox' style='background-color:darkblue'>$workweek</div>"
  } else {
    puts $fout "<div class='wwbox'>$workweek</div>"
  }

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

      puts $fout "<div class='$boxclass' style='display:flex;flex-direction:column;background-color:$bgcolor'>"
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
      puts $fout "<div class='$boxclass'></div>"
    }
  }
  puts $fout "</div>"
  
  incr wcount
}


# vim:fdm=marker
