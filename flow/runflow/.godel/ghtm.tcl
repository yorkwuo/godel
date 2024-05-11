ghtm_top_bar -save
pathbar 2
# find_child
# {{{
proc find_child {myname pchicount mynum indent ulindent} {
  upvar fout fout
  set childs [lvars $myname next]
  set chicount [llength $childs]
  set counter $chicount

    if {$childs eq "NA" || $childs eq ""} {
      return
    } else {
      foreach child $childs {
         set status [lvars $child status]
         #set disable [lvars [file dirname $child] disable]
         set disable [lvars $child disable]
         if {$disable eq "1"} {continue}
         if {$status eq "running"} {
           set bgcolor lightblue
         } elseif {$status eq "done"} {
           set bgcolor lightgreen
         } else {
           set bgcolor ""
         }
          if {$chicount >= 2} {
            if {$counter eq $chicount} {
              puts $fout "${ulindent}<ul>"
              puts $fout "${indent}<li><code style=background-color:$bgcolor><a style=text-decoration:none href=$child/.index.htm>[file tail $child]</a></code>"
              find_child $child $chicount $counter "$indent    " "$ulindent    "
              incr counter -1
            } else {
              puts $fout "${indent}<li><code style=background-color:$bgcolor><a  style=text-decoration:none href=$child/.index.htm>[file tail $child]</a></code>"
              find_child $child $chicount $counter "$indent    " "$ulindent    "
            }
          } else {
            puts $fout "${ulindent}<ul>"
            puts $fout "${indent}<li><code style=background-color:$bgcolor><a style=text-decoration:none href=$child/.index.htm>[file tail $child]</a></code>"
            find_child $child $chicount $counter "$indent    " "$ulindent    "
          }
      }
      puts $fout "${ulindent}</li>"
      puts $fout "${ulindent}</ul>"
    }
}
# }}}

ghtm_onoff tableon -name table
set tableon [lvars . tableon]

csplit_init -width 30%
csplit_begin

#------------------------
# Table
#------------------------
if {$tableon eq "1"} {
  csplit_sub_begin


set cols ""
lappend cols "ed:status;status"
lappend cols "g:iname"
lappend cols "ed:next;next"
lappend cols "ed:disable;disable"

local_table tbl -c $cols -serial

  csplit_sub_end
}
#------------------------
# Flow Chart
#------------------------
  csplit_sub_begin


puts $fout "<link rel=\"stylesheet\" href=\"./style.css\">"

set root 0start

puts $fout {
<figure>
    <ul class=tree>
}

set status [lvars $root status]
if {$status eq "running"} {
  set bgcolor lightblue
} elseif {$status eq "done"} {
  set bgcolor lightgreen
} else {
  set bgcolor ""
}

puts $fout "        <li><code style=background-color:$bgcolor><a href=$root/.index.htm>$root</a></code>"

find_child $root 1 1 "            " "        "

puts $fout "</ul>"

puts $fout {
</figure>
}
  csplit_sub_end

# vim:fdm=marker
