#!/usr/bin/tclsh
package require Tcl 8.5
package require csv
package require html
package require struct::queue
 
set infile [lindex $argv 0]

if {$infile == ""} {
puts "Usage: "
puts "% csv2html.tcl foo.csv > foo.html"

return
}

set fin [open $infile r]
  set csvData [read $fin]
close $fin
 
#html::init {
#    table.border 1
#    table.summary "csv2html program output"
#    tr.bgcolor orange
#}
html::init {
    table.class "table1"
}
 
# Helpers; the html package is a little primitive otherwise
proc table {contents {opts ""}} {
    set out [html::openTag table $opts]
    append out [uplevel 1 [list subst $contents]]
    append out [html::closeTag]
}
proc tr {list {ropt ""}} {
    set out [html::openTag tr $ropt]
    foreach x $list {append out [html::cell "" $x td]}
    append out [html::closeTag]
}
 
# Parse the CSV data
struct::queue rows
foreach line [split $csvData "\n"] {
    csv::split2queue rows $line
}
 
puts "<html>"
puts "<head>"
puts "<title>$infile</title>"
puts "<style>"
puts ""
puts ".table1 {"
puts "  font-family:sans-serif;"
puts "  border-collapse: collapse;"
puts "}"
puts ".table1 td, .table1 th{"
puts "  padding: 5px;"
puts "  font-size:14px;"
puts "  text-align: left;"
puts "  border-bottom: 1px solid #ddd;"
puts "  border: 1px solid black;"
puts "  border-color: #f79646 #ccc;  "
puts "}"
puts "</style>"
puts "</head>"
# Generate the output
puts [subst {
    [table {
      [tr [html::quoteFormValue [rows get]] {bgcolor="yellow"}]
      [html::while {[rows size]} {
          [tr [html::quoteFormValue [rows get]]]
      }]
    }]
}]

puts "</html>"
