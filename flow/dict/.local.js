
function add_new_word() {

  var name = document.getElementById("name").value;

  var data = "";
  data = data + 'exec new.tcl "' + name + '"\n'
  data = data + 'exec godel_draw.tcl\n'
  data = data + 'exec xdotool search --name "Mozilla" key ctrl+r\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();
}
function search_word() {

  var name = document.getElementById("name").value;

  var data = "";
  data = data + 'exec search.tcl "' + name + '"\n'
  data = data + 'exec godel_draw.tcl\n'
  data = data + 'exec xdotool search --name "Mozilla" key ctrl+r\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();
}

function clear_input () {
  var getValue = document.getElementById("name");
  getValue.value = "";
}




var rects = document.getElementsByClassName('hat');
if(typeof(rects) != 'undefined' && rects != null){
  for (var k = 0; k < rects.length; k++) {
  
        rects[k].addEventListener('click', function(){
          this.style.background = "lightyellow";
        })
  }
}

