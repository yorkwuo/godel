function pp1() {

  var first = document.getElementById("name").value;

  var data = "";
  data = data + 'set evar(proc) pp1\n'
  data = data + 'set evar(name) ' + first + "\n";

  dload(data,'input.tcl');

  document.getElementById('idexec').click();
}


function pp2() {

  var first = document.getElementById("name").value;

  var data = "";
  data = data + 'set evar(proc) pp2\n'
  data = data + 'set evar(name) ' + first + "\n";

  dload(data,'input.tcl');

  document.getElementById('idexec').click();
}
