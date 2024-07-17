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
catch {exec find $cwd -name ".godel"} result

sqlite3 db1 .dbfile.db

foreach line $result {
  set dir [file dirname $line]

  set pagename [lvars $dir g:pagename]
  set kw       [lvars $dir g:keywords]
  regsub -all {'} $pagename {''} pagename
  #puts $dir
  #puts $pagename

  db1 eval "INSERT OR IGNORE INTO dbtable (path,pagename,keywords) VALUES('$dir','$pagename','$kw');"
  db1 eval "UPDATE dbtable SET keywords = '$kw $pagename $dir' WHERE path = '$dir'"
  db1 eval "UPDATE dbtable SET pagename = '$pagename' WHERE path = '$dir'"
}

db1 close
