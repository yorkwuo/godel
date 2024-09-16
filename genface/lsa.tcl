#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set cwd [pwd]
set title [file tail $cwd]

set fout [open $env(HOME)/o.html w]

puts $fout "<div onclick=\"location.reload()\" class=\"w3-btn w3-round-large\">
<img src=$env(GODEL_ROOT)/icons/back.png height=50px></div>"

puts $fout "<div onclick=\"genface('cd $cwd/..;$env(GODEL_ROOT)/genface/lsa.tcl','maindiv')\" class=\"w3-btn w3-round-large\">
<img src=$env(GODEL_ROOT)/icons/arrow_up.png height=50px></div>"

puts $fout "<h1>$title</h1>"

puts $fout "<div>[pwd]</div>"

ghtm_lsa

close $fout

