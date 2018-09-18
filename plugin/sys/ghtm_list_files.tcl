proc ghtm_list_files {pattern {description ""}} {
  upvar env env
  upvar fout fout

  #puts $fout "<div><h5>Filelist$description<a href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_list_files.tcl] type=text/txt>(script)</a></h5></div>"
  set flist [glob -nocomplain $pattern]
  foreach full $flist {
    set fname $full

    if {[regexp -nocase {\.jpg|\.png|\.gif} $fname]}  {
      #puts $fout "<div class=\"w3-card\" style=\"width:10%\">"
      #puts $fout "  <a href=$fname><img src=\"$fname\" style=\"width:100%\"></a>"
      #puts $fout "    <p>$fname</p>"
      #puts $fout "</div>"
    } elseif [regexp -nocase {\.png} $fname] {
      #puts $fout "<a href=\"$full\" type=text/png><img src=$full width=30% height=30%></a>"

    } elseif [regexp -nocase {\.docx} $fname] {
      puts $fout "<a href=\"$full\" type=text/docx>$full</a><br>"

    } elseif [regexp -nocase {\.mpg} $fname] {
      puts $fout "<a href=\"$full\">$full</a><br>"

    } elseif [regexp -nocase {\.pptx} $fname] {
      puts $fout "<a href=\"$full\" type=text/pptx>$full</a><br>"

    } elseif [regexp -nocase {\.ppt} $fname] {
      puts $fout "<a href=\"$full\" type=text/ppt>$full</a><br>"

    } elseif [regexp -nocase {\.xlsx} $fname] {
      puts $fout "<a href=\"$full\" type=text/xlsx>$full</a><br>"

    } elseif [regexp -nocase {\.pdf} $fname] {
      puts $fout "<a href=\"$full\" type=text/pdf>$full</a><br>"
    } elseif [regexp -nocase {\.mp4} $fname] {
      puts $fout "<a href=\"$full\" type=text/mp4>$full</a><br>"
    } elseif [regexp -nocase {\.mp3} $fname] {
      puts $fout "<a href=\"$full\" type=text/mp3>$full</a><br>"
    } elseif [regexp -nocase {\.rmvb} $fname] {
      puts $fout "<a href=\"$full\" type=text/rmvb>$full</a><br>"
    } elseif [regexp -nocase {\.htm} $fname] {
      puts $fout "<a href=\"$full\" type=text/htm>$full</a><br>"
    } elseif [regexp -nocase {\.mht} $fname] {
      puts $fout "<a href=\"$full\" type=text/mht>$full</a><br>"
    } elseif [regexp -nocase {\.ppdf} $fname] {
      puts $fout "<a href=\"$full\" type=text/ppdf>$full</a><br>"
    } elseif [file isdirectory $fname] {
    } else {
      puts $fout "<a href=$full type=text/txt>$full</a><br>"
    }
  }
}
