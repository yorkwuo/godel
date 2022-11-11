#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

if [file exist at.tcl] {
  source at.tcl
  
  array set kk [array get atvar *,last]
  array set kk [array get atvar *,keywords]

  unset atvar
}

exec make f

set lines [read_as_list flist]

foreach line $lines {
  set atvar($line,name) [file tail $line]
  set atvar($line,path) $line
  if [info exist kk($line,last)] {
    set atvar($line,last) $kk($line,last)
  }
  if [info exist kk($line,keywords)] {
    set atvar($line,keywords) $kk($line,keywords)
  }
}

godel_array_save atvar at.tcl

godel_draw
catch {exec xdotool search --name "Mozilla" key ctrl+r}
