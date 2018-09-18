#!/bin/tcsh -f
setenv GODEL_IN_CYGWIN      1

set dir = `pwd`
setenv GODEL_ROOT           $dir
setenv GODEL_PLUGIN         $dir/plugin
#setenv GODEL_USER_PLUGIN    $dir/plugin

mkdir -p $dir/data/CENTER
mkdir -p $dir/data/META
setenv GODEL_CENTER         $dir/data/CENTER
setenv GODEL_META_CENTER    $dir/data/META

setenv CYGWIN_INSTALL       C:/cygwin64
setenv GODEL_DEV_MODE       0

setenv PATH ${GODEL_ROOT}/bin:${PATH}


alias gim                godel_import.tcl
alias gc                 godel_codes.tcl
alias gco                godel_checkout.tcl
alias gpage              godel_page.csh
alias gre                godel_redraw.tcl
alias gdel               godel_delete.csh
alias ddg                godel_delete_ghtm.tcl
alias glist              godel_list.tcl
alias gd                 godel_draw.tcl
alias gg                 gg.tcl

alias gcd                'set k = `echo \!* | sed "s/CENTER//"`; eval cd $GODEL_CENTER/$k'

alias cdk               'eval `gcd.tcl \!*`'
alias gok               'eval `gok.tcl \!*`'
alias gvi               'eval `gvi.tcl \!*`'

alias gpa                godel_pa.tcl
alias gevo               godel_evolve.tcl
alias gdnew              gdnew.tcl
alias gdrm               gdrm.tcl
alias fa                 firefox .index.htm &
alias cdg                cd $GODEL_ROOT

alias win                'cygstart .'

