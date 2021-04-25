#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

# -t (type)
# {{{
set opt(-t) 0
set idx [lsearch $argv {-t}]
if {$idx != "-1"} {
  set type   [lindex $argv [expr $idx + 1]]
  set argv    [lreplace $argv $idx [expr $idx + 1]]
  set opt(-t) 1
}
# }}}

set bpath [lindex $argv 0]
set bpath [file normalize $bpath]

set ilist [glob -type d $bpath/*]

set num 1
 
set kout [open $bpath/dbs.f w]
puts $kout "set blist \"\""
puts $kout "array unset bvars *"

foreach item $ilist {
  set w [file tail $item]
  #set class [lvars $item g:class]
    if {$type eq "book"} {
      set title [lvars $item title]
      set fname [lvars $item fname]

      regsub -all {\[} $title {\\[} title
      regsub -all {\]} $title {\\]} title
      regsub -all {\[} $item {\\[} item
      regsub -all {\]} $item {\\]} item
      regsub -all {\[} $fname {\\[} fname
      regsub -all {\]} $fname {\\]} fname

      puts $kout "lappend blist $num"
      puts $kout "set bvars($num,path) \"$item\""
      puts $kout "set bvars($num,title) \"$title\""
      puts $kout "set bvars($num,concat) \"$title $bpath/$fname\""
      incr num
    } elseif {$type eq "tsl"} {
      set eng [lvars $item eng]
      set chi [lvars $item chi]
      set key [lvars $item g:keywords]
      puts $kout "lappend blist $num"
      puts $kout "set bvars($num,pointer) \"$item\""
      puts $kout "set bvars($num,eng) \"$eng\""
      puts $kout "set bvars($num,chi) \"$chi\""
      puts $kout "set bvars($num,key) \"$key\""
      incr num
    }
}
close $kout

puts "Done $bpath/dbs.f"

# vim:fdm=marker
