#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/godel.tcl

oget flow flow rtl
oget flow flow sim
oget flow flow verdi
oget flow flow syn
oget flow flow upf
oget flow flow dft
oget flow flow floorplan
oget flow flow place
oget flow flow cts
oget flow flow route
oget flow flow rcext
oget flow flow sta_setup
oget flow flow sta_func
oget flow flow sta_shift
oget flow flow sta_capture

lsetvar rtl       next "verdi sim"
lsetvar sim       next "syn"
lsetvar syn       next "upf"
lsetvar upf       next "dft"
lsetvar dft       next "floorplan"
lsetvar floorplan next "place"
lsetvar place     next "cts"
lsetvar cts       next "route"
lsetvar route     next "rcext"
lsetvar rcext     next "sta_setup"
lsetvar sta_setup next "sta_func sta_shift sta_capture"

