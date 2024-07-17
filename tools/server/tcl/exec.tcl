
set gtclfile $env(GODEL_DOWNLOAD)/gtcl.tcl

if [file exist $gtclfile] {
  after 500
  source  $gtclfile
  exec rm $gtclfile
} else {
  after 1000
  if [file exist $gtclfile] {
    source  $gtclfile
    exec rm $gtclfile
  }
}
