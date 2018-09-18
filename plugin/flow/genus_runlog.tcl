proc genus_runlog {} {
  upvar vars vars
  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  set infile "run.log"
  if [file exist $infile] {
  } else {
    puts "Error: Not exist.. $infile"
    return
  }
  puts "    genus_runlog..."
  set cannot_open          [list]
  set sourcing             [list]
  set errors 0

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
# ver,dc: Version.*for
    if [regexp {Version\s(\S+)\sfor} $line whole m1] {
      set vars(ver,dc) $m1
# cannot_open:
    } elseif [regexp {Cannot open file '(\S+)'} $line whole m1] {
      lappend cannot_open $m1
# tech_file: 
    } elseif [regexp {Technology file (\S+) has been} $line whole m1] {
      set vars(tech_file) $m1
# errors
    } elseif [regexp {Error   :} $line] {
      incr errors
# lef_library
    } elseif [regexp {'lef_library' = (.*)$} $line whole m1] {
      set vars(lef_library) $m1
# timing_library
    } elseif [regexp {'timing': 'library' = (.*)$} $line whole m1] {
      set vars(timing_library) $m1
# qrc_tech_file
    } elseif [regexp {'qrc_tech_file' = (.*)$} $line whole m1] {
      set vars(qrc_tech_file) $m1
# sourcing
    } elseif [regexp {^Sourcing '.*'} $line whole m1] {
      lappend sourcing $whole
    }
  }
  close $fin

# liblist
  set vars(error,cannot_open) $cannot_open
  set vars(errors)       $errors
  set fout [open "sourcing.rpt" w]

  if [info exist vars(timing_library)] {
    if [regexp {lib222\w*_(\dt)_(\d\d\dpp)_base_(\S\.\S\.\S)} $vars(timing_library) whole m1 m2 m3] {
      set vars(library_track) $m1
      set vars(library_pp)    $m2
      set vars(library_ver)   $m3
    }
  }

# sourcing.rpt
  foreach i $sourcing {
    puts $fout $i
  }
  close $fout
  godel_array_save vars .godel/vars.tcl
}
