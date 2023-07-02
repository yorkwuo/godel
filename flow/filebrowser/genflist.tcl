#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

set dirroot  [lvars . dirroot]
set pattern  [lvars . pattern]
set maxdepth [lvars . maxdepth]
if {$pattern eq "NA"} {
  lsetvar . pattern ""
}


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

#puts $filelist
#return

set count 1
regsub -all {\/} $dirlist {} dirlist
regsub -all {\n} $dirlist { } dirlist
if [regexp {ls:} $dirlist] {
  lsetvar . dirlist ""
} else {
  lsetvar . dirlist $dirlist
}

foreach f [split $filelist \n] {
    if [file isdirectory $dirroot/$f] {continue}

    regsub {^\.\/} $f {} f
  
    if [regexp {\.nfs} $f] {continue}
  
    if [regexp "$pattern" $f] {
      set num [format "%04d" $count]
      set fname $dirroot/$f
      set atvar($num,path) $f 
      set atvar($num,type) f
      if [file exist $fname] {
        set atvar($num,size) [num_symbol [file size "$fname"] K]
        set atvar($num,mtime) [clock format [file mtime $dirroot/$f] -format {%m-%d_%H:%M}]
      } else {
        set atvar($num,size) NA
        set atvar($num,mtime) NA
      }
      incr count
    }
}

godel_array_save atvar at.tcl

