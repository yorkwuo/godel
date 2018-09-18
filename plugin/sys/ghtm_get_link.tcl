proc ghtm_get_link {name} {
  upvar fout fout
  upvar env env
  source $env(META_CENTER)/meta.tcl

  if {$env(GODEL_IN_CYGWIN)} {
    return "<a href=[tbox_cygpath $meta($name,where)/.index.htm]>$name</a>"
  } else {
    return "<a href=$meta($name,where)/.index.htm>$name</a>"
  }
}
