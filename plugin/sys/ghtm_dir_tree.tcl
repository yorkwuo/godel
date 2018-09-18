proc ghtm_dir_tree {level ofname {options ""}} {
  upvar fout fout
  upvar target_dir target_dir
  set txt [exec tcsh -fc "tree $options -F -L $level $target_dir"]
  set kout [open $ofname w]
    puts $kout $txt
  close $kout
  puts $fout "<a href=$ofname type=text/txt>$ofname</a><br>"
}

