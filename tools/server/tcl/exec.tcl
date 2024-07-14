#if [file exist "$env(GODEL_DOWNLOAD)/gtcl.tcl"] {
#  source  $env(GODEL_DOWNLOAD)/gtcl.tcl
#  exec rm $env(GODEL_DOWNLOAD)/gtcl.tcl
#} else {
#  source local.tcl
#}

if [file exist "$env(GODEL_DOWNLOAD)/gtcl.tcl"] {
  source  $env(GODEL_DOWNLOAD)/gtcl.tcl
  exec rm $env(GODEL_DOWNLOAD)/gtcl.tcl
}
