#proc godel_vars2passdown {target} {
#  upvar vars vars
#  upvar define define
#  foreach i $define(vars2passdown) {
#    godel_pass_down_vars $i       $target,$i
#  }
#}
