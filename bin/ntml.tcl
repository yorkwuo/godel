#!/usr/bin/tclsh

set fname [lindex $argv 0]

if {$fname eq ""} {
  puts "Usage: ntml.tcl <filename>"
  return
}

set kout [open $fname "w"]

puts $kout "<!doctype html>
<html>
<head>
<title>$fname</title>
</head>

<body>


</body>

</html>
"

close $kout
