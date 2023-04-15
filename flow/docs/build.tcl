#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set dirs [glob -nocomplain -type d *]

foreach dir $dirs {
  cd $dir
  godel_draw
  cd ..
}
godel_draw

