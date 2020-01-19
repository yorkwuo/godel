// JQuery: fm delete
// {{{
$(document).ready(function(){
  var $TABLE = $('#fm');

  $('#fmsave').click(function () {

    //var $rows = $TABLE.find('tr');
    var $rows = $('#tbl').find('tr');

    var cmds = "";
    // foreach row
    $rows.each(function () {
      //var $td = $(this).find('td');
      var $td = $(this).find('td');
      // foreach td
      $td.each(function () {
        var value   = $(this).text();
        var gname   = $(this).attr('gname');
        //var colname = $(this).attr('colname');
        if (typeof gname === 'undefined') {
          return; // equal to continue
        } else {
          if (value === "dd" ) {
            var cmd = "exec rm -rf \"" + gname + "\"\n";
            cmds = cmds + cmd;
          } else if (value === "") {
            //var cmd = value + "\n";
          } else {
            //var cmd = value + "\n";
            var cmd = "exec mkdir -p .tmp/" + value + "\n" + "exec mv {" + gname + "} .tmp/" + value + "\n";
            cmds = cmds + cmd;
          }
          //var cmd = "lsetvar " + gname + " " + colname + " \"" + value + "\"\n";
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

  });


});
// }}}
// JQuery: Save text to disk
// {{{
$(document).ready(function(){
  var $TABLE = $('#tbl');

  $('#save').click(function () {

    //var $rows = $TABLE.find('tr');
    var $rows = $('#tbl').find('tr');

    var cmds = "";
    // foreach row
    $rows.each(function () {
      //var $td = $(this).find('td');
      var $td = $(this).find('td');
      // foreach td
      $td.each(function () {
        var value   = $(this).text();
        var gname   = $(this).attr('gname');
        var colname = $(this).attr('colname');
        if (typeof gname === 'undefined') {
          return; // equal to continue
        } else {
          var cmd = "lsetvar " + gname + " " + colname + " \"" + value + "\"\n";
        }
        cmds = cmds + cmd;
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
// filter_table_keyword
// {{{
function filter_table_keyword(tname, column_no, input) {
  var input, filter, table, tr, td, i;

  //input = document.getElementById("filter_table_input");
  //input = keyword;
  console.log(input);
  //filter = input.value.toUpperCase();
  filter = input.toUpperCase();

  //if(e.keyCode === 13){
    //e.preventDefault(); // Ensure it is only this code that rusn

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

// vim:fdm=marker
