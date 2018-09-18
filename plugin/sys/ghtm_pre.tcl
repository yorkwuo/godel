proc ghtm_pre {txt} {
  upvar fout fout
  set txt [string trim $txt]
  puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"

# Example:
#  *18. text to be highlight
  regsub -line -all {^\*(\d+)\. (.*$)} $txt {<font style="color:blue; font-size:\1px"><b>\2</b></font>} txt

  puts $fout "<pre>$txt</pre>"
  puts $fout "</div>"

  #puts $txt
}

