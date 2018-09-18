proc genus_clock_gating {} {
  upvar vars vars
  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  set infile "clock_gating.rpt"
  if [file exist $infile] {
  } else {
    puts "Error: Not exist.. $infile"
    return
  }
  puts "    genus_clock_gating..."
  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
# RC Gated Flip-flops
    if [regexp {\sRC Gated Flip-flops\s+\S+\s+(\S+)} $line whole matched] {
      set vars(clock_gated_percent) $matched
    }
  }
  close $fin
  godel_array_save vars .godel/vars.tcl
}
