ghtm_top_bar -save -js -hide
pathbar 4
mod_links


set lines [read_as_list 1.svg]

foreach line $lines {
  if [regexp {\?xml} $line] continue
  if [regexp {<svg} $line] continue
  if [regexp {Created with Inkscape} $line] continue
  regsub {id=\"svg.*$} $line {id="svg"} line
  lappend newlines $line
}

puts $fout {<svg id="svg" width="2000" height="2000" viewBox="0 0 2000 2000"}
foreach newline $newlines {
  puts $fout $newline
}

