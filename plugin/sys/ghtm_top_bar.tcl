proc ghtm_top_bar {{type NA}} {
  upvar fout fout
  upvar env env
  upvar vars vars
  upvar flow_name flow_name
  if [file exist .godel/dyvars.tcl] {
    source .godel/dyvars.tcl
  } else {
    set dyvars(last_updated) Now
  }

# default flow_name
  if ![info exist flow_name] {
    set flow_name default
  }

  set cwd [pwd]

  puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/godel.js]></script>"
  puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/jquery-3.3.1.min.js]></script>"
  #puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/prism/prism.js]></script>"

  puts $fout "<div class=\"w3-bar w3-border w3-indigo w3-medium\">"
# Edit
  puts $fout "  <div><a href=.godel/ghtm.tcl type=text/txt class=\"w3-bar-item w3-button w3-hover-red\">Edit</a></div>"
# Values
  puts $fout "  <div><a href=.godel/vars.tcl type=text/txt class=\"w3-bar-item w3-button w3-hover-red\">Values</a></div>"
# Draw
  puts $fout "  <div><button class=\"w3-bar-item w3-button w3-hover-red\" onclick=\"js_godel_draw()\">Draw</button></div>"
# 
  puts $fout "  <div><div id=\"div\" class=\"w3-bar-item w3-button w3-hover-red\" style=\"width:20px;height:20px;\" contenteditable=\"true\"></div></div>"
# TOC
  puts $fout "  <div><a href=.main.htm  class=\"w3-bar-item w3-button w3-hover-red\">TOC</a></div>"
  set path_help     [tbox_cygpath $env(GODEL_ROOT)/docs/help/.index.htm]
  set path_pagelist [tbox_cygpath $env(GODEL_META_CENTER)/pagelist/.index.htm]
  set path_draw     [tbox_cygpath $env(GODEL_ROOT)/plugin/gdraw/gdraw_$flow_name.tcl]
  puts $fout "<div class=\"w3-dropdown-click w3-right\">"
  puts $fout "  <button onclick=\"myFunction()\" class=\"w3-button w3-hover-red\">More</button>"
  puts $fout "  <div id=\"Demo\" class=\"w3-dropdown-content w3-bar-block w3-card-4\">"
  puts $fout "    <a href=\".main.htm\"                     class=\"w3-bar-item w3-button\">Table of Content</a>"
  puts $fout "    <a href=\".index.htm\"      type=text/txt class=\"w3-bar-item w3-button\">HTML</a>"
  puts $fout "    <a href=\"$path_help\"                    class=\"w3-bar-item w3-button\">Help</a>"
  puts $fout "    <a href=\"$path_pagelist\"                class=\"w3-bar-item w3-button\">Pagelist</a>"
  puts $fout "    <a href=\"$path_draw\"      type=text/txt class=\"w3-bar-item w3-button\">Draw</a>"
  puts $fout "    <a href=\".godel/proc.tcl\" type=text/txt class=\"w3-bar-item w3-button\">Proc</a>"
  puts $fout "    <a href=\"../.index.htm\"                 class=\"w3-bar-item w3-button\">Parent</a>"
  puts $fout "  </div>"
  puts $fout "</div>"
  
  puts $fout "  <div><a href=../.index.htm class=\"w3-bar-item w3-button w3-hover-red w3-right\">Parent</a></div>"
  puts $fout "  <div class=\"w3-bar-item w3-button w3-hover-red w3-right\">$dyvars(last_updated)</div>"

  puts $fout "</div>"


  puts $fout "<textarea rows=10 cols=70 id=\"text_board\" style=\"display:none;font-size:10px\"></textarea>"

  puts $fout "<script>"
  puts $fout "function myFunction() {"
  puts $fout "    var x = document.getElementById(\"Demo\");"
  puts $fout "    if (x.className.indexOf(\"w3-show\") == -1) {"
  puts $fout "        x.className += \" w3-show\";"
  puts $fout "    } else { "
  puts $fout "        x.className = x.className.replace(\" w3-show\", \"\");"
  puts $fout "    }"
  puts $fout "}"
  set server $env(GODEL_SERVER)
  set pwd    [pwd]
  puts $fout "function js_godel_draw() {"
  puts $fout "  httpRequest = new XMLHttpRequest();"
  puts $fout "  httpRequest.open('GET', 'http://$server/eval/cd $pwd;godel_draw', true);"
  puts $fout "  httpRequest.send();"
  puts $fout "}"
  puts $fout ""
  puts $fout "var div = document.getElementById('div');"
  puts $fout "div.addEventListener('paste', function(e) {"
  puts $fout "  if(e.clipboardData) {"
  puts $fout "    for(var i = 0; i < e.clipboardData.items.length; i++ ) {"
  puts $fout "      var c = e.clipboardData.items\[i];"
  puts $fout "      var f = c.getAsFile();"
  puts $fout "      var reader = new FileReader();"
  puts $fout "      reader.readAsDataURL(f);"
  puts $fout "      reader.onload = function(e) {"
  puts $fout "        div.innerHTML  = 'Done';"
  puts $fout "        var imgbase64 = e.target.result;"
  puts $fout "    $.ajax({"
  puts $fout "        type: \"POST\","
  puts $fout "        url: \"http://localhost:8080/image $pwd\","
  puts $fout "        data: { "
  puts $fout "           imgbase64"
  puts $fout "        }"
  puts $fout "      }).done(function(responseText) {"
  puts $fout "        console.log('saved');"
  puts $fout "      });"
  puts $fout "      }"
  puts $fout "    }"
  puts $fout "  }"
  puts $fout "});"

  puts $fout "</script>"
}
# vim:fdm=marker
