#!/usr/bin/tclsh
# (C) 1998 - 2000 by Johannes Zellner, <johannes@zellner.org>
# $Id: tclreadlineCompleter.tcl,v 2.23 2000/07/01 14:23:17 joze Exp $
# vim:set ts=4:
# ---
#
# tclreadline -- gnu readline for tcl
# http://www.zellner.org/tclreadline/
# Copyright (c) 1998 - 2000, Johannes Zellner <johannes@zellner.org>
#
# This software is copyright under the BSD license.
#
# ================================================================== 
package provide tclreadline 2.2

namespace eval tclreadline:: {
    namespace export Init
}

set dir [file dirname [info script]]

proc ::tclreadline::Init {} {
    uplevel #0 {
        if ![info exists tclreadline::library] {
            if [catch {load [file join $dir/libtclreadline.so]} msg] {
                puts stderr $msg
                exit 2
            }
        }
    }
}

tclreadline::Init
::tclreadline::readline customcompleter ::tclreadline::ScriptCompleter

source [file join [file dirname [info script]] tclreadlineSetup.tcl]

set auto_index(::tclreadline::ScriptCompleter) \
[list source [file join [file dirname [info script]] tclreadlineCompleter.tcl]]
