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
  global curword
  puts $curword
  exec gvim $dicroot/$curword/.godel/ghtm.tcl &
}
# }}}
# open_qn
# {{{
proc open_qn {} {
  global dicroot
  global curword
  puts $curword
  exec gvim $dicroot/$curword/.godel/.qn.md &
}
# }}}
# open_vars
# {{{
proc open_vars {} {
  global dicroot
  global curword
  puts $curword
  exec gvim $dicroot/$curword/.godel/vars.tcl &
}
# }}}
# use_ydict
# {{{
proc use_ydict {} {
  global curword
  puts $curword
  puts [exec ydict $curword]
}
# }}}
# google
# {{{
proc google {} {
  global curword
  puts $curword
  exec firefox https://www.google.com/search?q=$curword &
}
# }}}
# baidu
# {{{
proc baidu {} {
  global curword
  puts $curword
  exec firefox https://fanyi.baidu.com/#en/zh/$curword &
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
  upvar curword curword
  upvar nowfile nowfile
  upvar flist flist
  upvar vars vars
  set origsize [llength $flist]
  #puts $origsize
  .fr.lab configure -text $origsize

  set newsize [expr $origsize - 1]
  puts $newsize
  set random_one [expr [random $origsize] - 1]
  set ifile [lindex $flist $random_one]
  set flist [lreplace $flist $random_one $random_one]
  ##set ifile [lindex $flist 0]
  ##incr size -1

  #puts $ifile
  #regexp {(\w+)\+(.*)$} $ifile whole name chinese
  #puts $name
  #puts $chinese
  #set ::word $name
  .fr.word    configure -text $ifile
  .fr.chinese configure -text ""
  .fr.example configure -text ""

  set curword $ifile


}
# }}}
# next2
# {{{
proc next2 {} {
  upvar curword curword
  upvar nowfile nowfile
  upvar flist flist
  upvar vars vars
  set origsize [llength $flist]
  #puts $origsize
  .fr.lab configure -text $origsize

  set newsize [expr $origsize - 1]
  puts $newsize
  set random_one [expr [random $origsize] - 1]
  set ifile [lindex $flist $random_one]
  set flist [lreplace $flist $random_one $random_one]
  ##set ifile [lindex $flist 0]
  ##incr size -1

  #puts $ifile
  #regexp {(\w+)\+(.*)$} $ifile whole name chinese
  #puts $name
  #puts $chinese
  #set ::word $name
  .fr.word    configure -text ""
  .fr.chinese configure -text $vars($ifile,chinese)
  .fr.example configure -text ""

  set ::answer ""
  focus .fr.answer

  set curword $ifile


}
# }}}
# hint
# {{{
proc hint {} {
  upvar curword curword
  upvar vars vars

  #.fr.chinese configure -text $vars($curword,chinese)

  set qnfile $vars($curword,path)/.godel/.qn.md
  if [file exist $qnfile] {
    set kin [open $qnfile r]
      set txt [read $kin]
    close $kin
    regsub -all {[^a-zA-Z0-9\s\n\.]} $txt {} txt
    .fr.example configure -text $txt
  } else {
  .fr.example configure -text ""
  }

}
# }}}
# disp_chinese
# {{{
proc disp_chinese {} {
  upvar curword curword
  upvar vars vars

  .fr.word    configure -text $curword
  .fr.chinese configure -text $vars($curword,chinese)

  set qnfile $vars($curword,path)/.godel/.qn.md
  if [file exist $qnfile] {
    set kin [open $qnfile r]
      set txt [read $kin]
    close $kin
    .fr.example configure -text $txt
  } else {
  .fr.example configure -text ""
  }

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

proc check_answer {} {
  puts $::answer
  puts $::curword
  set syno [lvars $::dicroot/$::curword synonym]

  if {$syno eq "NA"} {
    set right_answer "$::curword"
  } else {
    set right_answer "$::curword $syno"
  }

  if [regexp $::answer $right_answer] {
    incr ::correct
    .fr.word configure  -text $right_answer
  } else {
    incr ::wrong
  }
  .fr.correct configure -text "O:$::correct"
  .fr.wrong   configure -text "X:$::wrong"
  
}


wm attribute . -topmost 0
#wm geometry . 550x650+0+0
wm geometry . 550x650+900+700
wm title . Dictionary

# Font
font create mynewfont -family Monospace -size 12
option add *font mynewfont

# Frame
frame .fr -padx 5 -pady 5
pack .fr -fill both -expand 1

#.fr configure -bg green

set nowfile "NA"

if {$infile eq ""} {
  puts "No input file"
  return
} else {
  source $infile
  set initlist $allwords
}
#set size 10
set total [llength $initlist]
set flist $initlist

set correct 0
set wrong   0

# Total
label .fr.lab -text "Total:$total"
grid  .fr.lab -row 0 -column 0 -sticky w

label .fr.correct -text "O:$correct"
grid  .fr.correct -row 1 -column 0 -sticky w

label .fr.wrong -text "X:$wrong"
grid  .fr.wrong -row 2 -column 0 -sticky w

label .fr.word -text "na" -pady 10
grid  .fr.word -row 3 -column 0  -sticky w

entry .fr.answer -textvar answer -width 40 -justify left
grid  .fr.answer -row 4 -column 0  -sticky w

label .fr.chinese -text "na" -justify left -wraplength 500 -pady 10
grid  .fr.chinese -row 5 -column 0  -sticky w

label .fr.example -text "na" -justify left -wraplength 500
grid  .fr.example -row 6 -column 0  -sticky w

nextone
focus .fr.answer

bind .          <Control-q>   exit
bind .          <Alt-n>   nextone
bind .          <Alt-m>   next2
bind .          <Alt-o>   disp_chinese
bind .          <Alt-g>   google
bind .          <Alt-b>   baidu
bind .          <Alt-h>   hint
bind .          <Alt-e>   open_qn
bind .          <Alt-v>   open_vars
bind .          <Alt-i>   use_ydict
bind .fr.answer <Return>  check_answer
bind .          <Alt-c>   {set answer ""}


# vim:fdm=marker
