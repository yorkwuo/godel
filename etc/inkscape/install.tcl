#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

if {$env(GODEL_WSL) eq "1"} {
  set dir "/mnt/c/Program\\ Files/Inkscape/share/inkscape/symbols"
  puts "cp asic.svg $dir"
  exec cp asic.svg $dir
} else {
}

