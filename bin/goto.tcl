#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

# https://wiki.tcl-lang.org/page/url-encoding
proc utf8 {hex} {
    set hex [string map {% {}} $hex]
    encoding convertfrom utf-8 [binary decode hex $hex]
}
proc url_decode str {
    # rewrite "+" back to space
    # protect \ from quoting another '\'
    set str [string map [list + { } "\\" "\\\\"] $str]

    # Replace UTF-8 sequences with calls to the utf8 decode proc...
    regsub -all {(%[0-9A-Fa-f0-9]{2})+} $str {[utf8 \0]} str
    
    return [subst -novar -noback $str]
}

#exec xdotool search --name "Mozilla" windowactivate --sync key Alt+d
catch {exec xdotool getwindowfocus} wid
catch {exec xdotool key Alt+d $wid}

after 100
exec xdotool key Ctrl+c
after 100
#exec xdotool key Tab

catch {exec xclip -o} pp

set pp [url_decode $pp]

regsub {file:\/\/} $pp {} pp
set pp [file dirname $pp]

set cmd "cd $pp"

exec echo $cmd | xclip &


