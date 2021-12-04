// Key binded to edit and draw
// Ctrl + 1 : Edit
// Ctrl + 2 : Draw
document.onkeyup = function(e) {
  if        (e.ctrlKey && e.which == 49) {
    document.getElementById('idedit').click();
  } else if (e.ctrlKey && e.which == 50) {
    document.getElementById('iddraw').click();
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
          var att = this.setAttribute("changed","1");
          this.style.backgroundColor = "lightyellow";
          //var kk   = this.getAttribute("changed");
          //console.log(kk);
        })
      }
  }
}
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
// newdraw
// {{{
function newdraw() {
// Save
    //var data =   "." + "|#|" +  key + "|#|" +  value + "|E|\n";
    var data = "set gtitle " + "\"" + document.title + "\"";
    const textToBLOB = new Blob([data], { type: 'text/plain' });
    const sFileName = 'gtitle.tcl';	   // The file to save the data.

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
    document.getElementById('exedraw').click();


}
// }}}
// JQuery: Save
// {{{
$(document).ready(function(){
  //var $TABLE = $('#tbl');

  $('#save').click(function () {

    //var $rows = $TABLE.find('tr');
    var $rows = $('table').find('tr');

    var cmds = "";
    // foreach row
    $rows.each(function () {
      //var $td = $(this).find('td');
      var $td = $(this).find('td');
      // foreach td
      $td.each(function () {
        var value   = $(this).prop("innerText");
        var gname   = $(this).attr('gname');
        var colname = $(this).attr('colname');
        var changed = $(this).attr('changed');
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
              //var cmd = "lsetvar " + " \"" + gname + "\"" + " " + colname + " \"" + value + "\"\n";
              var cmd =   gname + "|#|" +  colname + "|#|" +  value + "|E|\n";

              cmds = cmds + cmd;
            }
            $(this).css('backgroundColor', "");
          }

        }
      });
    });

// Save
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

    //$('#iddraw').click();


    //document.getElementById('iddraw').click();
    //document.getElementById('exedraw').click();

  });


});
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
// scan_table
// {{{
function aaa (tname) {
  //alert("jjj")
  table = document.getElementById(tname);
  tr = table.getElementsByTagName("tr");
  for (i = 0; i < tr.length; i++) {
    //td = tr[i].getElementsByTagName("td")[4];
    td = tr[i].getElementsByTagName("td");
    for (j = 0; j < td.length; j++) {
      console.log(td[j].innerHTML)
    }
    //console.log(td.length)
    //if (td) {
    //  console.log(td.innerHTML)
    //    //if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
    //    //  tr[i].style.display = "";
    //    //} else {
    //    //  tr[i].style.display = "none";
    //    //}
    //}       
  }
}
// }}}
// do_gg
// {{{
function do_gg() {
  var disp = "";
  disp = disp + "gg ";

  var dir = window.location.href;

  // Assemble disp to: gg /path/to/.index.htm
  disp = disp + dir + "\n";

  document.getElementById("text_board").value =  disp;
  var copyText = document.getElementById("text_board");
  document.getElementById("text_board").style.display = "inline"

  // Select the text
  copyText.select();

  // Copy to system clipboard
  document.execCommand("Copy");
  document.getElementById("text_board").style.display = "none"
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
// set_value
// {{{
function set_value(key, value) {
// Save
    var data =   "." + "|#|" +  key + "|#|" +  value + "|E|\n";
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
// filter_table_keyword
// {{{
function filter_table_keyword(tname, column_no, input) {
  var input, filter, table, tr, td, i;

  //input = document.getElementById("filter_table_input");
  //input = keyword;
  //console.log(input);
  //filter = input.value.toUpperCase();
  //filter = input.toUpperCase();
  var filter = input;

  //if(e.keyCode === 13){
    //e.preventDefault(); // Ensure it is only this code that rusn
          //if (td.innerHTML.toUpperCase().indexOf(filter[j]) > -1) 

    //filter = filter.split(" ");
    //alert("kkk");
    var patt = new RegExp(filter, "i");

    table = document.getElementById(tname);
    tr = table.getElementsByTagName("tr");

    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[column_no];
      if (td) {
        var found = 1
        for (j = 0; j < filter.length; j++) {
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
          //} else {
          //}
      }       
    }
  //}
}
// }}}
// refresh
// {{{
function refresh() {
  var disp = "";
  disp = disp + "<inst>\n";
  disp = disp + "<command>cd ";
  var dir = window.location.href;
  var newdir = dir.replace("file:///C:/cygwin64","");
  newdir = newdir.substr(0, newdir.lastIndexOf("/"));
  disp = disp + newdir + "</command>" + "\n";
  disp = disp + "<command>godel_draw</command>\n";
  disp = disp + "</inst>\n";
  document.getElementById("text_board").value =  disp;
  var copyText = document.getElementById("text_board");
  document.getElementById("text_board").style.display = "inline"
  copyText.select();
  document.execCommand("Copy");
}
// }}}
// paste2clipb
// {{{
function paste2clipb(tfile) {
  var disp = "";
  disp = disp + "<inst>\n";
  disp = disp + "<command>exec tcsh -fc \"xterm -hold -e " + tfile + "\"</command>\n";
  disp = disp + "</inst>\n";

  document.getElementById("text_board").value =  disp;
  var copyText = document.getElementById("text_board");
  document.getElementById("text_board").style.display = "inline"
  copyText.select();
  document.execCommand("Copy");
  document.getElementById("text_board").style.display = "none"

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


// vim:fdm=marker
