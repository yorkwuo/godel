
proc pp1 {} {
  upvar evar evar
  puts "pp1: $evar(name)"
}

proc pp2 {} {
  upvar evar evar

  puts "pp2: $evar(name)"
}

exec mv $env(GODEL_DOWNLOAD)/input.tcl .

source input.tcl

eval $evar(proc)


