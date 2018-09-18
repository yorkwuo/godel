#: ptpx_runlog
# {{{
proc ptpx_runlog {} {
  upvar vars vars
  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }
  set infile "run.log"
  if [file exist $infile] {
    puts "Working on.. $infile"
  } else {
    puts "Error: Not exist.. $infile"
    return
  }
  set loaded_db          [list]
  set tluplus            [list]
  set vars(mapping_file) NA
  set errors        0

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
# errors
       if [regexp {Error   :} $line] {
      incr errors
# loaded_db: Loading db file...
    } elseif [regexp {Loading db file '(\S+)'} $line whole m1] {
      lappend loaded_db $m1
    }
  }
  close $fin

# liblist
  set loaded_db [lsort -unique $loaded_db]
  set vars(liblist) $loaded_db
# P, V, T
  if [regexp {\d.\d_(\w\w\w\w)_(\S+?v)_(\S+?c)} $vars(liblist) whole P V T] {
    set vars(P) $P
    set vars(V) $V
    set vars(T) $T
  }
  set vars(errors)  $errors
  godel_array_save vars .godel/vars.tcl
}
# }}}
