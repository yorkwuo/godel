ghtm_top_bar -js
pathbar 3

puts $fout "<div style='display:flex; gap: 10px;font-size:28px'>"
  puts $fout "<div class='w3-btn' onclick=readmode()>Read</div>"
  puts $fout "<div class='w3-btn' onclick=hidemode()>Hide</div>"
  puts $fout "<div class='w3-btn' style='cursor:pointer' onclick=scores()>Scores</div>"
  puts $fout "<div id='results' ></div>"
puts $fout "</div>"

if ![file exist "1.svg"] {
  set kout [open "1.svg" w]
    puts $kout {<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="1000" height="1000">}
    puts $kout {</svg>}
  close $kout
}

list_svg 1.svg
