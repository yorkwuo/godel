#!/usr/bin/tclsh
package require t2ws
package require Tk
source $env(GODEL_ROOT)/bin/godel.tcl

t2ws::Configure -log_level 3

# image_number
# {{{
proc image_number {} {
  set files [lsort -decreasing -ascii [glob -nocomplain images/*.jpg]]
  if {$files == ""} {
    return "001"
  } else {
    regsub -all {images\/} $files {} files
    regsub -all {\.jpg} $files {} files
    regsub -all {[a-zA-Z]} $files {} files
    set biggest [lindex $files 0]
    if {$biggest == ""} {
      return "001"
    } else {
      regsub {^0+} $biggest {} biggest
      return [format "%03d" [incr biggest]]
    }
  }
}
# }}}
# urlDecode
# {{{
proc urlDecode {str} {
    set specialMap {"[" "%5B" "]" "%5D"}
    set seqRE {%([0-9a-fA-F]{2})}
    set replacement {[format "%c" [scan "\1" "%2x"]]}
    set modStr [regsub -all $seqRE [string map $specialMap $str] $replacement]
    return [encoding convertfrom utf-8 [subst -nobackslash -novariable $modStr]]
}
# }}}

proc MyResponder {Request} {

  set uri [dict get $Request URI]
  set body [dict get $Request Body]

  regexp {^/(\w*)} $uri -> command

#-----------------------------------------------------------------------
# eval
#-----------------------------------------------------------------------
  if {$command == "eval"} {
    regexp {^/(\w*)/(.*)$} $uri -> command arguments
		set Data [uplevel #0 $arguments]
		return [dict create Body $Data Content-Type "text/plain"]
#-----------------------------------------------------------------------
# image
#-----------------------------------------------------------------------
  } elseif {$command == "image"} {
    regexp {^/(\w*)\s+(\S*)$} $uri -> command dirpath
# Change directory to gpage location
    cd $dirpath
# Decode URL
    set response [urlDecode $body]
# Remove header
    regsub {^.*data:image/png;base64,} $response {} response
# Save base64 image format to disk
    set kout [open "/tmp/img64" w]
      puts $kout $response
    close $kout
# Decode base64 to image file
    file mkdir images
    set filename [image_number]
    exec cat /tmp/img64 | base64 -d > images/$filename.jpg

    return [dict create Body "Image saved." Content-Type "text/plain"]
  }

}

t2ws::Stop
t2ws::Start 8080 -responder MyResponder

# vim:fdm=marker
