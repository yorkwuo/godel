proc ghtm_pagelist {{sort_by by_updated}} {
# ghtm_pagelist by_updated/by_size

  upvar env env
  upvar fout fout
  source $env(GODEL_META_CENTER)/meta.tcl
  source $env(GODEL_META_CENTER)/indexing.tcl
  array set vars [array get meta]
# ilist = pagelist

  #set ilist [lmap i [array name meta *,where] {regsub ",where" $i ""}]
  set ilist [list]
  foreach i [array name meta *,where] {
    regsub ",where" $i "" i
    lappend ilist $i
  }

#@>Foreach Pages in pagelist
# $ilist = page name list
  foreach i $ilist {
    set location $vars($i,where)
# vars,href
    set vars($i,href) "<a href=\"[tbox_cygpath $vars($i,where)/.index.htm]\" class=w3-text-blue>$i</a>"
# vars,last_updated
    regsub {^\d\d\d\d-} $vars($i,last_updated) {} vars($i,last_updated)

    lappend pairs [list $i $vars($i,last_updated)]
# size_pairs
    if {$vars($i,pagesize) == "NA"} {
      set vars($i,pagesize) 0
      lappend size_pairs [list $i $vars($i,pagesize)]
    } else {
      lappend size_pairs [list $i $vars($i,pagesize)]
    }
  }
  set arr(by_updated) [lsort -index 1 -decreasing $pairs]
  set arr(by_size)    [lsort -index 1 -decreasing -integer $size_pairs]


  set num 1
  foreach pair $arr($sort_by) {
    set name [lindex $pair 0]
# rowlist
    lappend rowlist $num
    set vars($num,name)     "$vars($name,href)"
    #puts $vars($num,name)
    set ghtm      "$vars($name,where)/.godel/ghtm.tcl type=text/txt"
    set vars_href "$vars($name,where)/.godel/vars.tcl type=text/txt"
    set vars($num,ghtm)     "ghtm=>$ghtm"
    set vars($num,vars)     "vars=>$vars_href"
    set vars($num,last)     $vars($name,last_updated)
    if [info exist vars($name,pagesize)] {
      set vars($num,size)     $vars($name,pagesize)
    } else {
      set vars($num,size)     ""
    }
    set vars($num,keywords) $vars($name,keywords)
    incr num
  }

# columnlist
  set columnlist [list]
  lappend columnlist [list name name]
  lappend columnlist [list ghtm ghtm]
  lappend columnlist [list vars vars]
  lappend columnlist [list last last]
  lappend columnlist [list size size]
  lappend columnlist [list keywords keywords]

  ghtm_table_nodir pagelist 0
}
