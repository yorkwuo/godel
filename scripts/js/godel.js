// Key binded to edit and draw
document.onkeyup = function(e) {
// Ctrl 1
  if        (e.ctrlKey && e.which == 49) {
    document.getElementById('iddraw').click();
// Ctrl 2
  } else if (e.ctrlKey && e.which == 50) {
    document.getElementById('idbutton').click();
// Ctrl 3
  } else if (e.ctrlKey && e.which == 51) {
    document.getElementById('idedit').click();
// Ctrl F1
  } else if (e.ctrlKey && e.which == 112) {
    document.getElementById('idplay').click();
// Alt 2
//  } else if (e.altKey && e.which == 50) {
//    document.getElementById('iddraw').click();
// Alt 3
//  } else if (e.altKey && e.which == 51) {
//    document.getElementById('idbutton').click();
// Alt 1
//  } else if (e.altKey && e.which == 49) {
//    document.getElementById('idplay').click();
  }
};

// Add event to highlight modified cells in tables
var tables = document.getElementsByTagName('table');
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
        } else {
          cells[i].addEventListener('click', function(){
            this.style.backgroundColor = "lightyellow";
          })
        }
      }
  }
}
function topFunction() {
  document.body.scrollTop = 0;
  document.documentElement.scrollTop = 0;
}
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
// JQuery: Save
// {{{
//$(document).ready(function(){
//  //var $TABLE = $('#tbl');
//
//  $('#save').click(function () {
//
//    //var $rows = $TABLE.find('tr');
//    var $rows = $('table').find('tr');
//
//    var cmds = "";
//    // foreach row
//    $rows.each(function () {
//      //var $td = $(this).find('td');
//      var $td = $(this).find('td');
//      // foreach td
//      $td.each(function () {
//        var gtype   = $(this).attr('gtype');
//        if (gtype == 'innerHTML') {
//          var value   = $(this).prop("innerHTML");
//        } else {
//          var value   = $(this).prop("innerText");
//        }
//        var gname   = $(this).attr('gname');
//        var colname = $(this).attr('colname');
//        var changed = $(this).attr('changed');
//        //console.log(value);
//        //console.log(this);
//        if (typeof gname === 'undefined') {
//          return; // equal to continue
//        } else {
//          if (changed) {
//            if (colname == "chkbox") {
//              var n = 'cb_' + gname;
//              var v = document.getElementById(n).checked;
//              if (v) {
//                var cmd = "exec rm -rf " + gname + "\n";
//                cmds = cmds + cmd;
//                document.getElementById(n).checked = false;
//                $(this).attr('changed', false);
//              }
//            } else {
//              //var cmd = "lsetvar " + " \"" + gname + "\"" + " " + colname + " \"" + value + "\"\n";
//              var cmd =   gname + "|#|" +  colname + "|#|" +  value + "|E|\n";
//
//              cmds = cmds + cmd;
//            }
//            $(this).css('backgroundColor', "");
//          }
//
//        }
//      });
//    });
//
//// Save
//    var data = cmds;
//    const textToBLOB = new Blob([data], { type: 'text/plain' });
//    const sFileName = 'gtcl.tcl';	   // The file to save the data.
//
//    var newLink = document.createElement("a");
//    newLink.download = sFileName;
//
//    if (window.webkitURL != null) {
//        newLink.href = window.webkitURL.createObjectURL(textToBLOB);
//    }
//    else {
//        newLink.href = window.URL.createObjectURL(textToBLOB);
//        newLink.style.display = "none";
//        document.body.appendChild(newLink);
//    }
//
//    newLink.click(); 
//
//    //$('#iddraw').click();
//
//
//    //document.getElementById('iddraw').click();
//    //document.getElementById('exedraw').click();
//    document.getElementById('iddraw').click();
//
//  });
//
//
//});
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
// cd2dir
// {{{
function cd2dir() {
  var disp = "";
  disp = disp + "hcd ";
  var dir = window.location.href;
  disp = disp + dir + "\n";
  document.getElementById("text_board").value =  disp;
  var copyText = document.getElementById("text_board");
  document.getElementById("text_board").style.display = "inline"
  copyText.select();
  document.execCommand("Copy");
  document.getElementById("text_board").style.display = "none"
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
// open_folder
// {{{
function open_folder(dirpath) {
// Save
    var data = "ginst : nautilus : kkk:" +  dirpath + "\n";
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
function filter_table_keyword(tname, colname, input) {
    var input, filter, table, tr, td, i;

    var filter = input;
    var patt  = new RegExp(filter, "i");
    var patt2 = new RegExp(colname, "i");

    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

    th = tr[0].getElementsByTagName("th");
    for (i = 0; i < th.length; i++) {
      txt = th[i].innerHTML;
      if (patt2.test(txt)) {
        column_no = i;   
      }
    }

    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[column_no];
      if (td) {
        var found = 1
          if (patt.test(td.innerHTML)) {
            found = found && 1;
          } else {
            found = found && 0;
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
// hide_table_row
// {{{
//function hide_table_row(row,col) {
//  table = document.getElementById("tbl");
//  tr = table.getElementsByTagName("tr");
//
//  //console.log(row);
//  td = tr[row].getElementsByTagName("td");
//  var pvalue = td[1].innerText;
//  console.log(pvalue);
//
//  var start = row + 1;
//  for (i = start; i < tr.length; i++) {
//    td = tr[i].getElementsByTagName("td");
//    var level = td[1].innerText;
//    if (level > pvalue) {
//      tr[i].classList.toggle("hidden");
//    } else if (level == pvalue) {
//      break;
//    }
//  }
//}
// }}}
// add event listener for hide_table_row
//# {{{
//table = document.getElementById("tbl");
//
//table.addEventListener('click',function(e){
//  var row = e.target.parentElement.rowIndex;
//  var col = e.target.cellIndex;
//  hide_table_row(row,col);
//},false);
//# }}}
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
// at_open
// {{{
function at_open (atfname,id) {

    var header = "#!/usr/bin/tclsh\n";
    header = header + "source $env(GODEL_ROOT)/bin/godel.tcl\n";
    header = header + "source " + atfname + "\n";

    id = id.replace(/\s/g,'\\ ');
    id = id.replace(/\(/g,'\\\(');
    id = id.replace(/\)/g,'\\\)');

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
// save_gtable
// {{{
function save_gtable(tableobj) {
  console.log("gtabe");
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
            if (changed) {
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
  console.log("atabe");
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
            var cmd =  "a" + gname + "|#|" +  colname + "|#|" + onoff + "|E|\n";
            cmds = cmds + cmd;
          } else {
            var cmd =   "a" + gname + "|#|" +  colname + "|#|" +  value + "|E|\n";
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
  var tables = document.getElementsByTagName('table');

  var cmds = "";
  for (var k = 0; k < tables.length; k++) {
    var tbltype = tables[k].getAttribute('tbltype');

    if (tbltype === "atable") {
      cmds = cmds + save_atable(tables[k]);
    } else {
      cmds = cmds + save_gtable(tables[k]);
    }
  }
  //console.log(cmds);

    var data = cmds;
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

// vim:fdm=marker
