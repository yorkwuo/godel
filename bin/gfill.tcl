#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
if {$argv == ""} {
  puts "Usage:"
  puts "% gfill.tcl -f list.f -k foobar -v 999 *"
  return
}

# -s
# {{{
set opt(-s) 0
set idx [lsearch $argv {-s}]
if {$idx != "-1"} {
  set argv [lreplace $argv $idx $idx]
  set opt(-s) 1
}
# }}}
# -f listfile
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
# -k (keyword)
# {{{
set opt(-k) 0
set idx [lsearch $argv {-k}]
if {$idx != "-1"} {
  set key  [lindex $argv [expr $idx + 1]]
  set argv [lreplace $argv $idx [expr $idx + 1]]
  set opt(-k) 1
}
# }}}
# -v (value)
# {{{
set opt(-v) 0
set idx [lsearch $argv {-v}]
if {$idx != "-1"} {
  set default_value [lindex $argv [expr $idx + 1]]
  set argv  [lreplace $argv $idx [expr $idx + 1]]
  set opt(-v) 1
}
# }}}
# -vlist (value list)
# {{{
set opt(-vlist) 0
set idx [lsearch $argv {-vlist}]
if {$idx != "-1"} {
  set vlist_fname [lindex $argv [expr $idx + 1]]
  set argv  [lreplace $argv $idx [expr $idx + 1]]
  set opt(-vlist) 1
}
# }}}


set pattern $argv

if {$opt(-s)} {
  #puts $pattern
  set attrs [read_file_ret_list .co]

  puts "#!/usr/bin/tclsh"
  puts "source \$env(GODEL_ROOT)/bin/godel.tcl"
  foreach attr $attrs {
    regsub {;.*$} $attr {} attr

    set value [lvars $pattern $attr]
    if {$value == "NA"} {
      if {$opt(-v)} {
        set value $default_value
      }
    }

    #puts $attr
    puts [format "lsetvar %-20s %-15s \"%s\"" $pattern $attr $value]
  }
  
} else {

  if {$opt(-f)} {
    set kin [open $listfile r]
      while {[gets $kin line] >= 0} {
        lappend nlist $line
      }
    close $kin
  } else {
    set nlist [glob -nocomplain -type d {*}$pattern]
  }
  puts "#!/usr/bin/tclsh"
  puts "source \$env(GODEL_ROOT)/bin/godel.tcl"
  foreach page $nlist {
    set value [lvars $page $key]
    if {$value == "NA"} {
      if {$opt(-v)} {
        set value $default_value
      }
    }
    set aux   [lvars $page g:pagename]
    puts [format "lsetvar %-30s %-15s \"%s\" ;# %s" $page $key $value $aux]
  }

}

#if $opt(-vlist) {
#} else {
#}


# vim:fdm=marker
