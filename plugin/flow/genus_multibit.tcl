proc genus_multibit {} {
  upvar vars vars
  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  set infile "multibit.rpt"
  if [file exist $infile] {
  } else {
    puts "Error: Not exist.. $infile"
    return
  }
  puts "    genus_multibit..."
  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
    if [regexp {All Sequentials\s+\d+\s+\d+\s+(\S+)} $line whole m1] {
      set vars(mbff) $m1
    }
  }
  close $fin
  godel_array_save vars .godel/vars.tcl
}
