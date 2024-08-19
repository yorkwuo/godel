ghtm_top_bar -save -js
pathbar 2
# css
# {{{
puts $fout {
<style>
.top {
    display: flex;
    margin: 0; 
    height:100vh;
    overflow:hidden;
}
p {
    font-size: 18px;
}
#content {
    flex: 1;
    padding: 20px;
    overflow-y: auto;
}
#toc-container {
    position: relative;
    width: 250px;
    background-color: #f4f4f4;
    display: flex;
    flex-direction: column;
}
#toc {
    flex: 1;
    padding: 20px;
    overflow-y: auto;
}
#toc ul {
    list-style-type: none;
    padding-left: 0;
}
#toc ul li {
    margin-bottom: 10px;
}
#toc ul li a {
    text-decoration: none;
    color: #333;
}
#toc ul li a:hover {
    text-decoration: underline;
}
#toc-toggle {
    background-color: #333;
    color: #fff;
    border: none;
    padding: 10px;
    cursor: pointer;
}
#toc.hidden {
    display: none;
}
</style>

}
# }}}

#puts $fout {
#<div class=top>
#  <div id=toc-container>
#    <button id="toc-toggle">TOC</button>
#
#    <div id="toc">
#        <h2>Table of Contents</h2>
#        <ul id="toc-list"></ul>
#    </div>
#  </div>
#}
puts $fout {
<div class=top>
  <div id=toc-container>
    <div id="toc">
        <ul id="toc-list"></ul>
    </div>
  </div>
}

puts $fout {<div id="content">}
gmd 1.md
puts $fout {</div>}

puts $fout {
</div>
}

# vim:fdm=marker
