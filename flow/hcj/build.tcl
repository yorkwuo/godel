#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

# -app
# {{{
set opt(-app) 0
set idx [lsearch $argv {-app}]
if {$idx != "-1"} {
  set argv [lreplace $argv $idx $idx]
  set opt(-app) 1
}
# }}}

lsetvar . kws "Makefile .png .tmp .tcl .index.htm scripts.js style.css app.js"

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

#------------------------------------
# app.js
#------------------------------------
if {$opt(-app) eq "1"} {
set kout [open "app.js" w]
puts $kout {
const path = require('path');
const modulePath = path.join('/usr/local/lib/node_modules', 'express');
const express = require(modulePath);
const app = express();

app.get('/', (req, res) => {
  res.send('Hello World!');
});


// Port Number
const port = 3001;
  
// Server setup
app.listen(port, () => {
  console.log(`Server running on port ${port}`)
});
}
close $kout
}


# vim:fdm=marker
