ghtm_top_bar -save -js -hide
pathbar 3
gnotes "
# $vars(g:pagename)


"
if [file exist notes.tcl] {
  source notes.tcl
}
insert_svg
