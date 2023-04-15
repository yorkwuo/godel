#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set dirroot  [lvars . dirroot]
set pattern  [lvars . pattern]
set maxdepth [lvars . maxdepth]

set cwd [pwd]
cd $dirroot
catch "exec find ./ -maxdepth $maxdepth -type f" filelist
catch "exec find ./ -maxdepth $maxdepth -type d" dirlist
cd $cwd

set count 1
foreach d $dirlist {
  if {$d eq "./"} {continue}
  if {$d eq ".godel"} {continue}
  regsub {^\.\/} $d {} d
  set num [format "%04d" $count]
  puts $d
  set atvar($num,path) $d
  set atvar($num,type) d
  incr count
}

foreach f $filelist {
  regsub {^\.\/} $f {} f

  if [regexp "$pattern" $f] {
    set num [format "%04d" $count]
    puts $dirroot/$f
    set atvar($num,path) $f 
    set atvar($num,type) f
    incr count
  }
}

godel_array_save atvar at.tcl

