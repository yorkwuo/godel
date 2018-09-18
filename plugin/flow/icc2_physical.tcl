proc icc2_physical {} {
  upvar vars vars
  if [file exist .vars.tcl] { source .vars.tcl }
  set infile "physical.rpt"
  if [file exist $infile] {
  } else {
    puts "Error: Not exist.. $infile"
    return
  }

# lines
  set lines [list]
  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    lappend lines $line 
  }
  close $fin

# Locate Reference Section
  set lno1 [lgrep_index $lines {^Name\s+Type}]
  set lno2 [lgrep_index $lines {^--------------} [expr $lno1 + 1]]
  set lno3 [lgrep_index $lines {^$} [expr $lno2 + 1]]
# Extract Reference Section
  set ref_section [lrange $lines $lno1 $lno3]

# Join two lines
  for {set i 0} {$i < [llength $ref_section]} {incr i} {
    set line [lindex $ref_section $i]
    if [regexp {lib_cell} $line] {
      set prevline [lindex $ref_section [expr $i-1]]
      set nline [append prevline $line]
      #puts $nline
      lassign $nline cell - count
      #puts [llength $nline]
      #lassign [split $nline \s+] cell - count
      #puts "$cell $count"
      
    }
  }
  #puts $lno1
  #puts [lindex $lines 0]


  godel_array_save vars .vars.tcl
}

