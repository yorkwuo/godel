proc ghtm_plist {vname} {
  upvar vars vars
  upvar fout fout

  puts $fout "<h5>$vname <a href=kk>(script)</a></h5>"
  puts $fout "<pre style=font-size:10px>"
  if [info exist vars($vname)] {
    foreach i $vars($vname) {
      puts $fout $i
    }
  } else {
    puts $fout "NA..."
  }
  puts $fout "</pre>"

}
