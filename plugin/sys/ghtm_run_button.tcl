proc ghtm_run_button {cmd} {
  upvar fout fout
  puts $fout "<div class=\"w3-bar-item\"><button onclick=paste2clipb(\"$cmd\")>run</button></div>"
}

