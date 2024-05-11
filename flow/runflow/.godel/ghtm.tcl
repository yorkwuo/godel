ghtm_top_bar -save
pathbar 2
# find_child
# {{{
proc find_child {myname pchicount mynum indent ulindent} {
  upvar fout fout
  set childs [lvars $myname next]
  set chicount [llength $childs]
  set counter $chicount

    if {$childs eq "NA"} {
      return
    } else {
      foreach child $childs {
         set status [lvars $child status]
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
              puts $fout "${indent}<li><code style=background-color:$bgcolor><a href=$child/.index.htm>$child</a></code>"
              find_child $child $chicount $counter "$indent    " "$ulindent    "
              incr counter -1
            } else {
              puts $fout "${indent}<li><code style=background-color:$bgcolor><a href=$child/.index.htm>$child</a></code>"
              find_child $child $chicount $counter "$indent    " "$ulindent    "
            }
          } else {
            puts $fout "${ulindent}<ul>"
            puts $fout "${indent}<li><code style=background-color:$bgcolor><a href=$child/.index.htm>$child</a></code>"
            find_child $child $chicount $counter "$indent    " "$ulindent    "
          }
      }
      puts $fout "${ulindent}</li>"
      puts $fout "${ulindent}</ul>"
    }
}
# }}}

set cols ""
lappend cols "g:iname"
lappend cols "ed:status;status"

local_table tbl -c $cols -serial

puts $fout "<link rel=\"stylesheet\" href=\"./style.css\">"

set root rtl

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

# vim:fdm=marker
