#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}

if {$argv eq ""} {
  puts "Usage:"
  puts "fname.tcl -remove \" foo - bar\" *.html -commit"
  puts "fname.tcl -from test -to too *.rpt"
  return
}

# -from (replace from)
# {{{
  set opt(-from) 0
  set idx [lsearch $argv {-from}]
  if {$idx != "-1"} {
    set from [lindex $argv [expr $idx + 1]]
    set argv [lreplace $argv $idx [expr $idx + 1]]
    set opt(-from) 1
  } else {
    set from NA
  }
# }}}
# -to (replace to)
# {{{
  set opt(-to) 0
  set idx [lsearch $argv {-to}]
  if {$idx != "-1"} {
    set to [lindex $argv [expr $idx + 1]]
    set argv [lreplace $argv $idx [expr $idx + 1]]
    set opt(-to) 1
  } else {
    set to NA
  }
# }}}

# -remove (remove)
# {{{
  set opt(-remove) 0
  set idx [lsearch $argv {-remove}]
  if {$idx != "-1"} {
    set remove [lindex $argv [expr $idx + 1]]
    set argv [lreplace $argv $idx [expr $idx + 1]]
    set opt(-remove) 1
  } else {
    set remove NA
  }
# }}}
# -pre (prefix)
# {{{
  set opt(-pre) 0
  set idx [lsearch $argv {-pre}]
  if {$idx != "-1"} {
    set prefix [lindex $argv [expr $idx + 1]]
    set argv [lreplace $argv $idx [expr $idx + 1]]
    set opt(-pre) 1
  } else {
    set prefix NA
  }
# }}}
# -post (postfix)
# {{{
  set opt(-post) 0
  set idx [lsearch $argv {-post}]
  if {$idx != "-1"} {
    set postfix [lindex $argv [expr $idx + 1]]
    set argv [lreplace $argv $idx [expr $idx + 1]]
    set opt(-post) 1
  } else {
    set postfix NA
  }
# }}}
  # -commit
# {{{
  set opt(-commit) 0
  set idx [lsearch $argv {-commit}]
  if {$idx != "-1"} {
    set argv [lreplace $argv $idx $idx]
    set opt(-commit) 1
  }
# }}}


set flist $argv

foreach f $flist {
  #set rootname  [file rootname $f]
  set extension [file extension $f]
  regsub $extension $f {} rootname

  puts $rootname$extension

  set newname ""
  if {$opt(-remove)} {
    if [regsub $remove $f {} newname] {
      #puts "$newname"
    }
  } elseif {$opt(-from)} {
    regsub $from $f $to newname
  } else {
    if {$opt(-pre)} {
      if {$opt(-post)} {
        set newname $prefix.$rootname.$postfix$extension
      } else {
        set newname $prefix.$rootname$extension
      }
    } else {
      set newname $rootname$extension
    }
  }

#  if {$f eq $newname} {
#  } else {
#    puts "$f"
#    puts "    $newname"
#  }

  if {$opt(-commit)} {
    if {$f eq $newname} {
    } else {
      #puts "mv $f $newname"
      exec mv -- $f $newname
      #regsub -all {\-} $f {-} f
      #puts $f
      #file rename -force "$f" $newname
    }
  }
}


# vim:fdm=marker
