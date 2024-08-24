ghtm_top_bar -save -js
pathbar 2
puts $fout {
<div class=top>
  <div id=toc-container>
    <div id="toc">
        <ul id="toc-list"></ul>
    </div>
  </div>
  <div id="content">
}

gmd 1.md

puts $fout {
  </div>
</div>
}

# vim:fdm=marker
