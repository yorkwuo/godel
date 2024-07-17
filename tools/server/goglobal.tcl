#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

package require sqlite3

set pp [lindex $argv 0]

sqlite3 db1 $env(GLOBALDB)

set pagename [lvars $pp g:pagename]
set kw       [lvars $pp g:keywords]

db1 eval "INSERT OR IGNORE INTO dbtable (path,pagename,keywords) VALUES('$pp','$pagename','$kw');"
db1 eval "UPDATE dbtable SET keywords = '$kw $pagename $pp' WHERE path = '$pp'"
db1 eval "UPDATE dbtable SET pagename = '$pagename' WHERE path = '$pp'"

db1 close
