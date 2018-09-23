proc ghtm_top_bar {{type NA}} {
  upvar fout fout
  upvar env env
  upvar vars vars
  upvar flow_name flow_name

# default flow_name
  if ![info exist flow_name] {
    set flow_name default
  }

  set cwd [pwd]

  puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/godel.js]></script>"
  puts $fout "<script src=[tbox_cygpath $env(GODEL_ROOT)/scripts/js/prism/prism.js]></script>"

  puts $fout "<div class=\"w3-bar w3-border w3-indigo w3-medium\">"
# Edit
  puts $fout "  <div><a href=.godel/ghtm.tcl type=text/txt class=\"w3-bar-item w3-button w3-hover-red\">Edit</a></div>"
# Values
  puts $fout "  <div><a href=.godel/vars.tcl type=text/txt class=\"w3-bar-item w3-button w3-hover-red\">Values</a></div>"
# Save
  #puts $fout "  <button class=\"w3-button w3-hover-red\" onclick=\"do_gg()\">Save</button>"
# TOC
  puts $fout "  <div><a href=.main.htm  class=\"w3-bar-item w3-button w3-hover-red\">TOC</a></div>"

# asic4 path
# {{{
  if {[info exist vars(module)] && [info exist vars(stage)] && [info exist vars(version)] && [info exist vars(corner)]} {
    # detail
    if {$type == "detail"} {
      if [info exist vars(module)] {
        puts $fout "<div class=\"w3-bar-item w3-hover-red\"><a href=../../../../.index.htm>CENTER/</a><a href=../../../.index.htm>$vars(module)/</a><a href=../../.index.htm>$vars(stage)/</a><a href=../.index.htm>$vars(version)/</a><a href=.index.htm>$vars(corner)</a></div>"
      }
    # corner
    } elseif {$type == "corner"} {
       puts $fout "<div class=\"w3-bar-item w3-hover-red\"><a href=../../../.index.htm>CENTER/</a><a href=../../.index.htm>$vars(module)/</a><a href=../.index.htm>$vars(stage)/</a><a href=.index.htm>$vars(version)/</a></div>"
    # version
    } elseif {$type == "version"} {
       puts $fout "<div class=\"w3-bar-item w3-hover-red\"><a href=../../.index.htm>CENTER/</a><a href=../.index.htm>$vars(module)/</a><a href=.index.htm>$vars(stage)/</a></div>"
    # stage
    } elseif {$type == "stage"} {
       puts $fout "<div class=\"w3-bar-item w3-hover-red\"><a href=../.index.htm>CENTER/</a><a href=.index.htm>$vars(module)/</a></div>"
    # module
    } elseif {$type == "module"} {
       puts $fout "<div class=\"w3-bar-item w3-hover-red\"><a href=.index.htm>CENTER/</a></div>"
    }
  }
# }}}
  set path_define   [tbox_cygpath $env(GODEL_ROOT)/plugin/flow/define.tcl]
  set path_help     [tbox_cygpath $env(GODEL_ROOT)/docs/help/.index.htm]
  set path_pagelist [tbox_cygpath $env(GODEL_META_CENTER)/pagelist/.index.htm]
  set path_draw     [tbox_cygpath $env(GODEL_ROOT)/plugin/gdraw/gdraw_$flow_name.tcl]
  puts $fout "<div class=\"w3-dropdown-click w3-right\">"
  puts $fout "  <button onclick=\"myFunction()\" class=\"w3-button w3-hover-red\">More</button>"
  puts $fout "  <div id=\"Demo\" class=\"w3-dropdown-content w3-bar-block w3-card-4\">"
  puts $fout "    <a href=\".main.htm\"                     class=\"w3-bar-item w3-button\">Table of Content</a>"
  puts $fout "    <a href=\".index.htm\"      type=text/txt class=\"w3-bar-item w3-button\">HTML</a>"
  puts $fout "    <a href=\".godel/w3.css\"   type=text/txt class=\"w3-bar-item w3-button\">CSS</a>"
  puts $fout "    <a href=\"$path_define\"    type=text/txt class=\"w3-bar-item w3-button\">Define</a>"
  puts $fout "    <a href=\"$path_help\"                    class=\"w3-bar-item w3-button\">Help</a>"
  puts $fout "    <a href=\"$path_pagelist\"                class=\"w3-bar-item w3-button\">Pagelist</a>"
  puts $fout "    <a href=\"$path_draw\"      type=text/txt class=\"w3-bar-item w3-button\">Draw</a>"
  puts $fout "    <a href=\".godel/proc.tcl\" type=text/txt class=\"w3-bar-item w3-button\">Proc</a>"
  puts $fout "    <a href=\"../.index.htm\"                 class=\"w3-bar-item w3-button\">Parent</a>"
  puts $fout "  </div>"
  puts $fout "</div>"
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
  puts $fout "</script>"
}
# vim:fdm=marker
