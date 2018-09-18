proc ghtm_dl {txt} {
# Example txt inputs:
# foo
#   bar
#   bars
  upvar fout fout
  set txt [string trim $txt]
  puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"
# dt
  regsub -line -all {(^\w.*$)} $txt {<dt>\1</dt>} txt
# dd
  regsub -line -all {^\s+(\w.*$)} $txt {<dd>\1</dd>} txt
  puts $fout "<dl>$txt</dl>"
  puts $fout "</div>"
  #puts $txt
}

