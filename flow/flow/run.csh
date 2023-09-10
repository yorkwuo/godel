#!/usr/bin/csh -f

xterm -e "godel_draw.tcl;lsetvar . status running; eda_shell cmd.tcl; lsetvar . status done; next.csh"
