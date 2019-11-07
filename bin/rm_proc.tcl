#!/usr/bin/tclsh

set fname [lindex $argv 0]

set fin [open $fname r]

set count 0

while {[gets $fin line ] >= 0} {

# If match `proc', start to look for a balanced closed brace.
  if [regexp "^\s*proc " $line] {
    set open_braces  [regexp -all {\{} $line]
    set close_braces [regexp -all {\}} $line]
    set diff [expr $open_braces - $close_braces]
# If count > 0, braces is not balanced.
    set count [expr $count + $diff]

    #puts " $count $line"

# Fetch next line to look for balanced closed brace.
    while {[gets $fin line] >= 0} {
      set open_braces  [regexp -all {\{} $line]
      set close_braces [regexp -all {\}} $line]
      set diff [expr $open_braces - $close_braces]
      set count [expr $count + $diff]

    #  puts " $count $line"

# If count = 0, braces is balanced.
      if {$count == "0"} {
        break
        #return
      }
    }
  } else {
    puts "$line"
  }
}
close $fin


