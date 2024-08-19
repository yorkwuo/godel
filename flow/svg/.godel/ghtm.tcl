ghtm_top_bar -save
pathbar 2

if [file exist "1.svg"] {
} else {
  set kout [open "1.svg" w]
  puts $kout {<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="1000" height="1000">}
  puts $kout {</svg>}
  close $kout
}

list_svg 1.svg
