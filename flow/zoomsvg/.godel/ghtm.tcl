ghtm_top_bar -save -js -hide
gnotes " # $vars(g:pagename)"

set lines [read_as_list 1.svg]

foreach line $lines {
  if [regexp {\?xml} $line] continue
  if [regexp {<svg} $line] continue
  if [regexp {Created with Inkscape} $line] continue
  regsub {id=\"svg.*$} $line {id="svg"} line
  lappend newlines $line
}

puts $fout {<svg id="svg" width="1000" height="1000" viewBox="0 0 1000 1000"}
foreach newline $newlines {
  puts $fout $newline
}

