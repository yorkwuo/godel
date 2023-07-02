function change_dir(dir, root) {

  var pp = root + dir;

  console.log(pp);

  var data = "";
  data += 'lsetvar . dirroot ' + pp + '\n'
  data += 'exec godel_draw.tcl\n'
  data += 'exec xdotool search --name "Mozilla" key ctrl+r\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();
}

// clear_input
function clear_input() {
  var dirroot   = document.getElementById("vt_dirroot");

  dirroot.innerHTML = "";
}
