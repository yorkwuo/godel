#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

if {$env(GODEL_WSL) eq "1"} {
  set ifile "/mnt/c/Program\ Files/Inkscape/share/inkscape/symbols/asic.svg"
  if [file exist $ifile] {
    puts $ifile
  }
} else {
}

