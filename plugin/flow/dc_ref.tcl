proc dc_ref {} {
  set infile ref.rpt

  upvar vars   vars
  upvar define define

  if ![godel_proc_get_ready $infile] { return }

  set flag_start 0

#  set fin  [open $infile r]

# Create array `ref' and ref(celllist)
#  while {[gets $fin line] >= 0} {
#    # Start the work after `Reference'
#    if [regexp {^Reference} $line] { set flag_start 1 }
#
#    if {$flag_start} {
#      # AND01  library_nldm     0.291600    1024   298.598389
#      set col4 [godel_get_column $line 4]
#      if [regexp {^\d} $col4] {
#        set cell                  [godel_get_column $line 0]
#        lappend ref(celllist)     $cell
#        set ref($cell,lib)        [godel_get_column $line 1]
#        set ref($cell,unit_area)  [godel_get_column $line 2]
#        set ref($cell,count)      [godel_get_column $line 3]
#        set ref($cell,total_area) [godel_get_column $line 4]
#
#        regexp {^(\S\S\S)(\S\S\S\S\S\S\S)} $cell whole libID family
#
#        if [info exist define(22ffl_cell_map,$family)] {
#          set ref($cell,mapcell) $define(22ffl_cell_map,$family)
#        } else {
#          set ref($cell,mapcell) "$family NA"
#        }
#
#      }
#    }
#  } ;# while
#  close $fin

  #set ilist [list]
  #foreach i $ref(celllist) {
  #  lappend ilist [list $i $ref($i,unit_area) $ref($i,count) $ref($i,total_area)]
  #}

  #set kout [open refm.rpt w]
  #set ilist [lsort -index 3 -real $ilist]
  #foreach i $ilist {
  #  set cell [lindex $i 0]
  #  #puts [format "%-10s %-20s %.3f %10.3f %10d" $ref($cell,mapcell) $cell $ref($cell,unit_area) $ref($cell,total_area) $ref($cell,count)]
  #  puts [format "%s,%s,%.3f,%.3f,%d" $ref($cell,mapcell) $cell $ref($cell,unit_area) $ref($cell,total_area) $ref($cell,count)]
  #  puts $kout [format "%s,%s,%.3f,%.3f,%d" $ref($cell,mapcell) $cell $ref($cell,unit_area) $ref($cell,total_area) $ref($cell,count)]
  #}
  #close $kout 


  godel_array_save vars .godel/vars.tcl
}
