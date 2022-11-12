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

foreach fname $lines {
  set mtime [file mtime $fname]
  set timestamp [clock format $mtime -format {%Y-%m-%d_%H:%M}]
  set atvar($fname,mtime) $timestamp

  set atvar($fname,name) [file tail $fname]
  set atvar($fname,path) $fname
  if [info exist kk($fname,last)] {
    set atvar($fname,last) $kk($fname,last)
  }
  if [info exist kk($fname,keywords)] {
    set atvar($fname,keywords) $kk($fname,keywords)
  }
}

godel_array_save atvar at.tcl

godel_draw
catch {exec xdotool search --name "Mozilla" key ctrl+r}
