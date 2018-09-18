proc ghtm_line_categorizer {ifile} {
  upvar fout fout
  upvar env env

  file mkdir ".line_categorizer/$ifile"
  if [file exist .line_categorizer/$ifile/$ifile.ctrl.tcl] {
    source .line_categorizer/$ifile/$ifile.ctrl.tcl
  } else {
    set kout [open .line_categorizer/$ifile/$ifile.ctrl.tcl w]
      puts $kout "#lappend patterns \[list \"bfn|and\" bfn\]"
    close $kout
  }

  if ![info exist patterns] {
    set patterns [list]
  }


  puts $fout "<h3>ghtm_line_categorizer: <span><a href=$ifile type=text/txt style=color:white> $ifile </a></span></h3>"
  puts $fout "<a type=text/txt href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_line_categorizer.tcl]>(script)</a>"
  puts $fout "<a type=text/txt href=.line_categorizer/$ifile/$ifile.ctrl.tcl>(ctrl)</a>"

  # pattern should be exclusive to each other
  if [file exist $ifile] {
  } else {
    return
  }
  set fin [open $ifile r]
  while {[gets $fin line] >= 0} {
    set match 0
    foreach pattern $patterns {
      set pat [lindex $pattern 0]
      set key [lindex $pattern 1]
      if [regexp "$pat" $line] {
        lappend vars($key) $line
        set match 1
        # If match then break. No more regexp.
        break
      }
    }
    if {!$match} {
      lappend vars(others) $line
    }
  }
  puts $fout "<pre>"



  foreach pattern $patterns {
    set key [lindex $pattern 1]
    #puts $fout "$key"
    lappend rowlist $key
    set kout [open .line_categorizer/$ifile/$key.txt w]
      foreach i $vars($key) {
        puts $kout "$i"
      }
    close $kout
    set vars($key,file) "<a href=.line_categorizer/$ifile/$key.txt type=text/txt>$key</a>"
  }

  lappend rowlist others
  set kout [open .line_categorizer/$ifile/others.txt w]
    foreach i $vars(others) {
      puts $kout "$i"
    }
  close $kout
  set vars(others,file) "<a href=.line_categorizer/$ifile/others.txt type=text/txt>others</a>"

  puts $fout "</pre>"


set columnlist [list]
lappend columnlist [list count count]
lappend columnlist [list file file]
ghtm_table_nodir history 0


}
