
  const modal       = document.querySelector("[data-modal]")
  
  // Key binded to edit and draw
  document.onkeyup = function(e) {
  // Alt w
    if        (e.altKey && e.code == 'KeyW') {
      document.getElementById('iddraw').click();
  // Alt s
    } else if (e.altKey && e.code == 'KeyS') {
      document.getElementById('idbutton').click();
  // Alt l
    } else if (e.altKey && e.code == 'KeyL') {
      document.getElementById('idbutton').click();
      //flow1_click()
  // Ctrl 3
    } else if (e.ctrlKey && e.which == 51) {
      document.getElementById('idedit').click();
  // Ctrl F1
    } else if (e.ctrlKey && e.which == 112) {
      document.getElementById('idplay').click();
  // Alt [
    } else if (e.altKey && e.key === '[') {
      modal.showModal()
  // PAUSE
    } else if (e.code == 'Pause') { 
      //modal.showModal()
      location.reload()
  // SCRLK
    } else if (e.which === 145) { 
      document.getElementById('iddraw').click();
  // PRTSC
    } else if (e.which === 42) { 
      document.getElementById('idbutton').click();
  // Alt 3
  //  } else if (e.altKey && e.which == 51) {
  //    document.getElementById('idbutton').click();
  // Alt 1
  //  } else if (e.altKey && e.which == 49) {
  //    document.getElementById('idplay').click();
    }
  };
  
  
  modal.addEventListener("click", e => {
    const dialogDimensions = modal.getBoundingClientRect()
    if (
      e.clientX < dialogDimensions.left ||
      e.clientX > dialogDimensions.right ||
      e.clientY < dialogDimensions.top ||
      e.clientY > dialogDimensions.bottom
    ) {
      modal.close()
    }
  })

// Get the input field
var sinput = document.getElementById("sinput");
if (typeof(sinput) != 'undefined' && sinput != null) {
  sinput.addEventListener("keypress", function(event) {
    if (event.key === "Enter") {
      lsearch()
    }
  // Ctrl U
    if (event.ctrlKey && e.code == 'KeyU') {
      search_clear()
    }
  }); 
  sinput.focus()
}

var boxes = document.getElementsByClassName("mylink");
if (typeof(boxes) != 'undefined' && boxes != null) {

  function singleClickHandler() {
    var delay = 250; // Adjust the delay as needed
    var page = this.getAttribute('iname')

    clickCount++;
    setTimeout(function () {
      if (clickCount === 1) {
        window.location.href = page + '/.index.htm'
      }
      clickCount = 0;
    }, delay);
  }

  for (var k = 0; k < boxes.length; k++) {
    var clickCount = 0;

// single click
    boxes[k].addEventListener('click', singleClickHandler)

// double click
    boxes[k].addEventListener('dblclick', function(){
      this.removeEventListener('click', singleClickHandler);
      this.setAttribute('contenteditable','true')
      this.focus()
    })

  }
}

document.addEventListener("click", e => {
  const isDropdownButton = e.target.matches("[data-dropdown-button]")
  if (!isDropdownButton && e.target.closest("[data-dropdown]") != null) return

  let currentDropdown
  if (isDropdownButton) {
    currentDropdown = e.target.closest("[data-dropdown]")
    currentDropdown.classList.toggle("active")
  }

  document.querySelectorAll("[data-dropdown].active").forEach(dropdown => {
    if (dropdown === currentDropdown) return
    dropdown.classList.remove("active")
  })
})

var gbtns = document.getElementsByClassName("gbtn_onoff");
if (typeof(gbtns) != 'undefined' && gbtns != null) {
  for (var k = 0; k < gbtns.length; k++) {

      gbtns[k].addEventListener('click', function(){

        this.setAttribute("changed","1");
        var onoff = this.getAttribute('onoff');
        if (onoff === "1") {
          this.className = "gbtn_onoff w3-button w3-round w3-light-gray w3-small";
          this.setAttribute("onoff","0");
        } else {
          this.className = "gbtn_onoff w3-button w3-round w3-pale-blue w3-normal";
          this.setAttribute("onoff","1");
        }

      })
  }
}

// Add event to highlight midification in kvpvalue
const kvpvs = document.querySelectorAll("[data-kvpValue]")
if(typeof(kvpvs) != 'undefined' && kvpvs != null){
  kvpvs.forEach(kvpv => {
    kvpv.addEventListener('input', () => {
      kvpv.style.backgroundColor = "lightblue"
      kvpv.dataset.kvpvalue = '1'
    })
  })
}


// Add event to highlight modified cells in tables
//var tables = document.getElementsByTagName('table');
var tables = document.getElementsByClassName('table1');
if(typeof(tables) != 'undefined' && tables != null){
  for (var k = 0; k < tables.length; k++) {
  
      var cells = tables[k].getElementsByTagName('td');

      for (var i = 0; i < cells.length; i++) {
        cells[i].addEventListener('input', function(){
          var gname   = this.getAttribute("gname");
          this.setAttribute("changed","1");
          this.style.backgroundColor = "lightyellow";
        })
      }
      for (var i = 0; i < cells.length; i++) {
        var colname = cells[i].getAttribute("colname");
        var gclass  = cells[i].getAttribute("gclass");
        if (colname === "DEL") {
          cells[i].addEventListener('click', function(){
            this.style.backgroundColor = "gray";
            this.setAttribute("changed","1");
            this.setAttribute("onoff","1");
          })
        } else if (colname === "MOVE") {
          cells[i].addEventListener('click', function(){
            this.setAttribute("changed","1");
            var onoff   = this.getAttribute("onoff");
            if (onoff === "1") {
              this.setAttribute("bgcolor","lightblue")
              this.setAttribute("onoff","0");
              //this.innerText = "FD";
            } else {
              this.setAttribute("bgcolor","yellow")
              this.setAttribute("onoff","1");
              //this.innerText = 1;
            }
          })
        } else if (colname === "fdel") {
          cells[i].addEventListener('click', function(){
            this.setAttribute("changed","1");
            var onoff   = this.getAttribute("onoff");
            if (onoff === "1") {
              this.setAttribute("bgcolor","lightblue")
              this.setAttribute("onoff","0");
              //this.innerText = "FD";
            } else {
              this.setAttribute("bgcolor","gray")
              this.setAttribute("onoff","1");
              //this.innerText = 1;
            }
          })
        } else if (gclass === "onoff") {
          cells[i].addEventListener('click', function(){
            this.setAttribute("changed","1");
            var onoff   = this.getAttribute("onoff");
            if (onoff === "1") {
              this.setAttribute("bgcolor","")
              this.setAttribute("onoff","0");
              this.innerText = "";
            } else {
              this.setAttribute("bgcolor","lightblue")
              this.setAttribute("onoff","1");
              this.innerText = 1;
            }
          })
        } else if (colname === "tick") {
          cells[i].addEventListener('click', function(){
            this.setAttribute("changed","1");
            var onoff   = this.getAttribute("onoff");
            if (onoff === "1") {
              this.setAttribute("bgcolor","")
              this.setAttribute("onoff","0");
              this.innerText = "";
            } else {
              this.setAttribute("bgcolor","lightgreen")
              this.setAttribute("onoff","1");
              this.innerText = 1;
            }
          })
        } else if (colname === "ctitle") {
          cells[i].addEventListener('click', function(){
            this.setAttribute("changed","1");
            var onoff   = this.getAttribute("onoff");
            if (onoff === "1") {
              this.setAttribute("bgcolor","")
              this.setAttribute("onoff","0");
              this.innerText = "";
            } else {
              this.setAttribute("bgcolor","pink")
              this.setAttribute("onoff","1");
              this.innerText = 1;
            }
          })
        } else if (colname === "star") {
          cells[i].addEventListener('click', function(){
            this.setAttribute("changed","1");
            var onoff   = this.getAttribute("onoff");
            if (onoff === "1") {
              this.setAttribute("bgcolor","")
              this.setAttribute("onoff","0");
              this.innerText = "";
            } else {
              this.setAttribute("bgcolor","yellow")
              this.setAttribute("onoff","1");
              this.innerText = 1;
            }
          })
        } else if (colname === "num") {
          cells[i].addEventListener('click', function(){
            var gname   = this.getAttribute("gname");
            window.location = gname + "/.index.htm"
          })
        } else {
          cells[i].addEventListener('click', function(){
            this.style.backgroundColor = "lightyellow";
          })
        }
      }
  }
}






// topFunction
// {{{
function topFunction() {
  document.body.scrollTop = 0;
  document.documentElement.scrollTop = 0;
}
// }}}
// TableColSelect
// {{{
function TableColSelect (thisobj, iarray) {

  var selected = thisobj.getAttribute("selected");

  if (selected == 1) {
    selected = 0;
    thisobj.setAttribute("selected","0");
  } else {
    selected = 1;
    thisobj.setAttribute("selected","1");
  }

  var table = document.getElementById('tbl');

  if (selected == 1) {
    thisobj.classList.add("w3-red");
    var cells = table.getElementsByTagName('th');
    for (var i = 0; i < cells.length; i++) {
      var colname = cells[i].getAttribute("colname");
      for (let x of iarray) {
        if (colname === x) {
          cells[i].style.display = "";
        }
      }
    }
    var cells = table.getElementsByTagName('td');
    for (var i = 0; i < cells.length; i++) {
      var colname = cells[i].getAttribute("colname");
      for (let x of iarray) {
        if (colname === x) {
          cells[i].style.display = "";
        }
      }
    }
  } else {
    thisobj.classList.remove("w3-red");
    var cells = table.getElementsByTagName('th');
    for (var i = 0; i < cells.length; i++) {
      var colname = cells[i].getAttribute("colname");
      for (let x of iarray) {
        if (colname === x) {
          cells[i].style.display = "none";
        }
      }
    }
    var cells = table.getElementsByTagName('td');
    for (var i = 0; i < cells.length; i++) {
      var colname = cells[i].getAttribute("colname");
      for (let x of iarray) {
        if (colname === x) {
          cells[i].style.display = "none";
        }
      }
    }
  }
}
// }}}
// TableColDisp
// {{{
function TableColDisp (thisobj, person) {
   
  var atags = document.getElementsByClassName('coldisp');
  for (var i = 0; i < atags.length; i++) {
    atags[i].classList.remove("w3-red");
  }

  thisobj.classList.add("w3-red");
  
  var table = document.getElementById('tbl');
  
  var cells = table.getElementsByTagName('th');
  for (var i = 0; i < cells.length; i++) {
    cells[i].style.display = "none";
  }
  var cells = table.getElementsByTagName('td');
  for (var i = 0; i < cells.length; i++) {
    cells[i].style.display = "none";
  }

  var cells = table.getElementsByTagName('th');
  for (var i = 0; i < cells.length; i++) {
    var colname = cells[i].getAttribute("colname");
    for (let x of person) {
      if (colname === x) {
        cells[i].style.display = "";
      }
    }
  }
  
  var cells = table.getElementsByTagName('td');
  for (var i = 0; i < cells.length; i++) {
    var colname = cells[i].getAttribute("colname");
    for (let x of person) {
      if (colname === x) {
        cells[i].style.display = "";
      }
    }
  }
}
// }}}
// TableColInit
// {{{
function TableColInit (dispcol) {
   
  var table = document.getElementById('tbl');
  
  var cells = table.getElementsByTagName('th');
  for (var i = 0; i < cells.length; i++) {
    cells[i].style.display = "none";
  }
  var cells = table.getElementsByTagName('td');
  for (var i = 0; i < cells.length; i++) {
    cells[i].style.display = "none";
  }

  var cells = table.getElementsByTagName('th');
  for (var i = 0; i < cells.length; i++) {
    var colname = cells[i].getAttribute("colname");
    for (let x of dispcol) {
      if (colname === x) {
        cells[i].style.display = "";
      }
    }
  }
  
  var cells = table.getElementsByTagName('td');
  for (var i = 0; i < cells.length; i++) {
    var colname = cells[i].getAttribute("colname");
    for (let x of dispcol) {
      if (colname === x) {
        cells[i].style.display = "";
      }
    }
  }
}
// }}}
// inst
// {{{
function inst(value) {
// Save
    //var data =   "." + "|#|" +  key + "|#|" +  value + "|E|\n";
    var data =  value;
    const textToBLOB = new Blob([data], { type: 'text/plain' });
    const sFileName = 'gtcl.tcl';	   // The file to save the data.

    var newLink = document.createElement("a");
    newLink.download = sFileName;

    if (window.webkitURL != null) {
        newLink.href = window.webkitURL.createObjectURL(textToBLOB);
    }
    else {
        newLink.href = window.URL.createObjectURL(textToBLOB);
        newLink.style.display = "none";
        document.body.appendChild(newLink);
    }

    newLink.click(); 


}
// }}}
// JQuery: save table as CSV
// {{{
$(document).ready(function(){
  var $TABLE = $('#tbl');

  $('#csv_button').click(function () {

    //var $rows = $TABLE.find('tr');
    var $rows = $('#tbl').find('tr');

    var cmds = "";

    // foreach row
    $rows.each(function () {
      //var value = $(this).text();
      //  //var cmd = "\"" + value + "\",";
      //  var cmd = value;
      //  cmds = cmds + cmd;
      var $td = $(this).find('td');
      //console.log($td.length)
      if ($td.length == 0) {
        var $td = $(this).find('th');
      }
      // foreach td
      $td.each(function () {
        var value   = $(this).text();
        var cmd = "\"" + value + "\",";
        cmds = cmds + cmd;
      });

      cmds = cmds + "\n";
    });

// Save
    var data = cmds;
    const textToBLOB = new Blob([data], { type: 'text/plain' });
    const sFileName = 'table.csv';	   // The file to save the data.

    var newLink = document.createElement("a");
    newLink.download = sFileName;

    if (window.webkitURL != null) {
        newLink.href = window.webkitURL.createObjectURL(textToBLOB);
    }
    else {
        newLink.href = window.URL.createObjectURL(textToBLOB);
        newLink.style.display = "none";
        document.body.appendChild(newLink);
    }

    newLink.click(); 

  });


});
// }}}
// word_highlight
// {{{
function word_highlight (target_words) {
  var x = document.getElementsByTagName("p");

  for (i = 0; i < x.length; i++) {
    var tmptext = x[i].innerHTML;

    for (n=0; n < target_words.length; n++) {
      var regpat  = new RegExp((target_words[n]), "g");
      tmptext = tmptext.replace(
        regpat, "<span style=background-color:yellow>\$&</span>"
      );
    }

    x[i].innerHTML = tmptext;
  }
}
// }}}
// filter_toc
// {{{
function filter_toc() {
  var input, filter, i;

// Get input value
  input = document.getElementById("filter_input");
  filter = input.value;

// Get all a href
  var aa = document.querySelectorAll("a");
  for (i = 0; i < aa.length; i++) {
    // Display only if you can find id matches filter
    if (aa[i].id.indexOf(filter) > -1) {
      aa[i].style.display = "";
    } else {
      aa[i].style.display = "none";
    }
  }
}
// }}}
// filter_ghtmls
// {{{
function filter_ghtmls(e) {
  var input = document.getElementById("filter_input");
  filter = input.value.toUpperCase();

  if(e.keyCode === 13){
    e.preventDefault(); // Ensure it is only this code that rusn

    filter = filter.split(" ");
    var x = document.getElementsByClassName("ghtmls");

// foreach ghtmls
    for (i = 0; i < x.length; i++) {
      //console.log(x[i].innerHTML);
      y = x[i].getElementsByClassName("keywords");
      if (y[0]) {
        var found = 1
        for (j = 0; j < filter.length; j++) {
          //console.log("kk",filter[j])
          if (y[0].innerHTML.toUpperCase().indexOf(filter[j]) > -1) {
            found = found && 1
          } else {
            found = found && 0
          }
        }
        if (found) {
          //console.log(y[0].innerHTML);
          x[i].style.display = "";
        } else {
          x[i].style.display = "none";
        }
      }
    }
  }
}
// }}}
// filter_gnotes
// {{{
function filter_gnotes(e) {
  var input = document.getElementById("filter_input");
  filter = input.value.toUpperCase();

  if(e.keyCode === 13){
    e.preventDefault(); // Ensure it is only this code that rusn

    filter = filter.split(" ");
    var x = document.getElementsByClassName("gnotes");

// foreach gnotes
    for (i = 0; i < x.length; i++) {
      //console.log(x[i].innerHTML);
      y = x[i].getElementsByClassName("keywords");
      if (y[0]) {
        var found = 1
        for (j = 0; j < filter.length; j++) {
          //console.log("kk",filter[j])
          if (y[0].innerHTML.toUpperCase().indexOf(filter[j]) > -1) {
            found = found && 1
          } else {
            found = found && 0
          }
        }
        if (found) {
          //console.log(y[0].innerHTML);
          x[i].style.display = "";
        } else {
          x[i].style.display = "none";
        }
      }
    }
  }
}
// }}}
// filter_table
// {{{
function filter_table(tname, column_no, e) {
  var input, filter, table, tr, td, i;

  input = document.getElementById("filter_table_input");
  filter = input.value.toUpperCase();

  if(e.keyCode === 13){
    e.preventDefault(); // Ensure it is only this code that rusn

    filter = filter.split(" ");
    //alert("kkk");

    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[column_no];
      if (td) {
        var found = 1
        for (j = 0; j < filter.length; j++) {
          if (td.innerHTML.toUpperCase().indexOf(filter[j]) > -1) {
            found = found && 1;
          } else {
            found = found && 0;
          }
        }
        if (found) {
            tr[i].style.display = "";
        } else {
            tr[i].style.display = "none";
        }
          //} else {
          //}
      }       
    }
  }
}
// }}}
// set_value
// {{{
function set_value(key, value) {
// Save
    var data =   "g." + "|#|" +  key + "|#|" +  value + "|E|\n";
    const textToBLOB = new Blob([data], { type: 'text/plain' });
    const sFileName = 'gtcl.tcl';	   // The file to save the data.

    var newLink = document.createElement("a");
    newLink.download = sFileName;

    if (window.webkitURL != null) {
        newLink.href = window.webkitURL.createObjectURL(textToBLOB);
    }
    else {
        newLink.href = window.URL.createObjectURL(textToBLOB);
        newLink.style.display = "none";
        document.body.appendChild(newLink);
    }

    newLink.click(); 
    document.getElementById('iddraw').click();


}
// }}}
// onoff
// {{{
function onoff(key, value) {
// Save
    var data =   "g." + "|#|" +  key + "|#|" +  value + "|E|\n";
    const textToBLOB = new Blob([data], { type: 'text/plain' });
    const sFileName = 'gtcl.tcl';	   // The file to save the data.

    var newLink = document.createElement("a");
    newLink.download = sFileName;

    if (window.webkitURL != null) {
        newLink.href = window.webkitURL.createObjectURL(textToBLOB);
    }
    else {
        newLink.href = window.URL.createObjectURL(textToBLOB);
        newLink.style.display = "none";
        document.body.appendChild(newLink);
    }

    newLink.click(); 
    document.getElementById('iddraw').click();


}
// }}}
// filter_table_reset
// {{{
function filter_table_reset(tname) {
    table = document.getElementById('tbl');
    tr = table.getElementsByTagName("tr");

    for (i = 0; i < tr.length; i++) {
      tr[i].style.display = "";
    }
}
// }}}
// filter_table_keyword
// {{{
function filter_table_keyword(tname, colname, input, exact) {
    var input, filter, table, tr, td, i;

    var filter = input;
    var patt  = new RegExp(filter, "i");

    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

    th = tr[0].getElementsByTagName("th");
    for (i = 0; i < th.length; i++) {
      txt = th[i].innerHTML;
      txt = txt.trim();
      if (colname === txt) {
        column_no = i;   
      }
    }

    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[column_no];
      if (td) {
        var found = 1
// exact
        if (exact === "1") {
          origtd = td.innerHTML;
          tdvalue = origtd.replace(/(<([^>]+)>)/gi, "");
          if (tdvalue === input) {
            found = found && 1;
          } else {
            found = found && 0;
          }
// no exact
        } else {
          if (patt.test(td.innerHTML)) {
            found = found && 1;
          } else {
            found = found && 0;
          }
        }
        if (found) {
            tr[i].style.display = "";
        } else {
            tr[i].style.display = "none";
        }
      }       
    }

}
// }}}
// hide_table_rows
// {{{
function hide_table_rows(tname, colname, input, exact) {
    var input, filter, table, tr, td, i;

    var filter = input;
    var patt  = new RegExp(filter, "i");

    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

    th = tr[0].getElementsByTagName("th");
    for (i = 0; i < th.length; i++) {
      txt = th[i].innerHTML;
      txt = txt.trim();
      if (colname === txt) {
        column_no = i;   
      }
    }

    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[column_no];
      if (td) {
        var found = 1
// exact
        if (exact === "1") {
          origtd = td.innerHTML;
          tdvalue = origtd.replace(/(<([^>]+)>)/gi, "");
          if (tdvalue === input) {
            found = found && 1;
          } else {
            found = found && 0;
          }
// no exact
        } else {
          if (patt.test(td.innerHTML)) {
            found = found && 1;
          } else {
            found = found && 0;
          }
        }
        if (found) {
            tr[i].style.display = "none";
        } else {
            //tr[i].style.display = "";
        }
      }       
    }

}
// }}}
// select_table_rows
// {{{
function select_table_rows(tname, colname, input, exact) {
    var input, filter, table, tr, td, i;

    var filter = input;
    var patt  = new RegExp(filter, "i");

    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

    th = tr[0].getElementsByTagName("th");
    for (i = 0; i < th.length; i++) {
      txt = th[i].innerHTML;
      txt = txt.trim();
      if (colname === txt) {
        column_no = i;   
      }
    }

    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[column_no];
      if (td) {
        var found = 1
// exact
        if (exact === "1") {
          origtd = td.innerHTML;
          tdvalue = origtd.replace(/(<([^>]+)>)/gi, "");
          if (tdvalue === input) {
            found = found && 1;
          } else {
            found = found && 0;
          }
// no exact
        } else {
          if (patt.test(td.innerHTML)) {
            found = found && 1;
          } else {
            found = found && 0;
          }
        }
        if (found) {
            //tr[i].style.display = "none";
            tr[i].style.display = "";
        } else {
        }
      }       
    }

}
// }}}
// table_row_count
// {{{
function table_row_count(id, tid) {

  table = document.getElementById(tid);
  tr = table.getElementsByTagName("tr");
  
  var count = 0
  for (i = 1; i < tr.length; i++) {
    if (tr[i].style.display === "") {
      count++
    }
  }
  document.getElementById(id).innerHTML = count;

}
// }}}
// filter_table_keyword_incr
// {{{
function filter_table_keyword_incr(tname, colname, input, exact) {
    var input, filter, table, tr, td, i;

    var filter = input;
    var patt  = new RegExp(filter, "i");

    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

    th = tr[0].getElementsByTagName("th");
    for (i = 0; i < th.length; i++) {
      txt = th[i].innerHTML;
      txt = txt.trim();
      if (colname === txt) {
        column_no = i;   
      }
    }

    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[column_no];
      display = tr[i].style.display;
      if (display === "none") {continue}
      if (td) {
        var found = 1
// exact
        if (exact === "1") {
          origtd = td.innerHTML;
          tdvalue = origtd.replace(/(<([^>]+)>)/gi, "");
          if (tdvalue === input) {
            found = found && 1;
          } else {
            found = found && 0;
          }
// no exact
        } else {
          if (patt.test(td.innerHTML)) {
            found = found && 1;
          } else {
            found = found && 0;
          }
        }
        if (found) {
            tr[i].style.display = "";
        } else {
            tr[i].style.display = "none";
        }
      }       
    }
  //}
}
// }}}
// chklist_examine
// {{{
function chklist_examine() {
  var chkitems = document.getElementsByTagName('input');
  var disp = "";
  for (var i = 0; i < chkitems.length; i++) {
      if (chkitems[i].type === 'radio' && chkitems[i].checked) {
          disp = disp + "chklist-set " + chkitems[i].name + " " + chkitems[i].value + "\n";
      } else if (chkitems[i].type === 'text') {
          disp = disp + "chklist-set " + chkitems[i].name + " " + "\"" + chkitems[i].value + "\"" + "\n";
      }
  }

  // redraw the page
  disp = disp + "gd\r";
  // paste the text to 
  document.getElementById("text_board").value =  disp

  /* Get the text field */
  var copyText = document.getElementById("text_board");

  document.getElementById("text_board").style.display = "inline"
  /* Select the text field */
  copyText.select();

  /* Copy the text inside the text field */
  document.execCommand("Copy");

  document.getElementById("text_board").style.display = "none"
  /* Alert the copied text */
  alert("Copied the text: \n" + copyText.value);
}
// }}}
// at_save
// {{{
function at_save(atfname) {
    //var $rows = $TABLE.find('tr');
    var $rows = $('table').find('tr');

    var cmds = "";
    // foreach row
    $rows.each(function () {
      //var $td = $(this).find('td');
      var $td = $(this).find('td');
      // foreach td
      $td.each(function () {
        var gtype   = $(this).attr('gtype');
        var value = "";
        if (gtype == 'innerHTML') {
          value   = $(this).prop("innerHTML");
        } else {
          value   = $(this).prop("innerText");
        }
        var gname   = $(this).attr('gname');
        var colname = $(this).attr('colname');
        var changed = $(this).attr('changed');
        //console.log(value);
        //console.log(this);
        if (typeof gname === 'undefined') {
          return; // equal to continue
        } else {
          if (changed) {
            if (colname == "chkbox") {
              var n = 'cb_' + gname;
              var v = document.getElementById(n).checked;
              if (v) {
                var cmd = "exec rm -rf " + gname + "\n";
                cmds = cmds + cmd;
                document.getElementById(n).checked = false;
                $(this).attr('changed', false);
              }
            } else {

              gname = gname.replace(/\[/,'\\\[')
              gname = gname.replace(/\s/g,'\\ ')
              value = value.replace(/\[/g,'\\\[')

              if (value.length == '1') {
                if (value == "") {
                  var cmd = "set atvar("+gname+","+colname+") "+ '""' + "\n";
                } else {
                  value = value.replace(/\n$/,'');
                  var cmd = "set atvar("+gname+","+colname+") "+'"'+value+"\"\n";
                }
              } else {
                value = value.replace(/\s/g,'\\ ')
                value = value.replace(/\n$/,'');
                var cmd = "set atvar("+gname+","+colname+") "+'"'+value+"\"\n";
              }

              cmds = cmds + cmd;
            }
            $(this).css('backgroundColor', "");
          }

        }
      });
    });

    var header = "#!/usr/bin/tclsh\n";
    header = header + "source $env(GODEL_ROOT)/bin/godel.tcl\n";
    header = header + "source " + atfname + "\n";
    var footer = "godel_array_save atvar " + atfname + "\n";

    var data = header + cmds + footer;
    document.getElementById('result').innerHTML = data;
    //console.log(data);

// Save gtcl.tcl
    var data = header + cmds + footer;
    const textToBLOB = new Blob([data], { type: 'text/plain' });
    const sFileName = 'gtcl.tcl';	   // The file to save the data.

    var newLink = document.createElement("a");
    newLink.download = sFileName;

    if (window.webkitURL != null) {
        newLink.href = window.webkitURL.createObjectURL(textToBLOB);
    }
    else {
        newLink.href = window.URL.createObjectURL(textToBLOB);
        newLink.style.display = "none";
        document.body.appendChild(newLink);
    }

    newLink.click(); 

// Save ginst.tcl
    var data = 'source $env(GODEL_DOWNLOAD)/gtcl.tcl';
    const textToBLOB2 = new Blob([data], { type: 'text/plain' });
    const sFileName2 = 'ginst.tcl';	   // The file to save the data.

    var newLink2 = document.createElement("a");
    newLink2.download = sFileName2;

    if (window.webkitURL != null) {
        newLink2.href = window.webkitURL.createObjectURL(textToBLOB2);
    }
    else {
        newLink2.href = window.URL.createObjectURL(textToBLOB2);
        newLink2.style.display = "none";
        document.body.appendChild(newLink2);
    }

    newLink2.click(); 

//    document.getElementById('iddraw').click();

}
// }}}
// at_mpv
// {{{
function at_mpv (atfname,id) {

    var header = "#!/usr/bin/tclsh\n";
    header = header + "source $env(GODEL_ROOT)/bin/godel.tcl\n";
    header = header + "source " + atfname + "\n";

    //var footer = "godel_array_save atvar " + atfname + "\n";
    var footer = "";
    footer = footer + "if [info exist atvar(" + id + ",Vs)] {\n";
    footer = footer + "  incr atvar(" + id + ",Vs)\n";
    footer = footer + "} else {\n";
    footer = footer + "  set atvar(" + id + ",Vs) 1\n";
    footer = footer + "}\n";
    footer = footer + "set atvar(" + id + ",last) [clock format [clock seconds] -format {%Y-%m-%d}]\n";
    footer = footer + "catch {exec mpv $atvar(" + id + ",path) &}\n";
    footer = footer + "godel_array_save atvar " + atfname + "\n";
    //var footer = "catch {exec mpv /home/york/downloads/test.webm &}\n";

// Save gtcl.tcl
    //var data = header + cmds + footer;
    var data = header + footer;
    const textToBLOB = new Blob([data], { type: 'text/plain' });
    const sFileName = 'gtcl.tcl';	   // The file to save the data.

    var newLink = document.createElement("a");
    newLink.download = sFileName;

    if (window.webkitURL != null) {
        newLink.href = window.webkitURL.createObjectURL(textToBLOB);
    }
    else {
        newLink.href = window.URL.createObjectURL(textToBLOB);
        newLink.style.display = "none";
        document.body.appendChild(newLink);
    }

    newLink.click(); 

// Save ginst.tcl
    var data = 'source $env(GODEL_DOWNLOAD)/gtcl.tcl';
    const textToBLOB2 = new Blob([data], { type: 'text/plain' });
    const sFileName2 = 'ginst.tcl';	   // The file to save the data.

    var newLink2 = document.createElement("a");
    newLink2.download = sFileName2;

    if (window.webkitURL != null) {
        newLink2.href = window.webkitURL.createObjectURL(textToBLOB2);
    }
    else {
        newLink2.href = window.URL.createObjectURL(textToBLOB2);
        newLink2.style.display = "none";
        document.body.appendChild(newLink2);
    }

    newLink2.click(); 

    document.getElementById('iddraw').click();
}
// }}}
// at_delete
// {{{
function at_delete (atfname,id) {

    var header = "#!/usr/bin/tclsh\n";
    header = header + "source $env(GODEL_ROOT)/bin/godel.tcl\n";
    header = header + "source " + atfname + "\n";

    //var footer = "godel_array_save atvar " + atfname + "\n";
    var footer = "array unset atvar " + id + ",*\n";
    footer = footer + "godel_array_save atvar " + atfname + "\n";
    //var footer = "catch {exec mpv /home/york/downloads/test.webm &}\n";

// Save gtcl.tcl
    //var data = header + cmds + footer;
    var data = header + footer;
    const textToBLOB = new Blob([data], { type: 'text/plain' });
    const sFileName = 'gtcl.tcl';	   // The file to save the data.

    var newLink = document.createElement("a");
    newLink.download = sFileName;

    if (window.webkitURL != null) {
        newLink.href = window.webkitURL.createObjectURL(textToBLOB);
    }
    else {
        newLink.href = window.URL.createObjectURL(textToBLOB);
        newLink.style.display = "none";
        document.body.appendChild(newLink);
    }

    newLink.click(); 

// Save ginst.tcl
    var data = 'source $env(GODEL_DOWNLOAD)/gtcl.tcl';
    const textToBLOB2 = new Blob([data], { type: 'text/plain' });
    const sFileName2 = 'ginst.tcl';	   // The file to save the data.

    var newLink2 = document.createElement("a");
    newLink2.download = sFileName2;

    if (window.webkitURL != null) {
        newLink2.href = window.webkitURL.createObjectURL(textToBLOB2);
    }
    else {
        newLink2.href = window.URL.createObjectURL(textToBLOB2);
        newLink2.style.display = "none";
        document.body.appendChild(newLink2);
    }

    newLink2.click(); 

    document.getElementById('iddraw').click();
}
// }}}
// at_fdel
// {{{
function at_fdel (atfname,id) {

    var header = "#!/usr/bin/tclsh\n";
    header = header + "source $env(GODEL_ROOT)/bin/godel.tcl\n";
    header = header + "source " + atfname + "\n";

    id = id.replace(/\s/g,'\\ ');
    id = id.replace(/\(/g,'\\\(');
    id = id.replace(/\)/g,'\\\)');

    var footer = "";
    footer = footer + "catch {exec rm $atvar(" + id + ",path) &}\n";
    footer = footer + "set atvar(" + id + ",fdel) 1\n";
    footer = footer + "godel_array_save atvar " + atfname + "\n";
    //var footer = "catch {exec mpv /home/york/downloads/test.webm &}\n";

// Save gtcl.tcl
    //var data = header + cmds + footer;
    var data = header + footer;
    const textToBLOB = new Blob([data], { type: 'text/plain' });
    const sFileName = 'gtcl.tcl';	   // The file to save the data.

    var newLink = document.createElement("a");
    newLink.download = sFileName;

    if (window.webkitURL != null) {
        newLink.href = window.webkitURL.createObjectURL(textToBLOB);
    }
    else {
        newLink.href = window.URL.createObjectURL(textToBLOB);
        newLink.style.display = "none";
        document.body.appendChild(newLink);
    }

    newLink.click(); 

// Save ginst.tcl
    var data = 'source $env(GODEL_DOWNLOAD)/gtcl.tcl';
    const textToBLOB2 = new Blob([data], { type: 'text/plain' });
    const sFileName2 = 'ginst.tcl';	   // The file to save the data.

    var newLink2 = document.createElement("a");
    newLink2.download = sFileName2;

    if (window.webkitURL != null) {
        newLink2.href = window.webkitURL.createObjectURL(textToBLOB2);
    }
    else {
        newLink2.href = window.URL.createObjectURL(textToBLOB2);
        newLink2.style.display = "none";
        document.body.appendChild(newLink2);
    }

    newLink2.click(); 

    document.getElementById('iddraw').click();
}
// }}}
// at_remote_open
// {{{
function at_remote_open (atfname,id) {

    var header = "#!/usr/bin/tclsh\n";
    header = header + "source $env(GODEL_ROOT)/bin/godel.tcl\n";
    header = header + "source " + atfname + "\n";

    id = id.replace(/&/g,'\\\&');
    id = id.replace(/'/g,'\\\'');
    id = id.replace(/\s/g,'\\ ');
    id = id.replace(/\(/g,'\\\(');
    id = id.replace(/\)/g,'\\\)');
    id = id.replace(/\[/g,'\\\[');
    id = id.replace(/\]/g,'\\\]');

    //console.log(id);

    //var footer = "godel_array_save atvar " + atfname + "\n";
    var footer = "";
    footer = footer + "if [info exist atvar(" + id + ",Vs)] {\n";
    footer = footer + "  incr atvar(" + id + ",Vs)\n";
    footer = footer + "} else {\n";
    footer = footer + "  set atvar(" + id + ",Vs) 1\n";
    footer = footer + "}\n";
    footer = footer + "set atvar(" + id + ",last) [clock format [clock seconds] -format {%Y-%m-%d}]\n";
    footer = footer + "set dirroot [lvars . dirroot]\n"
    footer = footer + "openfile \$dirroot/$atvar(" + id + ",path)\n";
    footer = footer + "godel_array_save atvar " + atfname + "\n";

// Save gtcl.tcl
    var data = header + footer;
    dload(data,'gtcl.tcl');

    document.getElementById('idexec').click();
}
// }}}
// at_open
// {{{
function at_open (atfname,id) {

    var header = "#!/usr/bin/tclsh\n";
    header = header + "source $env(GODEL_ROOT)/bin/godel.tcl\n";
    header = header + "source " + atfname + "\n";

    id = id.replace(/&/g,'\\\&');
    id = id.replace(/'/g,'\\\'');
    id = id.replace(/\s/g,'\\ ');
    id = id.replace(/\(/g,'\\\(');
    id = id.replace(/\)/g,'\\\)');
    id = id.replace(/\[/g,'\\\[');
    id = id.replace(/\]/g,'\\\]');

    //console.log(id);

    //var footer = "godel_array_save atvar " + atfname + "\n";
    var footer = "";
    footer = footer + "if [info exist atvar(" + id + ",Vs)] {\n";
    footer = footer + "  incr atvar(" + id + ",Vs)\n";
    footer = footer + "} else {\n";
    footer = footer + "  set atvar(" + id + ",Vs) 1\n";
    footer = footer + "}\n";
    footer = footer + "set atvar(" + id + ",last) [clock format [clock seconds] -format {%Y-%m-%d}]\n";
    //footer = footer + "catch {exec " + exe + " $atvar(" + id + ",path) &}\n";
    footer = footer + "openfile $atvar(" + id + ",path)\n";
    footer = footer + "godel_array_save atvar " + atfname + "\n";

// Save gtcl.tcl
    var data = header + footer;
    dload(data,'gtcl.tcl');

    document.getElementById('idexec').click();
//setTimeout(function() {
//    // Code to execute after 1 second
//    //console.log("1 second has passed");
//    document.getElementById('idexec').click();
//}, 600);

}
// }}}
// openfile
// {{{
function openfile (pp) {
  console.log(pp)
  const url = 'http://127.0.0.1:5000/openfile?filepath='+pp;

  fetch(url)
  .catch(err => console.log(err))

}
// }}}
// openfile_row
// {{{
function openfile_row (row,key) {
  var data = "";
  data += "source $env(GODEL_ROOT)/bin/godel.tcl\n";
  data += 'openbook ' + '"' + row + '"' + ' "' + key + '"' + '\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();
}
// }}}
// chrome_open
// {{{
function chrome_open (link) {

    var header = "#!/usr/bin/tclsh\n";
    header = header + "source $env(GODEL_ROOT)/bin/godel.tcl\n";

    var footer = "";
    footer = footer + "openfile " + link + "\n";

// Save gtcl.tcl
    var data = header + footer;
    const textToBLOB = new Blob([data], { type: 'text/plain' });
    const sFileName = 'gtcl.tcl';	   // The file to save the data.

    var newLink = document.createElement("a");
    newLink.download = sFileName;

    if (window.webkitURL != null) {
        newLink.href = window.webkitURL.createObjectURL(textToBLOB);
    }
    else {
        newLink.href = window.URL.createObjectURL(textToBLOB);
        newLink.style.display = "none";
        document.body.appendChild(newLink);
    }

    newLink.click(); 

// Save ginst.tcl
    var data = 'source $env(GODEL_DOWNLOAD)/gtcl.tcl';
    const textToBLOB2 = new Blob([data], { type: 'text/plain' });
    const sFileName2 = 'ginst.tcl';	   // The file to save the data.

    var newLink2 = document.createElement("a");
    newLink2.download = sFileName2;

    if (window.webkitURL != null) {
        newLink2.href = window.webkitURL.createObjectURL(textToBLOB2);
    }
    else {
        newLink2.href = window.URL.createObjectURL(textToBLOB2);
        newLink2.style.display = "none";
        document.body.appendChild(newLink2);
    }

    newLink2.click(); 

    document.getElementById('iddraw').click();
}
// }}}
// save_gtable
// {{{
function save_gtable(tableobj) {
  //console.log("gtabe");
  var cells = tableobj.getElementsByTagName('td');

  var cmds = "";
  for (var i = 0; i < cells.length; i++) {
    var value   = cells[i].innerText
    var gname   = cells[i].getAttribute("gname");
    var colname = cells[i].getAttribute("colname");
    var changed = cells[i].getAttribute("changed");
    var onoff   = cells[i].getAttribute("onoff");
    var gclass  = cells[i].getAttribute("gclass");

    if (typeof gname === 'undefined') {
      return; // equal to continue
    } else {
        if (changed) {
          if (typeof gname === 'undefined') {
            return; // equal to continue
          } else {
            if (colname === 'MOVE') {
              var target  = cells[i].getAttribute("target");
              var cmd =  "g" + gname + "|#|" +  colname + "|#|" + target + "|E|\n";
              cmds = cmds + cmd;
            } else {
              if (gclass === "onoff") {
                var cmd =  "g" + gname + "|#|" +  colname + "|#|" + onoff + "|E|\n";
                cmds = cmds + cmd;
              } else {
                var cmd =  "g" + gname + "|#|" +  colname + "|#|" + value + "|E|\n";
                cmds = cmds + cmd;
              }
              cells[i].style.backgroundColor = "";
            }
          }
        }
    }
  }
  return cmds;
}
// }}}
// save_atable
// {{{
function save_atable(tableobj) {

  var atfname        = tableobj.getAttribute('atfname');
  var static_atfname = tableobj.getAttribute('static_atfname');
  var static_cols    = tableobj.getAttribute('static_cols');

  var cells = tableobj.getElementsByTagName('td');

  var cmds = "";
  for (var i = 0; i < cells.length; i++) {
    var value   = cells[i].innerText
    var gname   = cells[i].getAttribute("gname");
    var colname = cells[i].getAttribute("colname");
    var changed = cells[i].getAttribute("changed");
    var onoff   = cells[i].getAttribute("onoff");
    var gclass  = cells[i].getAttribute("gclass");

    if (typeof gname === 'undefined') {
      return; // equal to continue
    } else {
        if (changed) {
          if (gclass == "onoff") {
            var cmd =  "a" + gname + "|#|" +  colname + "|#|" + onoff + "|#|" + atfname + "|E|\n";
            cmds = cmds + cmd;
          } else {
            if (new RegExp(colname).test(static_cols)) {
              var cmd =   "a" + gname + "|#|" +  colname + "|#|" +  value + "|#|" + static_atfname + "|E|\n";
            } else {
              var cmd =   "a" + gname + "|#|" +  colname + "|#|" +  value + "|#|" + atfname + "|E|\n";
            }
            cmds = cmds + cmd;
          }
          cells[i].style.backgroundColor = "";
        }
    }
  }
  return cmds;
}
// }}}
// g_save
// {{{
function g_save() {
  // Tables
  var tables = document.getElementsByTagName('table');

  var cmds = "";

  for (var k = 0; k < tables.length; k++) {
    var tbltype = tables[k].getAttribute('tbltype');

    if (tbltype === "atable") {
      cmds = cmds + save_atable(tables[k]);
    } else if (tbltype === 'gtable') {
      cmds = cmds + save_gtable(tables[k]);
    } else if (tbltype === 'stable') {
      console.log('stable...')
    }
  }
  // KVP(Key-Value Pair)
  var kvpvs = document.querySelectorAll("[data-kvpValue]")
  if(typeof(kvpvs) != 'undefined' && kvpvs != null){
    kvpvs.forEach(kvpv => {
      var modi  = kvpv.dataset.kvpvalue
      var key   = kvpv.dataset.kvpkey
      var value = kvpv.innerText
      if (modi === '1') {
        var cmd =  "g" + '.' + "|#|" +  key + "|#|" + value + "|E|\n";
        cmds = cmds + cmd;
      }
    })
  }

  var data = cmds;
  
  data = data + save_gbtn_onoff();

  dload(data,'gtcl.tcl');

  //document.getElementById('iddraw').click();
  setTimeout(function() {
      // Code to execute after 1 second
      //console.log("1 second has passed");
      document.getElementById('iddraw').click();
  }, 600);

}
// }}}
// toolarea
// {{{
function toolarea() {
  var value = document.getElementById("toolarea").style.display;

  if (value === "none") {
    document.getElementById("toolarea").style.display = "block";
  } else {
    document.getElementById("toolarea").style.display = "none";
  }

}
// }}}
// dload
// {{{
function dload(data,fname) {
  const textToBLOB = new Blob([data], { type: 'text/plain' });
  const sFileName = fname;	   // The file to save the data.

  var newLink = document.createElement("a");
  newLink.download = sFileName;

  if (window.webkitURL != null) {
      newLink.href = window.webkitURL.createObjectURL(textToBLOB);
  }
  else {
      newLink.href = window.URL.createObjectURL(textToBLOB);
      newLink.style.display = "none";
      document.body.appendChild(newLink);
  }

  newLink.click(); 
}
// }}}
// open_terminal
// {{{
function open_terminal() {
  var data = "";
  data = data + 'exec xterm -T xterm.[pwd] &\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();

}
// }}}
// open_folder
// {{{
function open_folder(target) {
  var data = "";
  //data = data + 'openfolder ' + target +'\n'
  data = data + 'openfolder' +'\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();

}
// }}}
// newgpage
// {{{
function newgpage() {
  var data = "";
  data = data + 'newgpage\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();

}
// }}}
// newarow
// {{{
function newarow() {
  var data = "";
  data = data + 'newarow\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();

}
// }}}
// save_gbtn_onoff
// {{{
function save_gbtn_onoff() {
  var cmd = "";
  var gbtns = document.getElementsByClassName("gbtn_onoff");
  for (var k = 0; k < gbtns.length; k++) {
     var onoff   = gbtns[k].getAttribute('onoff');
     var key     = gbtns[k].getAttribute('key');
     var changed = gbtns[k].getAttribute('changed');
     if (changed) {
      console.log(key);
      var newcmd =  "g" + '.' + "|#|" +  key + "|#|" + onoff + "|E|\n";
      cmd = cmd + newcmd;
     }

  }
  return cmd;
}
// }}}
// build_flist
// {{{
function build_flist() {
  var data = "";
  data = data + 'build_flist\n'
  data = data + 'exec godel_draw.tcl\n'
  data = data + 'exec xdotool search --name "Mozilla" key ctrl+r\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();

}
// }}}
// new_link
// {{{
function new_link() {
  var data = "";
  data = data + 'new_link\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();
}
// }}}
// copy_path
// {{{
function copy_path() {
  var pname = window.location.pathname;
  console.log(pname);

  var dirname = pname.substr(0, pname.lastIndexOf("/"));

  var tt = 'cd ' + dirname + "\n";

  navigator.clipboard.writeText(tt)
}
// }}}

var flows = {
    //"flow": ['fln','hide','notes','anotes', 'checklist', 'dict', 'docs', 'exebutt', 'filebrowser', 'flist', 'issues'],
    "flow": ['fln','zoomsvg','hide','simple','notes','anotes', 'checklist','filebrowser', 'flist', 'issues', 'hcj', 'toc'],
    //"sch": ['field', 'hide'],
    //"tpl": ['pst','nocode','book','nation','cmic']
};

var cur_flow1 = "";
var cur_flow2 = "";
    

     
// fdstatus
// {{{
function fdstatus () {

  var data = "";
  data += 'exec xterm -hold -e "gget . fdiff"\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();

}
// }}}
// fdco
// {{{
function fdco () {

  var data = "";
  data += 'exec gget . fdiff co\n'
  data += 'exec godel_draw.tcl\n'
  data += 'exec xdotool search --name "Mozilla" key ctrl+r\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();

}
// }}}
// obless
// {{{
function obless () {
  //console.log(cur_flow1);
  //console.log(cur_flow2);

  console.log('new kkk get')
  //var data = "";
  //data += 'exec obless ' + cur_flow1 + ' ' + cur_flow2 + '\n'
  //data += 'exec godel_draw.tcl\n'
  //data += 'exec xdotool search --name "Mozilla" key ctrl+r\n'

  //dload(data,'gtcl.tcl');

  //document.getElementById('idexec').click();

}
// }}}
// flow2_click
// {{{
function flow2_click () {
  var gbtns = document.getElementsByClassName("gbtn_flow2");
  if (typeof(gbtns) != 'undefined' && gbtns != null) {
    for (var k = 0; k < gbtns.length; k++) {
  
        gbtns[k].addEventListener('click', function(){
  
          var data = "";
          var kk = this.innerText;
          cur_flow2 = kk;
          var btns = document.getElementsByClassName("gbtn_flow2");
          for (var k = 0; k < btns.length; k++) {
            var flow2 = btns[k].innerText;
            if (flow2 == kk) {
              btns[k].className = "gbtn_flow2 w3-button w3-round w3-light-blue w3-large";
              btns[k].setAttribute("onoff","1");
  
            } else {
              btns[k].className = "gbtn_flow2 w3-button w3-round w3-light-gray w3-normal";
              btns[k].setAttribute("onoff","0");
            }
          }
        })
    }
  }
}
// }}}
function goglobal () {

  let url = ""
  url += 'http://127.0.0.1:5000/goglobal?cwd='+ginfo['cwd']

  console.log(url)

  fetch(url)

}
// flow1_click
// {{{
function flow1_click () {
  var data = '';
  data += '<input class=w3-input type="text" id=newpage_name>\n';
  data += '<button class="w3-ripple w3-btn w3-white w3-border w3-border-blue w3-round-large" onclick="gui_newpage()">New</button>';
  data += '<pre>' + ginfo["srcpath"] + '</pre>\n';
  data += '<pre>' + ginfo["last_updated"] + '</pre>\n';
  data += '<button class="w3-ripple w3-btn w3-white w3-border w3-border-blue w3-round-large" onclick="obless()">Bless</button>';
  data += '<button class="w3-ripple w3-btn w3-white w3-border w3-border-blue w3-round-large" onclick="fdco()">Pull</button>';
  data += '<button class="w3-ripple w3-btn w3-white w3-border w3-border-blue w3-round-large" onclick="fdstatus()">Status</button>';
  data += '<button class="w3-ripple w3-btn w3-white w3-border w3-border-blue w3-round-large" onclick="goglobal()">Global</button><br>';
  Object.keys(flows).forEach(function(k){
    data += '<button class=\"gbtn_flow1 w3-button w3-round w3-light-gray w3-normal\" onoff=0>' + k + '</button>';
  })
  document.getElementById("flow1_section").innerHTML = data;

  var gbtns = document.getElementsByClassName("gbtn_flow1");
  if (typeof(gbtns) != 'undefined' && gbtns != null) {
    for (var k = 0; k < gbtns.length; k++) {
  
        gbtns[k].addEventListener('click', function(){
  
          var data = "";
          var kk = this.innerText;
          cur_flow1 = kk;
          var btns = document.getElementsByClassName("gbtn_flow1");
          for (var k = 0; k < btns.length; k++) {
            var flow1 = btns[k].innerText;
            if (flow1 == kk) {
              btns[k].className = "gbtn_flow1 w3-button w3-round w3-light-blue w3-large";
              btns[k].setAttribute("onoff","1");
  
              flows[flow1].forEach(function(flow2){
                data += '<button class=\"gbtn_flow2 w3-button w3-round w3-light-gray w3-normal\" onoff=0>' + flow2 + '</button>';
              });
  
              document.getElementById("flow2_section").innerHTML = data;
              
              flow2_click();
            } else {
              btns[k].className = "gbtn_flow1 w3-button w3-round w3-light-gray w3-normal";
              btns[k].setAttribute("onoff","0");
            }
          }
  
  
        })
    }
  }
}
// }}}
// mailout
// {{{
function mailout () {
  var data = '';
  data += 'Email: <input class=w3-input type="text" id=email_address value=york.wu@intel.com>\n';
  data += 'Filename: <input class=w3-input type="text" id=filename value=index.html>\n';
  data += '<button class="w3-ripple w3-btn w3-white w3-border w3-border-blue w3-round-large" onclick="send_email()">Send</button>';
  //data += '<pre>' + ginfo["srcpath"] + '</pre>\n';
  data += '<br>';
  data += '<br>';
  data += '<br>';
  data += '<br>';
  data += '<br>';
  data += '<br>';
  data += '<br>';
  data += '<br>';
  data += '<br>';
  data += '<br>';
  document.getElementById("flow1_section").innerHTML = data;

}
// }}}
// send_email
// {{{
function send_email() {
  var email    = document.getElementById("email_address").value;
  var filename = document.getElementById("filename").value;
  var filepath = ginfo["srcpath"];

  var data = "";
  data += 'emailout ' + email + ' ' + filename + ' ' + filepath + '\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();
  console.log(filename);
}
// }}}
// gui_newpage
// {{{
function gui_newpage() {

  var name = document.getElementById("newpage_name").value;

  console.log(name);

  var data = "";
  data += 'gui_newpage ' + name + '\n'

  dload(data,'gtcl.tcl');

  document.getElementById('idexec').click();
}
// }}}
// table_multi_onoff
// {{{
function table_multi_onoff(tblid, butid, colnames) {
    var table, tr, td, i, dispvalue;


    but = document.getElementById(butid);

    onoff = localStorage.getItem(butid);

    if (onoff === "1") {
      but.style.backgroundColor = 'white';
      but.style.color = 'black';
      localStorage.setItem(butid, "0")
      dispvalue = 'none'
    } else if (onoff == null) {
      but.style.backgroundColor = 'white';
      but.style.color = 'black';
      localStorage.setItem(butid, "0")
      dispvalue = 'none'
    } else {
      but.style.backgroundColor = '#FCAE1E';
      but.style.color = 'white';
      localStorage.setItem(butid, "1")
      dispvalue = ''
    }

    var tname = tblid;
    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

    let colname = "";
    th = tr[0].getElementsByTagName("th");
    for (i = 0; i < colnames.length; i++) {
      
      colname = colnames[i]
      //Get column_num
      for (j = 0; j < th.length; j++) {
        txt = th[j].innerHTML;
        txt = txt.trim();
        if (colname === txt) {
          column_num = j;   
          th[j].style.display=dispvalue
        }
      }
     
      for (k = 1; k < tr.length; k++) {
        td = tr[k].getElementsByTagName("td")[column_num];
        td.style.display=dispvalue
      }
    }
}
// }}}
// table_row_onoff
// {{{
function table_row_onoff(tblid, butid, colname, keyword, exact) {
    var table, tr, td, i;

    but = document.getElementById(butid);

    onoff = localStorage.getItem(butid);

    if (onoff === "1") {
      but.style.backgroundColor = 'white';
      but.style.color = 'black';
      localStorage.setItem(butid, "0")
      hide_table_rows(tblid,colname,keyword,exact)
    } else if (onoff == null) {
      but.style.backgroundColor = 'white';
      but.style.color = 'black';
      localStorage.setItem(butid, "0")
      hide_table_rows(tblid,colname,keyword,exact)
    } else {
      but.style.backgroundColor = '#FCAE1E';
      but.style.color = 'white';
      localStorage.setItem(butid, "1")
      select_table_rows(tblid,colname,keyword,exact)
    }
}
// }}}
// table_col_onoff
// {{{
function table_col_onoff(tblid, butid, colname) {
    var table, tr, td, i, dispvalue;

    but = document.getElementById(butid);

    onoff = localStorage.getItem(butid);

    if (onoff === "1") {
      but.style.backgroundColor = 'white';
      but.style.color = 'black';
      localStorage.setItem(butid, "0")
      dispvalue = 'none'
    } else if (onoff == null) {
      but.style.backgroundColor = 'white';
      but.style.color = 'black';
      localStorage.setItem(butid, "0")
      dispvalue = 'none'
    } else {
      but.style.backgroundColor = '#FCAE1E';
      but.style.color = 'white';
      localStorage.setItem(butid, "1")
      dispvalue = ''
    }

    var tname = tblid;
    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

// Get column_num
    console.log(colname)
    th = tr[0].getElementsByTagName("th");
    for (i = 0; i < th.length; i++) {
      txt = th[i].innerHTML;
      txt = txt.trim();
      if (colname === txt) {
        column_num = i;   
        th[i].style.display=dispvalue
      }
    }

    for (i = 1; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[column_num];
      td.style.display=dispvalue
    }
}
// }}}
// init_table_col_onoff
// {{{
function init_table_col_onoff (tblid) {
    var tname = tblid;

    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

    buts = document.querySelectorAll('[id^="but_"]');

    for (i = 0; i < buts.length; i++) {
      butid = buts[i].getAttribute('id')
      colname = buts[i].innerHTML;
      value = localStorage.getItem(butid)
      if (value === "0") {
        dispvalue = "none"
      } else {
        dispvalue = ""
      }
  // column_no
      th = tr[0].getElementsByTagName("th");
  
      let column_no = ""
      for (j = 0; j < th.length; j++) {
        txt = th[j].innerHTML;
        txt = txt.trim();
        if (colname === txt) {
          column_no = j;   
          th[j].style.display=dispvalue
        }
      }
      if (column_no == '') {
        //console.log('jj')
      } else {
        for (k = 1; k < tr.length; k++) {
          td = tr[k].getElementsByTagName("td")[column_no];
          td.style.display=dispvalue
        }
      }
    }
}
// }}}
// init_table_row_onoff
// {{{
function init_table_row_onoff (tblid) {
    var tname = tblid;

    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

    buts = document.querySelectorAll('[id^="row_"]');

    for (i = 0; i < buts.length; i++) {
      console.log(i)
      butid = buts[i].getAttribute('id')
      tblid = buts[i].getAttribute('tblid')
      colname = buts[i].getAttribute('colname')
      keyword = buts[i].innerHTML;
      value = localStorage.getItem(butid)
      if (value == '0') {
        console.log('remove')
        hide_table_rows(tblid, colname, keyword)
      } else {
        console.log('display')
        select_table_rows(tblid, colname, keyword)
      }
    }
}
// }}}
// init_col_button
// {{{
function init_col_button (tblid) {
    buts = document.querySelectorAll('[id^="but_"], [id^="row_"]');
    for (i = 0; i < buts.length; i++) {
      butid = buts[i].getAttribute('id')
      dispvalue = localStorage.getItem(butid)
      if (dispvalue === "0") {
        buts[i].style.backgroundColor = 'white';
        buts[i].style.color = 'black';
      } else {
        buts[i].style.backgroundColor = '#FCAE1E';
        buts[i].style.color = 'white';
      }
    }

}
// }}}
// mpvplay
// {{{
function mpvplay(fpath, code) {

  console.log(fpath)

  const url = 'http://127.0.0.1:5000/mpvplay?filepath='+fpath;

  fetch(url)
  .catch(err => console.log(err))
}
// }}}
// jsplay
// {{{
function jsplay(fpath, code) {

  console.log(fpath)
  console.log(code)

  var ff = encodeURIComponent(fpath)

  const url = 'http://127.0.0.1:5000/play1?filepath='+ff+'&code='+code;
  //const url = 'http://127.0.0.1:5000/mpvplay?filepath='+fpath;
  console.log(url)

  fetch(url)
  .catch(err => console.log(err))
}
// }}}
// delfile
// {{{
function delfile(fpath) {
  console.log(fpath)
  const url = 'http://127.0.0.1:5000/delfile?filepath='+fpath;

  fetch(url)
  .catch(err => console.log(err))

}
// }}}
//--------------------------
// Zoom in/out
//--------------------------
// mouseDown
// {{{
let moving
function mouseDown(e){
	moving = true
}
// }}}
// drag
// {{{
function drag(e){
  if (event.shiftKey) {
    if(moving === true){
      
      let startViewBox = svg.getAttribute('viewBox').split(' ').map( n => parseFloat(n))

      let startClient = {
        x: e.clientX,
        y: e.clientY
      }

      let newSVGPoint = svg.createSVGPoint()
      let CTM = svg.getScreenCTM()
      newSVGPoint.x = startClient.x
      newSVGPoint.y = startClient.y
      let startSVGPoint = newSVGPoint.matrixTransform(CTM.inverse())
      
      let moveToClient = {
        x: e.clientX + e.movementX,
        y: e.clientY + e.movementY
      }
      
      newSVGPoint = svg.createSVGPoint()
      CTM = svg.getScreenCTM()
      newSVGPoint.x = moveToClient.x
      newSVGPoint.y = moveToClient.y
      let moveToSVGPoint = newSVGPoint.matrixTransform(CTM.inverse())
      
      let delta = {
        dx: startSVGPoint.x - moveToSVGPoint.x,
        dy: startSVGPoint.y - moveToSVGPoint.y
      }
      
      let moveToViewBox = `${startViewBox[0] + delta.dx} ${startViewBox[1] + delta.dy} ${startViewBox[2]} ${startViewBox[3]}` 
      svg.setAttribute('viewBox', moveToViewBox)
      //console.log(moveToViewBox)
    }
  }
}
// }}}
// mouseUp
// {{{
function mouseUp(){
	moving = false
}
// }}}
// zoom
// {{{
function zoom(e){
  if (event.shiftKey) {
  	let startViewBox = svg.getAttribute('viewBox').split(' ').map( n => parseFloat(n))
		
    let startClient = {
      x: e.clientX,
      y: e.clientY
    }

    let newSVGPoint = svg.createSVGPoint()
    let CTM = svg.getScreenCTM()
    newSVGPoint.x = startClient.x
    newSVGPoint.y = startClient.y
    let startSVGPoint = newSVGPoint.matrixTransform(CTM.inverse())
    
    
    let r 
    if (e.deltaY < 0) {
      r = 0.8
    } else if (e.deltaY > 0) {
      r = 1.2
    } else {
      r = 1
    }
    svg.setAttribute('viewBox', `${startViewBox[0]} ${startViewBox[1]} ${startViewBox[2] * r} ${startViewBox[3] * r}`)
    
    CTM = svg.getScreenCTM()
    let moveToSVGPoint = newSVGPoint.matrixTransform(CTM.inverse())
    
    let delta = {
    	dx: startSVGPoint.x - moveToSVGPoint.x,
      dy: startSVGPoint.y - moveToSVGPoint.y
    }
    
  	let middleViewBox = svg.getAttribute('viewBox').split(' ').map( n => parseFloat(n))
    let moveBackViewBox = `${middleViewBox[0] + delta.dx} ${middleViewBox[1] + delta.dy} ${middleViewBox[2]} ${middleViewBox[3]}` 
    svg.setAttribute('viewBox', moveBackViewBox)
    
  }

}
// }}}
// cmdline
function cmdline(fullpath, cmd, param) {
  //const encodedParam = encodeURIComponent(param)
  //console.log(encodedParam)
  const url = 'http://127.0.0.1:5000/cmdline?fullpath='+fullpath+'&cmd='+cmd+'&param='+param;
  //const url = 'http://127.0.0.1:5000/cmdline?fullpath='+fullpath+'&cmd='+cmd+'&param='+encodedParam;

  fetch(url);
}
// xcmdline
function xcmdline(fullpath, cmd, param) {
  console.log('kk')
  const url = 'http://127.0.0.1:5000/xcmdline?fullpath='+fullpath+'&cmd='+cmd+'&param='+param;

  fetch(url);
}

function lsearch() {

  const input = document.getElementById('sinput');
  //var ff = encodeURIComponent(fpath)
  let txt = ""
  txt += 'http://127.0.0.1:5000/lsearch?keywords='+input.value
  txt += '&dbpath='+ginfo['cwd']+'/.dbfile.db'
  const url = txt

  console.log(url)


  fetch(url)
  .then(res => {
    return res.json()
  }).then(result => {
    const p = document.getElementById('result');
    let txt = "<div style='display:flex; width=1000px;flex-wrap:wrap;padding:10px;margin:10px;gap:30px'>"
    for (let i in result) {
      const path = result[i].path;
      const pagename = result[i].pagename;
      const kw       = result[i].keywords;
      txt += `<div><a href="${path}/.index.htm">${pagename}<br><img height=50px src="${path}/cover.png"></img><a></div>`
    }
    txt += '</div>'
    p.innerHTML = txt
  })
  .catch(err => console.log(err))
}


function basename(path) {
   return path.split('/').reverse()[0];
}

function dirname(path) {
  return path.match(/(.*)[\/\\]/)[1]||'';
}

// add event listener to tables
function listen2tables () {
  // Add event to highlight modified cells in tables
  //var tables = document.getElementsByTagName('table');
  var tables = document.getElementsByClassName('table1');
  //console.log(tables)
  if(typeof(tables) != 'undefined' && tables != null){
    for (var k = 0; k < tables.length; k++) {
    
        var cells = tables[k].getElementsByTagName('td');
  
        for (var i = 0; i < cells.length; i++) {
          cells[i].addEventListener('input', function(){
            var gname   = this.getAttribute("gname");
            this.setAttribute("changed","1");
            this.style.backgroundColor = "lightyellow";
          })
        }
        for (var i = 0; i < cells.length; i++) {
          var colname = cells[i].getAttribute("colname");
          var gclass  = cells[i].getAttribute("gclass");
          if (colname === "DEL") {
            cells[i].addEventListener('click', function(){
              this.style.backgroundColor = "gray";
              this.setAttribute("changed","1");
              this.setAttribute("onoff","1");
            })
          } else if (colname === "MOVE") {
            cells[i].addEventListener('click', function(){
              this.setAttribute("changed","1");
              var onoff   = this.getAttribute("onoff");
              if (onoff === "1") {
                this.setAttribute("bgcolor","lightblue")
                this.setAttribute("onoff","0");
                //this.innerText = "FD";
              } else {
                this.setAttribute("bgcolor","yellow")
                this.setAttribute("onoff","1");
                //this.innerText = 1;
              }
            })
          } else if (colname === "fdel") {
            cells[i].addEventListener('click', function(){
              this.setAttribute("changed","1");
              var onoff   = this.getAttribute("onoff");
              if (onoff === "1") {
                this.setAttribute("bgcolor","lightblue")
                this.setAttribute("onoff","0");
                //this.innerText = "FD";
              } else {
                this.setAttribute("bgcolor","gray")
                this.setAttribute("onoff","1");
                //this.innerText = 1;
              }
            })
          } else if (gclass === "onoff") {
            cells[i].addEventListener('click', function(){
              this.setAttribute("changed","1");
              var onoff   = this.getAttribute("onoff");
              if (onoff === "1") {
                this.setAttribute("bgcolor","")
                this.setAttribute("onoff","0");
                this.innerText = "";
              } else {
                this.setAttribute("bgcolor","lightblue")
                this.setAttribute("onoff","1");
                this.innerText = 1;
              }
            })
          } else if (colname === "tick") {
            cells[i].addEventListener('click', function(){
              this.setAttribute("changed","1");
              var onoff   = this.getAttribute("onoff");
              if (onoff === "1") {
                this.setAttribute("bgcolor","")
                this.setAttribute("onoff","0");
                this.innerText = "";
              } else {
                this.setAttribute("bgcolor","lightgreen")
                this.setAttribute("onoff","1");
                this.innerText = 1;
              }
            })
          } else if (colname === "ctitle") {
            cells[i].addEventListener('click', function(){
              this.setAttribute("changed","1");
              var onoff   = this.getAttribute("onoff");
              if (onoff === "1") {
                this.setAttribute("bgcolor","")
                this.setAttribute("onoff","0");
                this.innerText = "";
              } else {
                this.setAttribute("bgcolor","pink")
                this.setAttribute("onoff","1");
                this.innerText = 1;
              }
            })
          } else if (colname === "star") {
            cells[i].addEventListener('click', function(){
              this.setAttribute("changed","1");
              var onoff   = this.getAttribute("onoff");
              if (onoff === "1") {
                this.setAttribute("bgcolor","")
                this.setAttribute("onoff","0");
                this.innerText = "";
              } else {
                this.setAttribute("bgcolor","yellow")
                this.setAttribute("onoff","1");
                this.innerText = 1;
              }
            })
          } else if (colname === "num") {
            cells[i].addEventListener('click', function(){
              var gname   = this.getAttribute("gname");
              window.location = gname + "/.index.htm"
            })
          } else {
            cells[i].addEventListener('click', function(){
              this.style.backgroundColor = "lightyellow";
            })
          }
        }
    }
  }
}
// face
function face (ghtm, targetid, cdpath) {
  let url = ''
  url += 'http://localhost:5000/face?path='+cdpath
  url += '&ghtm='+ghtm

  fetch(url)
  .then(res => res.text())
  .then(result => {
    const p = document.getElementById(targetid);
    p.innerHTML = result
    //listen2tables()
  })
  .catch(err => console.log(err))
}
// genface
function genface (ghtm, targetid, callback, name) {
  let url = ''
  url += 'http://localhost:5000/genface?path='+ginfo['cwd']
  url += '&ghtm='+ghtm
  //console.log(url)

  fetch(url)
  .then(res => res.text())
  .then(result => {
    const p = document.getElementById(targetid);
    p.innerHTML = result
    listen2tables()
    if (typeof callback === 'function') {
      callback(name);
    } else {
      console.log(callback)
    }
  })
  .catch(err => console.log(err))
}
// execmd
function execmd(dir, cmd) {

  var cmd2 = encodeURIComponent(cmd)

  let url = ''
  url += 'http://localhost:5000/execmd?path='+dir
  url += '&cmd='+cmd2

  //console.log(dir)
  //console.log(cmd)
  console.log(url)

  fetch(url)
  .catch(err => console.log(err))
}

// cwdcmd
function cwdcmd(cmd, action='NA') {

  const dir = dirname(window.location.pathname);

  //var cmd2 = encodeURIComponent(cmd)
  var cmd2 = cmd

  let url = ''
  url += 'http://localhost:5000/execmd?path='+dir
  url += '&cmd='+cmd2

  fetch(url)
  .then(result => {
    if (action === 'reload') {
      location.reload()
    }
  })
  .catch(err => console.log(err))
}

// toggle_switch
// {{{
function toggle_switch (e, bgcolor) {
  const cwd = dirname(window.location.pathname);
  const dbpath  = cwd + '/dbfile.db'
  const dbtable = 'dbtable'
  const key     = e.getAttribute('key')
  const value   = e.getAttribute('value')
  const idname  = e.getAttribute('idname')
  const idvalue = e.getAttribute('idvalue')

  console.log(key)
  console.log(idname)
  console.log(idvalue)

  if (value === '1') {
    e.style.backgroundColor = 'white'
    var newvalue = 0
    var newtxt   = ''
  } else {
    e.style.backgroundColor = bgcolor
    var newvalue = 1
    var newtxt   = '1'
  }

  e.setAttribute('value', newvalue)
  e.innerText = newtxt

  let url = ''
  url += 'http://localhost:5000/sqlupdate?dbpath='+dbpath
  url += '&dbtable='+dbtable
  url += '&key='+key
  url += '&value='+newvalue
  url += '&idname='+idname
  url += '&idvalue='+idvalue

  fetch(url)
  .catch(err => console.log(err))

  cwdcmd(`lsetvar ${idvalue} ${key} ${newvalue}`)
}
// }}}
// sql_switch
// {{{
function sql_switch (e,action='NA') {
  const cwd = dirname(window.location.pathname);
  const dbpath  = cwd + '/dbfile.db'

  const dbtable = 'dbtable'
  const key     = e.getAttribute('key')
  const value   = e.getAttribute('value')
  const idname  = e.getAttribute('idname')
  const idvalue = e.getAttribute('idvalue')

  if (value === '1') {
    e.className = "w3-btn w3-gray"
    var newvalue = 0
    var newtxt   = ''
  } else {
    e.className = "w3-btn w3-red"
    var newvalue = 1
    var newtxt   = '1'
  }

  e.setAttribute('value', newvalue)

  let url = ''
  url += 'http://localhost:5000/sqlupdate?dbpath='+dbpath
  url += '&dbtable='+'ltable'
  url += '&key='+ key
  url += '&value='+newvalue

  fetch(url)
  .then(result => {
    if (action === 'reload') {
      location.reload()
    }
  })
  .catch(err => console.log(err))
}
// }}}
// sql_set
// {{{
function sql_set (e,action='NA') {
  const cwd = dirname(window.location.pathname);
  const dbpath  = cwd + '/dbfile.db'

  const dbtable = 'dbtable'
  const key     = e.getAttribute('key')
  const value   = e.getAttribute('value')
  const idname  = e.getAttribute('idname')
  const idvalue = e.getAttribute('idvalue')

  let url = ''
  url += 'http://localhost:5000/sqlupdate?dbpath='+dbpath
  url += '&dbtable='+'ltable'
  url += '&key='+ key
  url += '&value='+value

  fetch(url)
  .then(result => {
    if (action === 'reload') {
      location.reload()
    }
  })
  .catch(err => console.log(err))
}
// }}}
// save_td
function save_td(e) {
  const cwd = dirname(window.location.pathname);
  const dbpath  = cwd + '/dbfile.db'

  const dbtable = 'dbtable'
  const key     = e.getAttribute('colname')
  const value   = e.innerText
  const idname  = e.getAttribute('wherecol')
  const idvalue = e.getAttribute('whereval')
  var   changed = e.getAttribute('changed')

  if (changed) {
    let url = ''
    url += 'http://localhost:5000/sqlupdate?dbpath='+dbpath
    url += '&dbtable='+dbtable
    url += '&key='+key
    url += '&value='+value
    url += '&idname='+idname
    url += '&idvalue='+idvalue

    fetch(url)
    .catch(err => console.log(err))

    cwdcmd(`lsetvar ${idvalue} ${key} '${value}'`)
  }
}

function datatable(tbid) {
  $(document).ready(function() {
    $(tbid).DataTable({
       paging: false,
       info: false,
       order: [],
    });
  })
}
// vim:fdm=marker
