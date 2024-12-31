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

puts $fout "<div style='display:flex'>"
linkbox -height 60px -target index.html     -icon $env(GODEL_ROOT)/icons/webpage.png
linkbox -height 60px -target index.html -ed -icon $env(GODEL_ROOT)/icons/html.png -bgcolor white
linkbox -height 60px -target style.css  -ed -icon $env(GODEL_ROOT)/icons/css.png  -bgcolor white
linkbox -height 60px -target scripts.js -ed -icon $env(GODEL_ROOT)/icons/js.png   -bgcolor white
puts $fout "</div>"

if [file exist app.js] {
  linkbox -height 60px -target app.js -ed -icon $env(GODEL_ROOT)/icons/ex.png -bgcolor white
  linkbox -height 60px -target http://localhost:3001     -icon $env(GODEL_ROOT)/icons/webpage.png
}


puts $fout "<br><br>"

puts $fout {
<iframe style="border:1px solid pink;" src=index.html width=100% height=300px></iframe>
}

if [file exist app.js] {
puts $fout {
<iframe style="border:1px solid pink;" src=http://localhost:3001 width=100% height=300px></iframe>
}
}
