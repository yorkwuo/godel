
$(document).ready(function(){

  $('#bid0').click(function () {

    var inputid = "inputid0";

    var cmds = "";

    input = document.getElementById(inputid);
    ivalue = input.value;

    //cmds = "exec tcsh -fc \"rm -rf " + ivalue + "\"" + "\n";
    cmds = "file mkdir " + ivalue + "\n";
    cmds = cmds + "godel_draw " + ivalue;

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
