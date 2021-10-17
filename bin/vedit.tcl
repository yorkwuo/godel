#!/usr/bin/tclsh

# pmodule
# {{{
proc pmodule {inst2print} {
# pmodule -modlist $modlist -inst2print $inst2print
  upvar data data
  upvar ofile ofile
  upvar fhandle fhandle

  set lines [split $data "\n"]

  lappend keywords "module "
  lappend keywords "input "
  lappend keywords "inout "
  lappend keywords "output "
  lappend keywords "wire "
  lappend keywords "tri "
  lappend keywords "endmodule"

  foreach line $lines {

    foreach key $keywords {
      if [regexp $key $line] {
        puts $fhandle $line
        continue
      }
    }
    
    foreach pinst [lsort -unique $inst2print] {
      if [regexp {\s+(\w+)\s+(\w+) } $line -> module inst] {
        if {$inst eq $pinst} {
          puts $fhandle $line
        }
      }
    }
  }

}
# }}}
# write_out
# {{{
proc write_out {ofile} {
  upvar mdata    mdata
  upvar outlist    outlist
  upvar inst2print inst2print

  set outlist [lsort -unique $outlist]

  set fhandle [open $ofile w]
  foreach mod $outlist {
    set data $mdata($mod)
  
    if [info exist inst2print($mod)] {
      pmodule $inst2print($mod)
    } else {
      pmodule ""
    }
  
  }
  close $fhandle
}
# }}}
# write_flat
# {{{
proc write_flat {ofile} {
# `flat' in here means `a line in a verilog netlist isn't splitted'
  upvar mdata    mdata
  upvar modlist  modlist

  if {$ofile eq ""} {
  } else {
    set kout [open $ofile w]
  }

  if {$ofile eq ""} {
    foreach mod $modlist {
      puts $mdata($mod)
    }
  } else {
    foreach mod $modlist {
      puts $kout $mdata($mod)
    }
  }

  if {$ofile eq ""} {
  } else {
    close $kout
  }
}
# }}}
# read_netlist
# {{{
proc read_netlist {ifile} {
# System variables
# modlist: module list
# modinst: An array contains inst list in a module. Ex: $modinst(pll_wrapper)
# mdata  : An array contains a module in `no split' format.

  upvar modlist modlist
  upvar mdata   mdata
  upvar modinst modinst
  upvar moddata moddata

  set fp [open $ifile r]
    set data [read $fp]
  close $fp
  
  
  # extract module to endmodule
  set matches [regexp -all -inline {module.*?endmodule} $data]
  
  foreach data $matches {
    regsub -all {\n} $data {}    data
    regsub -all {;}  $data ";\n" data
  
  # extract module name
    regexp {module\s+(\w+)} $data -> mod

  # module list
    set mdata($mod) $data
    lappend modlist $mod

   build_modinst $mod $data
  
  }
}
# }}}
# build_modinst
# {{{
proc build_modinst {mod data} {
  upvar modinst modinst
  set lines [split $data "\n"]
  foreach line $lines {
    if [regexp {module } $line] {
    } elseif [regexp {assign } $line] {
    } elseif [regexp {input } $line] {
    } elseif [regexp {inout } $line] {
    } elseif [regexp {output } $line] {
    } elseif [regexp {wire } $line] {
    } elseif [regexp {tri } $line] {
    } elseif [regexp {endmodule} $line] {
    } else {
      regexp {\s*(\w+)\s+(\w+)\s} $line -> module inst
      set modinst($mod,$inst) $module
    }
  }
}
# }}}
# get_modules
# {{{
proc get_modules {instname} {
  upvar modinst    modinst
  upvar top_module top_module
  upvar inst2print inst2print
  upvar outlist    outlist

  set insts [split $instname "/"]
  set end_inst [lindex $insts end]
  set insts    [lrange $insts 0 end-1]

  set next_module $top_module
  lappend outlist $top_module

  foreach inst $insts {
    set current_module $next_module
    lappend inst2print($current_module) $inst
    set next_module $modinst($current_module,$inst)
    lappend outlist $next_module
  }
  set current_module $next_module
  lappend inst2print($current_module) $end_inst
}
# }}}

# vim:fdm=marker
