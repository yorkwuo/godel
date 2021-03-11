#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set dicdir $env(GODEL_DIC)

set words [glob -type d -type l $dicdir/*]
 
set kout [open $dicdir/words w]
puts $kout "set allwords \"\""
foreach word $words {
  set w [file tail $word]
  set chinese [lvars $dicdir/$w chinese]

  puts $kout "lappend allwords $w"
  puts $kout "set vars($w,path) $word"
  puts $kout "set vars($w,chinese) \"$chinese\""
  puts $kout "set vars($w,concat) \"$w $chinese\""
}
close $kout

puts "Updated... $env(GODEL_DIC)/words"

