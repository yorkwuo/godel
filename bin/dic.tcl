#!/usr/bin/wish
source $env(GODEL_ROOT)/bin/godel.tcl
set dicroot $env(GODEL_DIC)
# -l (local)
# {{{
  set opt(-l) 0
  set idx [lsearch $argv {-l}]
  if {$idx != "-1"} {
    set argv [lreplace $argv $idx $idx]
    set opt(-l) 1
  }
# }}}
# -k
# {{{
  set opt(-k) 0
  set idx [lsearch $argv {-k}]
  if {$idx != "-1"} {
    set keyword [lindex $argv [expr $idx + 1]]
    set argv [lreplace $argv $idx [expr $idx + 1]]
    set opt(-k) 1
  } else {
    set keyword NA
  }
# }}}
# open_ghtm
# {{{
proc open_ghtm {} {
  global dicroot
  global filter
  puts $filter
  exec gvim $dicroot/$filter/.godel/ghtm.tcl &
}
# }}}
# use_ydict
# {{{
proc use_ydict {} {
  global filter

  puts $filter
  #puts [exec ydict $filter]
  #catch "exec ydict $filter -v 1" result
  catch "exec ydict $filter" result

  puts $result
  set lines [split $result \n]

  set endline [lgrep_index $lines {^$} 4]

  set ::ydict_value ""
  foreach ll [lrange $lines 4 $endline] {
    if [regexp {^\s*$} $ll] {
    } else {
      regsub {^\s*} $ll {} ll
      append ::ydict_value "$ll "
    }
  }

  set content ""
  foreach line [lrange $lines $endline end] {
    regsub {^\s*} $line {} line
    append content "$line\n"
  }
  set ::ydict_content $content
}
# }}}
# auto_fill
# {{{
proc auto_fill {} {
  regsub -all {\[} $::ydict_value {(} ::ydict_value
  regsub -all {\]} $::ydict_value {)} ::ydict_value
  set ::chinese $::ydict_value

  .fr.txt insert 1.0 "$::ydict_content"
}
# }}}
# google
# {{{
proc google {} {
  global filter
  puts $filter
  exec firefox https://www.google.com/search?q=$filter &
}
# }}}
# baidu
# {{{
proc baidu {} {
  global filter
  puts $filter
  exec firefox https://fanyi.baidu.com/#en/zh/$filter &
}
# }}}
# random
# {{{
proc random {{num 10}} {return [expr {int(1 + rand() * $num)}]}
# }}}
# folder
# {{{
proc folder {} {
  upvar nowfile nowfile

  set dir [file dirname $nowfile]
  exec nautilus $dir &

}
# }}}
# nextone
# {{{
proc nextone {} {
  global dicroot
  global filter
  puts $filter
  exec firefox $dicroot/$filter/.index.htm &

}
# }}}
# filter_out
# {{{
proc filter_out {} {
  upvar vars vars
  global dicroot
  global filter
  upvar initlist initlist
  upvar flist flist

  set flist {}
  if {$filter eq ""} {
    set flist $initlist
  } else {
      if {$flist eq ""} {
        set tobefilter $initlist
      } else {
        set tobefilter $flist
      }
      set flist ""
      foreach word $tobefilter {
        if [regexp -nocase $filter $vars($word,concat)] {
          lappend flist $word
        }
      }
  }
  set founds [llength $flist]
  .fr.lab configure -text $founds

  if [info exist vars($filter,path)] {
    set qnfile $vars($filter,path)/.godel/.qn.md
    if [file exist $qnfile] {
      .fr.txt delete 1.0 end
      set kin [open $qnfile r]
      set content [read $kin]
      close $kin
      .fr.txt insert 1.0 "\n$content"
    }
  } elseif [file exist $dicroot/$filter] {
    set qnfile $dicroot/$filter/.godel/.qn.md
    if [file exist $qnfile] {
      .fr.txt delete 1.0 end
      set kin [open $qnfile r]
      set content [read $kin]
      close $kin
      .fr.txt insert 1.0 "\n$content"
    }
  } else {
    .fr.txt delete 1.0 end
  }

  set root $dicroot
  set chi [lvars $root/$filter chinese]
  if {$chi eq "NA"} {
    set ::chinese ""
    .fr.txt delete 1.0 end
  } else {
    set ::chinese $chi
  }
}
# }}}
# refresh_list
# {{{
proc refresh_list {} {
  global flist
  upvar vars vars
  .fr.l1 delete 0 end

  set items ""
  foreach f [lsort $flist] {
    set name $f
    set chinese $vars($f,chinese)
    lappend items [format "%-20s %s" $name $chinese]
  }
  .fr.l1 insert 0 {*}$items
}
# }}}
# clear
# {{{
proc clear {} {

  set ::filter ""
  set ::chinese ""
  .fr.txt delete 1.0 end
  focus .fr.filter
}
# }}}
# tag_window
# {{{
proc tag_window {} {
  toplevel .tagwin
  #wm geometry .tagwin 500x300+300+0
  wm geometry .tagwin 500x300

  set keys ""
  source /home/york/pages/ltools/pn.tcl/etc/jlist.tcl


  set count 0
  foreach key $keys {
    set name    [lindex $key 0]
    set pattern [lindex $key 1]

    if {$pattern eq ""} {
      ttk::button .tagwin.$key -text $name -command "set ::filter $name; filter_out"
    } else {
      ttk::button .tagwin.$key -text $name -command "set ::filter $pattern; filter_out"
    }

    set countX [expr $count % 10]
    set countY [expr [expr $count / 10] + 1]
    grid .tagwin.$key -row $countX -column $countY

    incr count
  }

  bind .tagwin a {destroy .tagwin}
}
# }}}
# add
# {{{
proc add {} {
  upvar vars vars
  global dicroot
  global filter
  global chinese
  global initlist
  global flist
  global synonym

  set root $dicroot

  if [file exist $root/$filter] {
      puts "lsetvar $dicroot/$filter chinese $chinese"
      lsetvar $dicroot/$filter chinese "$chinese"
      puts "lsetvar $dicroot/$filter synonym $synonym"
      lsetvar $dicroot/$filter synonym "$synonym"
  } else {
      puts "gdir $root/$filter"
      file mkdir $root/$filter
      godel_draw $root/$filter
      puts "lsetvar $dicroot/$filter chinese $chinese"
      lsetvar $dicroot/$filter chinese "$chinese"
      puts "lsetvar $dicroot/$filter synonym $synonym"
      lsetvar $dicroot/$filter synonym "$synonym"
  }

  # write to .qn.md
  set qnfile $dicroot/$filter/.godel/.qn.md
  set kout [open $qnfile w]
    set txt [.fr.txt get 1.0 end]
    regsub {^\s+} $txt {} txt
    puts $kout $txt
  close $kout


  #set flist $initlist
  #puts jjj
  #parray vars

  #update_dic
  #refresh_list

  set ::filter ""
  set ::chinese ""
  set ::synonym ""
  .fr.txt delete 1.0 end
  focus .fr.filter

  #.fr.lab configure -text [llength $::initlist]

}
# }}}
# infile
# {{{
if {$opt(-l)} {
  if [file exist playlist] {
  } else {
    if [file exist "orig.playlist"] {
      catch {exec cp orig.playlist playlist}
    } else {
      set ifiles [glob -nocomplain -type f *]
      set kout [open "playlist" w]
        foreach ifile $ifiles {
          if [regexp {\.part} $ifile] {
          } else {
            puts $kout $ifile
          }
        }
      close $kout
    }
  }
  set infile playlist
} else {
  set infile [lindex $argv 0]
}
# }}}
# update_dic
# {{{
proc update_dic {} {
  upvar vars vars
  global dicroot
  upvar initlist initlist
  upvar total total
  upvar flist flist

  set dicdir $dicroot

  set words [glob -type d $dicdir/*]
   
  set kout [open $dicdir/words w]
  foreach word $words {
    set w [file tail $word]
    #set name    [lvars $dicdir/$w g:pagename]
    set chinese [lvars $dicdir/$w chinese]
    #puts $kout "$name+$chinese"
    puts $kout "lappend allwords $w"
    puts $kout "set vars($w,path) $word"
    puts $kout "set vars($w,chinese) \"$chinese\""    
    puts $kout "set vars($w,concat) \"$w $chinese\""
  }
  close $kout

  puts "Updated... $dicdir/words"

  set initlist {}
  source $dicdir/words
  #set kin [open $dicdir/words r]
  #  while {[gets $kin line] >= 0} {
  #    lappend initlist $line
  #  }
  #close $kin
  set initlist $allwords

  set size 10
  set total [llength $initlist]
  set flist $initlist

}
# }}}
# select
# {{{
proc select {} {
  global dicroot
  upvar vars vars
  set selected [lindex [.fr.l1 get [.fr.l1 curselection]] 0]
  set ::filter $selected

  set root $dicroot

  set chi [lvars $root/$selected chinese]
  if {$chi eq "NA"} {
    set ::chinese ""
  } else {
    set ::chinese $chi
  }
  set syno [lvars $root/$selected synonym]
  if {$syno eq "NA"} {
    set ::synonym ""
  } else {
    set ::synonym $syno
  }

  .fr.txt delete 1.0 end

  set qnfile $vars($selected,path)/.godel/.qn.md
  if [file exist $qnfile] {
    .fr.txt delete 1.0 end
    set kin [open $qnfile r]
    set content [read $kin]
    close $kin

    #regsub -all {[^a-zA-Z0-9\s\n\.]} $content {} content

    .fr.txt insert 1.0 "\n$content"
  } else {
    .fr.txt insert 1.0 ""
  }

}
# }}}
# delete
# {{{
proc delete {} {
  upvar env env
  upvar vars vars
  global dicroot
  global filter
  global chinese
  global initlist
  global flist
  global synonym

  puts "Delete... $env(GODEL_DIC)/$filter"

  catch {exec rm -rf $env(GODEL_DIC)/$filter}

  set ::filter ""
  set ::chinese ""
  set ::synonym ""

  update_dic
  refresh_list
}
# }}}


wm attribute . -topmost 0
wm geometry . 550x650+900+700
wm title . Dictionary

# Font
# {{{
font create mynewfont -family Monospace -size 10
option add *font mynewfont
# }}}
# Frame
# {{{
frame .fr -padx 5 -pady 5
pack .fr -fill both -expand 1
# }}}


set nowfile "NA"

if {$infile eq ""} {
  puts "No input file"
  return
} else {
  source $infile
  set initlist $allwords
}
set size 10
set total [llength $initlist]
set flist $initlist


# Total
label .fr.lab -text "Total: $total"
grid  .fr.lab -row 0 -column 0 -sticky sw

ttk::button .fr.add -text "Add" -command add
grid .fr.add -row 1 -column 0 -sticky e

# Entry for keyin
entry .fr.filter -textvar filter -width 60
grid  .fr.filter -row 2 -column 0 

entry .fr.chinese -textvar chinese -width 60
grid  .fr.chinese -row 3 -column 0

entry .fr.synonym -textvar synonym -width 60
grid  .fr.synonym -row 4 -column 0

text .fr.txt -width 60 -height 12
grid .fr.txt -row 5 -column 0

listbox .fr.l1 -width 60 -height 30
grid    .fr.l1 -row 6 -column 0

#refresh_list


bind .fr.l1     n           nextone
bind .fr.l1     h           open_ghtm
bind .fr.l1     g           google
bind .fr.l1     b           baidu
bind .fr.l1     <B1-ButtonRelease> select
bind .fr.l1     <Double-B1-ButtonRelease> baidu
bind .          <Alt-h>     open_ghtm
bind .          <Alt-e>     add
bind .          <Alt-n>     nextone
bind .          <Alt-g>     google
bind .          <Alt-b>     baidu
bind .          <Control-u> clear
bind .          <Alt-c> clear
bind .fr.filter <Return>    {filter_out;refresh_list}
bind .          <Control-q> exit
bind .          <Escape>    clear
bind .          <Alt-i>     use_ydict
bind .          <Alt-w>     {focus .fr.txt;tk::TextSetCursor .fr.txt 1.0}

bind . <Alt-f> {focus .fr.filter}
bind . <Alt-c> clear
bind . <Alt-p> auto_fill
bind . <Control-d> delete

focus .fr.filter

# If keyword provided...
if {$opt(-k)} {
  set ::filter $keyword
  filter_out
}


# vim:fdm=marker
