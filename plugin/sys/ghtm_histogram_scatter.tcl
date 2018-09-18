proc ghtm_histogram_scatter {name bin_size inlist} {
  upvar fout fout
  godel_value_scatter $name $bin_size $inlist
  godel_histogram_color_script \
        .godel/$name.dat \
        $name \
        .godel/$name.png
  catch {exec tcsh -fc "gnuplot -c .godel/$name.plt"}
  puts $fout "<img src=.godel/$name.png>"
  puts $fout "<a type=text/txt href=.godel/$name.tcl>ctrl</a><br>"
}
