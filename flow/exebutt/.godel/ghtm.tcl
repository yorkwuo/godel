ghtm_top_bar -save -js
gnotes "
# $vars(g:pagename)
"

puts $fout {

<label>Name</label>
<input type="text" id=name>

  }
puts $fout {<button class="w3-ripple w3-btn w3-white w3-border w3-border-blue w3-round-large" onclick="pp1()">pp1</button>}
puts $fout {<button class="w3-ripple w3-btn w3-white w3-border w3-border-blue w3-round-large" onclick="pp2()">pp2</button>}

