
$(document).ready(function(){

  $('#bid1').click(function () {

    var inputid = "inputid1";

    var cmds = "";

    input = document.getElementById(inputid);
    ivalue = input.value;

    cmds = "exec tcsh -fc \"rm -rf " + ivalue + "\"" + "\n";
    cmds = cmds + "godel_draw";

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
