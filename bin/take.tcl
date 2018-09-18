#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}
package require Tk
package require tdom
source ~/godel.tcl

proc take_insts {} {
  upvar env env
  exec tcsh -fc "xclip -o > ~/.inst.xml"

  set fin [open ~/.inst.xml r]
  set doc [dom parse [read $fin]]
  close $fin

  set root [$doc documentElement]

  set nodes [$root selectNodes /inst/command/text()]
  foreach node $nodes {
    set cmd [$node nodeValue]
    catch {eval $cmd}
    puts $cmd
  }
  puts "Done Execution!"
  
}
proc print_pwd {} {
  puts [pwd]
}

proc print_clipboard {} {
  puts [exec tcsh -fc "xclip -o"]
}
wm geometry . "5x50-100+200"
wm attribute . -topmost 1
grid [ttk::button .mybutton -text "Go!" -command "take_insts"]
grid [ttk::button .pwd -text "pwd" -command "print_pwd"] 
grid [ttk::button .clip -text "pclip" -command "print_clipboard"] 
