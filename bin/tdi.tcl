#!/usr/bin/wish
source $env(GODEL_ROOT)/bin/godel.tcl
set dicroot $env(GODEL_DIC)
  # -f (filelist name)
# {{{
  set opt(-f) 0
  set idx [lsearch $argv {-f}]
  if {$idx != "-1"} {
    set listfile [lindex $argv [expr $idx + 1]]
    set argv [lreplace $argv $idx [expr $idx + 1]]
    set opt(-f) 1
  } else {
    set listfile NA
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
  #puts [exec ydict $curword -v 1]
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
  upvar initlist initlist
  upvar vars vars

  set origsize [llength $flist]

  if {$origsize eq "0"} {
    puts kkkk
    set flist $initlist
    set origsize [llength $flist]
    set ::total $origsize
    set ::correct 0
    set ::wrong   0
    .fr.correct configure -text "O:$::correct"
    .fr.wrong   configure -text "X:$::wrong"
  }

  .fr.lab configure -text $origsize

  set newsize [expr $origsize - 1]
  puts $newsize
  set random_one [expr [random $origsize] - 1]
  set ifile [lindex $flist $random_one]
  set flist [lreplace $flist $random_one $random_one]

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

  if {$origsize eq "0"} {
    puts kkkk
    set flist $::initlist
    set origsize [llength $flist]
    set ::total $origsize
    set ::correct 0
    set ::wrong   0
    .fr.correct configure -text "O:$::correct"
    .fr.wrong   configure -text "X:$::wrong"
  }

  .fr.lab configure -text $origsize

  set newsize [expr $origsize - 1]
  puts $newsize
  set random_one [expr [random $origsize] - 1]
  set ifile [lindex $flist $random_one]
  set flist [lreplace $flist $random_one $random_one]

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
if {$opt(-f)} {
  set infile $listfile

  set dicdir $dicroot

  set kout [open $env(HOME)/words w]
  set kin [open $listfile r]
  while {[gets $kin line] >= 0} {
    if [regexp {^\s*#} $line] {
    } elseif [regexp {^\s*$} $line] {
    } else {
      set w $line
      if [file exist $dicdir/$w] {
        set chinese [lvars $dicdir/$w chinese]
        puts $kout "lappend allwords $w"
        puts $kout "set vars($w,path) $dicdir/$w"
        puts $kout "set vars($w,chinese) \"$chinese\""    
        puts $kout "set vars($w,concat) \"$w $chinese\""
      } else {
        puts "Not exist... $w"
      }
    }
  }
  close $kin
  close $kout

  set infile $env(HOME)/words
} else {
  set infile $env(GODEL_DIC)/words
}
# }}}

# check_answer
# {{{
proc check_answer {} {
  upvar vars vars
  puts $::answer
  puts $::curword
  set syno [lvars $::dicroot/$::curword synonym]

  if {$syno eq "NA"} {
    set right_answer "$::curword"
  } else {
    set right_answer "$::curword $syno"
  }

  if [regexp "\\y$::answer\\y" $right_answer] {
    incr ::correct
    .fr.word configure  -text $right_answer
    set ::answer ""

    set qnfile $vars($::curword,path)/.godel/.qn.md
    if [file exist $qnfile] {
      set kin [open $qnfile r]
        set txt [read $kin]
      close $kin
      regsub -all {[^a-zA-Z0-9\s\n\.]} $txt {} txt
      .fr.example configure -text $txt
    } else {
    .fr.example configure -text ""
    }
  } else {
    incr ::wrong
  }

  .fr.correct configure -text "O:$::correct"
  .fr.wrong   configure -text "X:$::wrong"
  
}
# }}}

bind .          <Control-q>   exit

wm attribute . -topmost 0
wm geometry . 550x650+900+700
wm title . Dictionary

# Font
font create mynewfont -family Monospace -size 14
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

#nextone
focus .fr.answer

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
