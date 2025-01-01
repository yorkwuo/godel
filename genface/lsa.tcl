#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set cwd [pwd]
set title [file tail $cwd]

set fout [open $env(GTMP)/o.html w]

  puts $fout "<div style='display:flex;gap:20px'>"
    puts $fout "<div onclick=\"location.reload()\" class=\"w3-btn w3-round-large\">
    <img src=$env(GODEL_ROOT)/icons/back.png height=80px></div>"
    puts $fout "<div onclick=\"genface('cd $cwd/..;$env(GODEL_ROOT)/genface/lsa.tcl','maindiv')\" class=\"w3-btn w3-round-large\">
    <img src=$env(GODEL_ROOT)/icons/arrow_up.png height=80px></div>"
  puts $fout "</div>"
  
  puts $fout "<h1>$title</h1>"
  
  puts $fout "<div>[pwd]</div>"
  
  ghtm_lsa

close $fout

