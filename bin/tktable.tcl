#!/usr/bin/tclsh
package require Tktable
source $env(GODEL_ROOT)/bin/godel.tcl

# Read .co to $columns
# {{{
set columns dirname
if [file exist .co] {
  set kin [open ".co" r]
  while {[gets $kin line] > 0} {
    if [regexp {^\s*#} $line] {
    } else {
      lappend columns $line
    }
  }
  close $kin
} else {
  puts "Error: not exist... .co"
  return
}
# }}}
set table_columns_num [llength $columns]

set dirs {}
set tmps [lsort [glob */.godel]]
foreach tmp $tmps {
  lappend dirs [file dirname $tmp]
}

set table_rows_num [llength $dirs]

# array table
# {{{
array set table "
    path            .table_f
    name            .table
    array           T
    rows            $table_rows_num
    cols            $table_columns_num
    titlerows       1
    titlecols       0
    width           80
    height          80
    coltagcommand   colorize
    flashmode       0
    multiline       0
    selectmode      extended
    colstretch      unset
    rowstretch      unset
    sparsearray     1
    browsecommand   {set table(current) %S}
    cell_fg         black
    cell_relief     sunken
"
# }}}

frame $table(path)

set t "$table(path)$table(name)"

# Create table $t
# {{{
table $t \
    -rows $table(rows) \
    -cols $table(cols) \
    -variable $table(array) \
    -titlerows $table(titlerows) \
    -titlecols $table(titlecols) \
    -yscrollcommand [list "$table(path).sy" set] \
    -xscrollcommand [list "$table(path).sx" set] \
    -coltagcommand $table(coltagcommand) \
    -flashmode $table(flashmode) \
    -selectmode $table(selectmode) \
    -colstretch $table(colstretch) \
    -rowstretch $table(rowstretch) \
    -width $table(width) -height $table(height) \
    -multiline $table(multiline) \
    -sparsearray $table(sparsearray) \
    -browsecommand $table(browsecommand)
# }}}

$t tag configure active \
    -fg $table(cell_fg) \
    -relief $table(cell_relief)
	
scrollbar $table(path).sy -command [list $t yview]
scrollbar $table(path).sx -command [list $t xview] -orient horizontal
	
pack $table(path).sx -side bottom -fill x
pack $table(path).sy -side right -fill y
pack $t -side left
pack $table(path)

# Set title
# {{{
for {set i 0} {$i < [llength $columns]} {incr i} {
  set T(0,$i) [lindex $columns $i]
}
# }}}

# Set table content
# {{{
set serial 1
foreach dir $dirs {
  puts $dir
  set T($serial,0) $dir
  for {set i 1} {$i < [llength $columns]} {incr i} {
    
    set value [lvars $dir $T(0,$i)]
    
    if {$value == "NA"} {
      set T($serial,$i) ""
    } else {
      set T($serial,$i) [lvars $dir $T(0,$i)]
    }
  }
  incr serial
}
# }}}

#button .addrow -text "Add Row" -command {AddRowTo $t}
button .savetext -text "Save Text" -command {SaveTableToText $t}
button .close -text "Close" -command {exit}

#pack .addrow .savetext .close -padx 2m -pady 1m -side left
pack .savetext .close -padx 2m -pady 1m -side left

# Key binding
bind . <Escape> exit
bind . <Control-Key-s> {SaveTableToText $t}

# AddRowTo
# {{{
proc AddRowTo {TWidget} {
# Adds a row to the indicated table widget.
#
# TWidget - pathname to table widget you want to add on to

	set Rows [lindex [$TWidget configure -rows] end]
	incr Rows
	$TWidget configure -rows $Rows
}
# }}}
# SaveTableToText
# {{{
proc SaveTableToText {TWidget {SaveFile "SavedVals.txt"}} {
# Saves the rows of a table widget to a text file.  
# Cells values are seperated by a vertical bar.
#
# Twidget - the pathname of the table widget to save
# SaveFile - the path/filename of the save file

	set TableVar [lindex [$TWidget configure -variable] end]
	upvar #0 $TableVar T
	
	set rows [lindex [$TWidget configure -rows] end]
	set cols [lindex [$TWidget configure -cols] end]

  #puts "$rows $cols"
	
	for {set i 1} {$i < $rows} {incr i} {
	  set index "$i,0"
    set rowname $T($index)
    for {set j 1} {$j < $cols} {incr j} {
      set key   $T(0,$j)
      if [info exist T($i,$j)] {
        set value $T($i,$j)
        lsetvar $rowname $key $value
        #puts "lsetvar $rowname $key \"$value\""
      }
    }
  }
  puts "Saved!"

}
# }}}

# vim:fdm=marker
