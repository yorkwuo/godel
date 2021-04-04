#!/usr/bin/tclsh
source ~/godel.tcl

set bpath [lindex $argv 0]
set bpath [file normalize $bpath]

set ilist [glob -type d $bpath/*]

set num 1
 
set kout [open $bpath/blist.f w]
puts $kout "set blist \"\""

foreach item $ilist {
  set w [file tail $item]
  set class [lvars $item g:class]
  if {$class eq "NA"} {
    puts $item
    lsetvar $item g:class book
  } else {
    set title [lvars $item title]
    set fname [lvars $item fname]

      regsub -all {\[} $title {\\[} title
      regsub -all {\]} $title {\\]} title
      regsub -all {\[} $item {\\[} item
      regsub -all {\]} $item {\\]} item
      regsub -all {\[} $fname {\\[} fname
      regsub -all {\]} $fname {\\]} fname

      puts $kout "lappend blist $num"
      puts $kout "set bvars($num,path) \"$item\""
      puts $kout "set bvars($num,title) \"$title\""
      puts $kout "set bvars($num,concat) \"$title $bpath/$fname\""
      incr num
  }
}
close $kout

puts "Done $bpath/blist.f"

