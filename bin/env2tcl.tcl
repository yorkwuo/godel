#!/usr/bin/tclsh
# godel_array_save
# {{{
proc godel_array_save {aname ofile {newaname ""}} {
  upvar $aname arr

  if {[file dirname $ofile] != "."} {
    file mkdir [file dirname $ofile]
  }

  set fout [open $ofile w]
    set keys [lsort [array name arr]]
    foreach key $keys {
      set newvalue [string map {\\ {\\}} $arr($key)]
      regsub -all {\[} $key {\\[} key
      regsub -all { } $key {\ } key
      regsub -all {"}  $newvalue {\\"}  newvalue
      regsub -all {\$}  $newvalue {\\$}  newvalue
      regsub -all {\[} $newvalue {\\[}  newvalue
      regsub -all {\]} $newvalue {\\]}  newvalue
      if {$newaname eq ""} {
        puts $fout [format "set %-40s \"%s\"" [set aname]($key) $newvalue]
      } else {
        puts $fout [format "set %-40s \"%s\"" [set newaname]($key) $newvalue]
      }
    }
  close $fout

}
# }}}

#source $env(GODEL_ROOT)/bin/godel.tcl
godel_array_save env env.tcl
#foreach name [array names env] {
#  puts env($name)
#}
