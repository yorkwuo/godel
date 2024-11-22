#!/usr/bin/tclsh
package require sqlite3

catch {exec rm -rf dbfile.db}

sqlite3 db1 ./dbfile.db

set sql ""
append sql "  CREATE TABLE dbtable (\n"
append sql "    rowid    INTEGER PRIMARY KEY AUTOINCREMENT,\n"
append sql "    code     TEXT type UNIQUE,\n"
append sql "    notes    TEXT,\n"
#append sql "    hit      INTEGER,\n"
append sql "    date     TEXT,\n"
#append sql "    files    TEXT,\n"
#append sql "    thrown   INTEGER,\n"
#append sql "    count    INTEGER,\n"
#append sql "    chp      INTEGER,\n"
#append sql "    ctitle   INTEGER,\n"
#append sql "    tick     INTEGER,\n"
#append sql "    CU       INTEGER,\n"
#append sql "    star     INTEGER,\n"
#append sql "    size     INTEGER,\n"
#append sql "    sizeB    INTEGER,\n"
#append sql "    last     TEXT,\n"
append sql "    'g:keywords' TEXT,\n"
#append sql "    views    INTEGER,\n"
append sql "    ww    TEXT\n"
append sql "  );\n"

db1 eval $sql

set sql ""
append sql "  CREATE TABLE ltable (\n"
append sql "    rowid   INTEGER PRIMARY KEY AUTOINCREMENT,\n"
append sql "    key     TEXT UNIQUE,\n"
append sql "    value   TEXT\n"
append sql "  );\n"

db1 eval $sql

db1 close
