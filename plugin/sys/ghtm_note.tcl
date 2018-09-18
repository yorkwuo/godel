proc ghtm_note {num title {content ""}} {
  upvar fout fout
  upvar vars vars
  upvar count count

  upvar stack stack
  upvar tvars tvars
  upvar prefix prefix

  if ![info exist stack] {
    lpush stack 0 ;#chap
    lpush stack 0 ;#num
  }

  set last_num      [lpop stack]
  set last_chapter  [lpop stack]

  if {$last_num == $num} {
    # counter
    incr tvars($num,counter)

# Increase
  } elseif {$num > $last_num} {
    # counter
    set tvars($num,counter) 1
    # prefix
    if {$last_num == "0"} {
    } else {
      lpush prefix $last_chapter
    }

# decrease
  } elseif {$num < $last_num} {
    # counter
    incr tvars($num,counter)
    set size [expr $last_num - $num]
    for {set i 1} {$i <= $size} {incr i} {
      lpop prefix
    }
  }

  set chap $tvars($num,counter)
  if [info exist prefix] {
    set k1 [join $prefix .]
    if {$k1 == ""} {
      set fullindex $chap
    } else {
      set fullindex $k1.$chap
    }
  } else {
    set fullindex $chap
  }
  #puts "curr: $num: $chap: $fullindex"

  #lpush stack $level
  lpush stack $chap
  lpush stack $num

  regsub -all {\s} $title {_} id
  #puts $fout "<h$num id=$id><span class=\"w3-tag w3-deep-purple\">$fullindex. $title</span></h$num>"
  puts $fout "<h$num id=$id>$fullindex. $title</h$num>"
  puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"
  
  if {$content != ""} {
    set content [string trim $content]
# Example:
#  *18. text to be highlight
    regsub -line -all {^\*(\d+)\. (.*$)} $content {<font style="color:blue; font-size:\1px"><b>\2</b></font>} content
#  *c-red. text to be highlight
    regsub -line -all {^\*c-(\w+)\. (.*$)} $content {<font style="color:\1;">\2</font>} content

    puts $fout "<pre>$content</pre>"
  }

  puts $fout "</div>"

  lappend vars(toc) [list h$num "$fullindex. $title" $id]
}

