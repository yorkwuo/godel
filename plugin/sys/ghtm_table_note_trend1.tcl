proc ghtm_table_note_trend1 {tname attr} {
  upvar vars vars
  upvar fout fout
  upvar rowlist rowlist
  upvar trend1_x trend1_x

  source .godel/$tname.table.ctrl.tcl
  #set attr $trend1_y
# create plot script
  gnuplot_trend1_script .godel/$tname.chart.$attr.dat \
                        .godel/$tname.chart.$attr \
                        .godel/$tname.chart.$attr.png

# create plot data
  set kout [open ".godel/$tname.chart.$attr.dat" w]
  # foreach version
  foreach x $rowlist {
    if [info exist vars($x,$attr)] {
      if {$vars($x,$attr) != "NA"} {
        set wns [expr abs($vars($x,$attr))]
          set xaxis $x
        #if {$trend1_x == "NA"} {
        #  set xaxis $x
        #} else {
        #  set xaxis $vars($x,$trend1_x)
        #}
        puts $kout "$xaxis $wns"
      }
    }
  }
  close $kout

# execute gnuplot command
  catch {exec tcsh -fc "gnuplot -c .godel/$tname.chart.$attr.plt"}
  #exec tcsh -fc "gnuplot -c $tname.chart.$attr.plt"
  
# display img in html
  puts $fout "<img src=.godel/$tname.chart.$attr.png>"
  puts $fout "<a type=text/txt href=.godel/$tname.chart.$attr.tcl>ctrl</a><br>"
}
