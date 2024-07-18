#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

if {[info exist env(GODEL_WSL)] && $env(GODEL_WSL) eq "1"} {
  catch {exec /mnt/c/Program\ Files/Inkscape/bin/inkscape.exe 1.svg &}
} else {
  catch {exec inkscape 1.svg &}
}

