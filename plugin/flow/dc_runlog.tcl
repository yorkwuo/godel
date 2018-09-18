#: dc_runlog
# {{{
proc dc_runlog {} {
  set infile "run.log"
  upvar vars vars
  if [file exist .godel/vars.tcl] { source .godel/vars.tcl }

  if ![godel_proc_get_ready $infile] { return }

  set loaded_db          [list]
  set tluplus            [list]
  set vars(mapping_file) NA
  set errors        0

  set fin  [open $infile r]
  while {[gets $fin line] >= 0} {
# ver,dc: Version.*for
    if [regexp {Version\s(\S+)\sfor} $line whole m1] {
      set vars(ver,dc) $m1
# errors
    } elseif [regexp {Error   :} $line] {
      incr errors
# loaded_db: Loading db file...
    } elseif [regexp {Loading db file '(\S+)'} $line whole m1] {
      lappend loaded_db $m1
# tluplus: tlu+:....
    } elseif [regexp {tlu\+:\s(\S+)} $line whole m1] {
      lappend tluplus $m1
# mapping_file: 
    } elseif [regexp {mapping_file:\s(\S+)} $line whole m1] {
      set vars(mapping_file) $m1
# tech_file: 
    } elseif [regexp {Technology file (\S+) has been} $line whole m1] {
      set vars(tech_file) $m1
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
  set vars(tluplus) $tluplus
  set vars(errors)  $errors
  godel_array_save vars .godel/vars.tcl
}
# }}}
