proc ghtm_notes {content} {
  upvar fout fout
  upvar vars vars
  upvar count count

  puts $fout "<div class=\"gnotes w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"
 
  set content [string trim $content]
# Keywords
# *#
  regsub -line -all {^\*#\. (.*$)} $content {<span class=keywords style=color:red>\1</span>} content

# Title
#  *18. text to be highlight
  regsub -line -all {^\*(\d+)\. (.*$)} $content {<font style="color:blue; font-size:\1px"><b>\2</b></font>} content
  regsub -line -all {^\*\. (.*$)} $content {<font style="color:blue; font-size:14px"><b>\1</b></font>} content
# Text color
#  *c-red. text to be highlight
  regsub -line -all {^\*c-(\w+)\. (.*$)} $content {<font style="color:\1;">\2</font>} content

  puts $fout "<pre>$content</pre>"

  puts $fout "</div>"

}

