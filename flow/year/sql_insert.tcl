#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

package require sqlite3

set cwd [pwd]

set dirs [glob -type d 20*]

sqlite3 db1 dbfile.db

foreach dir [lsort $dirs] {
  #puts $dir
  #puts $dir
  #set title     [lvars $dir g:title]
  set notes     [lvars $dir notes]
  set ww        [lvars $dir ww  ]
  set date      [lvars $dir date]
  #set age       [lvars $dir age]
  #set views     [lvars $dir views]
  #set tick      [lvars $dir tick]
  #set star      [lvars $dir star]
  #set ctitle    [lvars $dir ctitle]
  #set thrown    [lvars $dir thrown]
  set keywords  [lvars $dir g:keywords]
  #puts $title
  db1 eval "INSERT OR IGNORE INTO dbtable (code) VALUES ('$dir');"

  set sql ""
  append sql "  CREATE TABLE ltable (\n"
  append sql "    rowid   INTEGER PRIMARY KEY AUTOINCREMENT,\n"
  append sql "    key     TEXT UNIQUE,\n"
  append sql "    value   TEXT\n"
  append sql "  );\n"

  regsub -all {'} $notes {''} notes
  set sql ""
  append sql "UPDATE dbtable \n"
  append sql "SET notes          = '$notes',\n"
  #append sql "    title        = '$title',\n"
  #append sql "    views        = '$views',\n"
  append sql "    date         = '$date',\n"
  append sql "    ww           = '$ww',\n"
  #append sql "    ctitle       = '$ctitle'\n,"
  #append sql "    tick         = '$tick',\n"
  #append sql "    star         = '$star',\n"
  #append sql "    thrown       = '$thrown',\n"
  append sql "    'g:keywords' = '$keywords' \n"
  append sql "WHERE code = '$dir'\n"

  #puts $sql
  db1 eval $sql
}

db1 close
