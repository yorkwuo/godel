#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

lsetvar . kws "Makefile .png .tmp .tcl .index.htm scripts.js style.css"


#------------------------------------
# index.html
#------------------------------------
set kout [open "index.html" w]
puts $kout { <!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>index</title>
  <link href="style.css" rel="stylesheet"/>
</head>
<body>





<script src="scripts.js"></script>
</body>
</html>
}
close $kout

#------------------------------------
# style.css
#------------------------------------
set kout [open "style.css" w]
puts $kout {

}
close $kout

#------------------------------------
# scripts.js
#------------------------------------
set kout [open "scripts.js" w]
puts $kout {}
close $kout
