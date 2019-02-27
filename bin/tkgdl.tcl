#!/usr/bin/wish
source $env(GODEL_ROOT)/bin/godel.tcl
source .godel/indexing.tcl

set input_keywords [lindex $argv 0]

global colnames
#lappend colnames ttt

#@> draw_table
# {{{
proc draw_table {paths} {
  upvar meta meta
  upvar row row
  global colnames

  foreach gpage $paths {
    set ilist {}
    godel_array_reset vars

    set pp [file dirname [gpage_where $gpage]]/.godel/vars.tcl
    set varspath [tbox_cyg2unix $pp]
    source $varspath

    if [winfo exist .$gpage] {
      puts ".$gpage exist..."
    } else {

    foreach colname $colnames {
      if [info exist vars($colname)] {
        lappend ilist $vars($colname)
      } else {
        lappend ilist ""
      }
    }
  # .r1
    frame .$gpage
  # label
    label .$gpage.c0 -text $row -width 4 -height 1 -borderwidth 2 -relief sunken
    pack .$gpage.c0 -side left

    set column 0
    foreach i $ilist {
  # text
        set colname [lindex $colnames $column]
        text .$gpage.$colname -width 20 -height 1
        .$gpage.$colname insert 1.0 $i
        pack .$gpage.$colname -side left
        incr column
    }
    pack .$gpage -side top -anchor sw
    incr row
  }
  }
}
# }}}
# open_firefox
# {{{
proc open_firefox {} {
  upvar meta meta
  global env
  global colnames
  set focus_text [focus]
  set c [split $focus_text .]
  set gpage [lindex $c 1]

  set pp [gpage_where $gpage]
  #set varspath [tbox_cyg2unix $pp]
  #puts $varspath
  #set f [tbox_cygpath [pwd]]/.index.htm
  #catch {exec /cygdrive/c/Program\ Files/Mozilla\ Firefox/firefox.exe $pp}
  catch {exec $env(GODEL_FIREFOX) $pp}
}
# }}}
# clear_table
# {{{
proc clear_table {} {
  #destroy .r1
  upvar row row
  set wlist [winfo children .]
  foreach w $wlist {
    puts $w
    if [regexp {\.sys} $w] {
    } else {
      destroy $w
    }
  }
  set row 1
}
# }}}
# psave
# {{{
proc psave {} {
  upvar meta meta
  global colnames
  set focus_text [focus]
  set c [split $focus_text .]
  set gpage [lindex $c 1]

  set pp [file dirname [gpage_where $gpage]]/.godel/vars.tcl
  set varspath [tbox_cyg2unix $pp]
  source $varspath

  foreach colname $colnames {
    if [regexp pagename $colname] {
    } else {
      set vars($colname) [string trimright [.$gpage.$colname get 1.0 end] \n]
    }
  }

  godel_array_save vars $varspath
}
# }}}
# open_vars
# {{{
proc open_vars {} {
  upvar meta meta
  global env
  global colnames
  set focus_text [focus]
  set c [split $focus_text .]
  set gpage [lindex $c 1]

  set pp [file dirname [gpage_where $gpage]]/.godel/vars.tcl
  regsub {file:\/} $pp {} pp
  puts $pp
  #set varspath [tbox_cyg2unix $pp]
  #puts $varspath
  #catch {exec /cygdrive/c/Program\ Files\ \(x86\)/Vim/vim81/gvim.exe $pp}
  catch {exec $env(GODEL_GVIM) $pp}
}
# }}}
#@> Main
#pack [button .sysb -text Click -command psave]
#proc Click {widget args} {psave}

# entry
frame .sysctrl
entry .sysctrl.e -textvar col -relief sunken
pack .sysctrl.e -side left -anchor sw
bind .sysctrl.e <Return> {set paths [glist $col -l];  draw_table $paths}
bind .sysctrl.e <Control-u> {set col ""} ;# Clear content
bind . <Alt-e> {focus .sysctrl.e}
focus .sysctrl.e

button .sysctrl.b1 -text Firefox -height 1 -command open_firefox
button .sysctrl.b2 -text Save    -height 1 -command psave
button .sysctrl.b3 -text Delete  -height 1 -command clear_table
button .sysctrl.b4 -text vars    -height 1 -command open_vars
lappend butts .sysctrl.b1
lappend butts .sysctrl.b2
lappend butts .sysctrl.b3
lappend butts .sysctrl.b4
#lappend butts .sysctrl.b5
pack {*}$butts -side left -anchor sw
pack .sysctrl -side top -anchor sw


set row 1
# Label row
frame .sysr0
label .sysr0.c0 -width 4 -height 1 -borderwidth 2 -relief sunken
pack .sysr0.c0 -side left
foreach i $colnames {
  text .sysr0.$i -width 20 -height 1
  .sysr0.$i insert 1.0 $i
  pack .sysr0.$i -side left
}
pack .sysr0 -side top -anchor sw

if {$input_keywords == ""} {
  set input_keywords 11
}
set paths [glist $input_keywords -l]
#set paths [glist godel]


#parray meta
draw_table $paths

set tinfo(row_size) [llength $paths]

#puts [winfo wid .r1.c0]
# Bind
bind . q exit
bind . <Control-d> clear_table
bind . <Control-s> psave

# vim:fdm=marker
