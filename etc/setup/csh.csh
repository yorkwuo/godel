
setenv PATH ${GODEL_ROOT}/bin:${PATH}

setenv TCLLIBPATH "${GODEL_ROOT}/scripts/tcl ${TCLLIBPATH}"

alias gim                godel_import.tcl
#alias gc                 godel_codes.tcl
#alias gco                godel_checkout.tcl
#alias gpage              godel_page.csh
#alias gre                godel_redraw.tcl
#alias gdel               godel_delete.csh
#alias ddg                godel_delete_ghtm.tcl
#alias glist              godel_list.tcl
alias gd                 godel_draw.tcl
#alias gg                 gg.tcl

alias cdk               'eval `cdk.tcl \!*`'
alias gok               'eval `gok.tcl \!*`'
alias gvi               'eval `gvi.tcl \!*`'

#alias gpa                godel_pa.tcl
#alias gevo               godel_evolve.tcl
#alias gdnew              gdnew.tcl
#alias gdrm               gdrm.tcl
alias fa                 firefox .index.htm &
alias cdg                cd $GODEL_ROOT



