#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl
package require tdom
set ifile [lindex $argv 0]
set ofile [lindex $argv 1]

proc svg_p2p {p1 p2} {
  upvar txt txt
  upvar svar svar
  append txt  "<line x1=\"$svar($p1,x)\" y1=\"$svar($p1,y)\" x2=\"$svar($p2,x)\" y2=\"$svar($p2,y)\" stroke=\"#000\" stroke-width=\"4\" marker-end=\"url(#arrowhead)\" />\n"
}

set kin [open "$ifile" r]
  set data [read $kin]
close $kin

set doc [dom parse $data]
set root [$doc documentElement]
set nodeList [$root selectNodes {descendant::*}]
foreach node $nodeList {
    set attList [$node attributes *]
    set nodename [$node nodeName]
    if {$nodename eq "circle"} {
      set id [$node getAttribute id]
      set cx [format "%.f" [$node getAttribute cx]]
      set cy [format "%.f" [$node getAttribute cy]]
      set svar($id,x) $cx
      set svar($id,y) $cy
    }
}

append txt  "<defs>\n"
append txt  "  <marker id=\"arrowhead\" markerWidth=\"10\" markerHeight=\"7\" \n"
append txt  "  refX=\"0\" refY=\"2\" orient=\"auto\">\n"
append txt  "    <polygon points=\"0 0, 4 2, 0 4\" />\n"
append txt  "  </marker>\n"
append txt  "</defs>\n"

svg_p2p pA pB
svg_p2p pB pC
svg_p2p pA pD

append txt  "</svg>\n"

regsub {</svg>} $data $txt data

set kout [open $ofile w]
  puts $kout $data
close $kout
