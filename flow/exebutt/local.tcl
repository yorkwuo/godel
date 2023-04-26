
proc pp1 {} {
  upvar evar evar
  puts "pp1: $evar(name)"
}

proc pp2 {} {
  upvar evar evar

  puts "pp2: $evar(name)"
}

exec mv /home/york/downloads/input.tcl .

source input.tcl

eval $evar(proc)


