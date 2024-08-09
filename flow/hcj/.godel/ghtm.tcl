ghtm_top_bar
pathbar 2
mod_links
mod_flist
if [file exist 1.tcl] {
  source 1.tcl
}
gmd 1.md

if ![file exist style.css] {
  catch {exec ./build.tcl}
}

puts $fout "<br>"

linkbox -height 60px -target index.html     -icon $env(GODEL_ROOT)/icons/webpage.png
linkbox -height 60px -target index.html -ed -icon $env(GODEL_ROOT)/icons/html.png -bgcolor white
linkbox -height 60px -target style.css  -ed -icon $env(GODEL_ROOT)/icons/css.png  -bgcolor white
linkbox -height 60px -target scripts.js -ed -icon $env(GODEL_ROOT)/icons/js.png   -bgcolor white

puts $fout "<br><br>"

puts $fout {
<iframe style="border:1px solid pink;" src=index.html width=100% height=1000px></iframe>
}
