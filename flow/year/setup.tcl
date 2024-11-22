#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
set ifiles [lsort [glob -type d *]]

foreach ifile $ifiles {
  regexp {(\d\d\d\d-\d\d-\d\d)} $ifile whole date
  regexp {_(\d\d\.\d)} $ifile whole ww
  #puts "$date $ww"
  lsetvar $ifile date $date
  lsetvar $ifile ww   $ww
        if [regexp {\.6$} $ifile] {
          lsetvar $ifile bgcolor lightpink
  } elseif [regexp {\.0$} $ifile] {
          lsetvar $ifile bgcolor lightpink
  }
}
