proc ghtm_money {} {
# Support TWD,RMB,GBP convert to USD
# Inputs:
# 1.2-M-TWD {house price}
  upvar env env
  upvar fout fout

  proc convert_to {from} {
    set rate(GBP) 1.431
    set rate(TWD) 0.034
    set rate(RMB) 0.159
    set rate(USD) 1
    set N(B)   1000000000
    set N(M)   1000000
    set N(K)   1000
    set N(_)   1
    #set to [expr $from * 10]
    regsub -all {,} $from {} from
    regexp {([0-9.]*)-([_KMB])-(\w\w\w)} $from whole value note type
    #puts $value
    #puts $note
    #puts $type
    set to [expr ($value * $N($note) * $rate($type))/$N(M)]
    return $to
  }

# Create money.txt if not exist
  set lines [list]
  set fname ".godel/money.txt"
  if [file exist $fname] {
    set kout [open $fname r]
      while {[gets $kout line] >= 0} {
        lappend lines $line
      }
    close $kout
  } else {
    set kout [open $fname w]
    close $kout
  }

  set kout [open $fname w]
      foreach line $lines {
        if {[llength $line] == "2"} {
          set from    [lindex $line 0]
          set to [convert_to $from]
          #puts $to
          set comment [lindex $line 1]
          puts [format "%20s%20.2f-M-USD {%s}" $from $to $comment]
          puts $kout [format "%20s%20.2f-M-USD {%s}" $from $to $comment]
        } elseif {[llength $line] == "3"} {
          set from    [lindex $line 0]
          set to [convert_to $from]
          set to [format_3digit $to]
          #puts $to
          set comment [lindex $line 2]
          puts [format "%20s%20s-M-USD {%s}" $from $to $comment]
          puts $kout [format "%20s%20s-M-USD {%s}" $from $to $comment]
        } else {
          puts $kout $line
        }
      }
  close $kout

# href link to money.txt
  puts $fout "<span class=\"w3-tag\"><a href=[tbox_cygpath $env(GODEL_ROOT)/plugin/sys/ghtm_money.tcl] type=text/txt>(script)</a>\
  <a href=.godel/money.txt type=text/txt>edit</a></span>"



# print to page
  puts $fout "<div class=\"w3-panel w3-pale-blue w3-leftbar w3-border-blue\">"

  set fin [open .godel/money.txt]
    puts $fout "<pre>"
    while {[gets $fin line] >= 0} {
      puts $fout $line
    }
    puts $fout "</pre>"
  close $fin

  puts $fout "</div>"

}
