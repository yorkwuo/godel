#!/bin/sh
# the next line restarts using tclsh \
exec tclsh "$0" ${1+"$@"}


source $env(GODEL_ROOT)/bin/godel.tcl

source $env(GODEL_CENTER)/meta.tcl

set kout [open "dir_not_exist.rpt" w]

foreach i [array names meta] {
  #puts $meta($i)
  if [file exist $meta($i)] {
  } else {
    puts       $meta($i)
    puts $kout $meta($i)
    unset meta($i)
  }
}
close $kout

godel_array_save meta $env(GODEL_CENTER)/meta.tcl


# vim:ft=tcl
