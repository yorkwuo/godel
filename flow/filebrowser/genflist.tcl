#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set dirroot  [lvars . dirroot]
set pattern  [lvars . pattern]
set maxdepth [lvars . maxdepth]


if [info exist atvar] {
  unset atvar
}

set pname [join [lrepeat $maxdepth *] /]

set cwd [pwd]
if ![file exist $dirroot] {return}
cd $dirroot
  catch "exec tcsh -fc \"ls -1 -d $pname\"" filelist
  catch "exec tcsh -fc \"ls -1 -d */\"" dirlist
cd $cwd

set count 1
regsub -all {\/} $dirlist {} dirlist
regsub -all {\n} $dirlist { } dirlist
if [regexp {ls:} $dirlist] {
  lsetvar . dirlist ""
} else {
  lsetvar . dirlist $dirlist
}

foreach f $filelist {
    if [file isdirectory $dirroot/$f] {continue}

    regsub {^\.\/} $f {} f
  
    if [regexp {\.nfs} $f] {continue}
    if [regexp {\.f} $f] {continue}
  
    if [regexp "$pattern" $f] {
      set num [format "%04d" $count]
      set fname $dirroot/$f
      set atvar($num,path) $f 
      set atvar($num,type) f
      set atvar($num,size) [num_symbol [file size "$fname"] K]
      #set atvar($num,mtime) [clock format [file mtime $dirroot/$f] -format {%m-%d_%H:%M}]
      set atvar($num,mtime) [clock format [file mtime $dirroot/$f] -format {%W.%w_%H:%M}]
      incr count
    }
}

godel_array_save atvar at.tcl

