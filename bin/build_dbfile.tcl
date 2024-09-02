#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
package require sqlite3

#---------------------------
# create .dbfile.db
#---------------------------
sqlite3 db1 ./.dbfile.db

set sql {
  CREATE TABLE dbtable (
    path      TEXT PRIMARY KEY,
    pagename  TEXT,
    keywords  TEXT
  );
}

db1 eval $sql

db1 close

#---------------------------
# import pages to .dbfile.db
#---------------------------

set cwd [pwd]
#catch {exec find $cwd -maxdepth 2 -name ".godel"} result
#catch {exec tcsh -fc "\ls -1 -d $cwd/*King*/.godel"} result
catch {exec tcsh -fc "\ls -1 -d $cwd/*/.godel"} result

set lines [split $result "\n"]

sqlite3 db1 .dbfile.db

foreach line $lines {
  puts $line
  if {$line eq "[pwd]/.godel"} {continue}
  set dir [file dirname $line]

  set pagename [lvars $dir g:pagename]
  set kw       [lvars $dir g:keywords]
  regsub -all {'} $pagename {''} pagename
  regsub -all {'} $dir {''} dir
  regsub -all {'} $kw {''} kw

  #puts $pagename
  #puts $dir
  #puts $kw

  db1 eval "INSERT OR IGNORE INTO dbtable (path,pagename,keywords) VALUES('$dir','$pagename','$kw');"
  db1 eval "UPDATE dbtable SET keywords = '$kw $pagename' WHERE path = '$dir'"
  db1 eval "UPDATE dbtable SET pagename = '$pagename' WHERE path = '$dir'"
}

db1 close
