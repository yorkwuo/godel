#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
package require gmarkdown
    source .godel/vars.tcl
  set ::toc_list [list]

if {$argv == ""} {
  puts "Usage:"
  puts "% gen.tcl cmd.tcl -o foo.html"
  return
}

# -o output file
# {{{
set opt(-o) 0
set idx [lsearch $argv {-o}]
if {$idx != "-1"} {
  set ofile [lindex $argv [expr $idx + 1]]
  set argv [lreplace $argv $idx [expr $idx + 1]]
  set opt(-o) 1
} else {
  set ofile "a.html"
}
# }}}
# -e eval
# {{{
set opt(-e) 0
set idx [lsearch $argv {-e}]
if {$idx != "-1"} {
  set expression [lindex $argv [expr $idx + 1]]
  set argv [lreplace $argv $idx [expr $idx + 1]]
  set opt(-e) 1
}
# }}}

eval $expression

set cmdfile [lindex $argv 0]

ghtm_begin $ofile

source $cmdfile

ghtm_end

# vim:fdm=marker
