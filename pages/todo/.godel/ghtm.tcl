ghtm_top_bar
set nlist [glob -type d *]
set rows {}

foreach page $nlist {
  set pp {}

# title
  set title [gvars -l $page title]
  set title "<a href=$page/.index.htm>$title</a>"

# g:keywords
  set keywords [gvars -l $page g:keywords]

# priority
  set priority [gvars -l $page priority]

# done
  set done [gvars -l $page done]

# row_ctrl
  set row_ctrl ""
  if {$done} {
    set row_ctrl "bgcolor=grey"
  } else {
    if {$priority == "1"} {
      set row_ctrl "bgcolor=yellow"
    } elseif {$priority == "2"} {
      set row_ctrl "bgcolor=pink"
    }
  }

  lappend pp $page
  lappend pp $title
  lappend pp $keywords
  lappend pp $priority
  lappend pp $row_ctrl

  if {$done} {
# don't display
  } else {
    lappend rows $pp
  }
}

#set rows [html_rows_sort $rows -c 2 -p {-int -dec}]
set rows [html_rows_sort $rows -c 3 ]

make_table $rows ""


