
setenv PATH ${GODEL_ROOT}/bin:${PATH}

setenv TCLLIBPATH "${GODEL_ROOT}/scripts/tcl ${TCLLIBPATH}"
setenv GODEL_FIREFOX /usr/intel/bin/firefox
setenv GODEL_GVIM    /usr/intel/bin/gvim

alias gim                godel_import.tcl
alias gd                 godel_draw.tcl

alias gl                'gl.tcl -l  \!*'
#alias gll               'eval `gl.tcl -l \!*`'
alias mt                'genmeta.tcl > .godel/lmeta.tcl; lind.tcl'
alias mscope            'setenv GODEL_META_SCOPE `mscope.tcl \!*`'

alias fa                 firefox .index.htm &
alias cdg                cd $GODEL_ROOT


alias mci       meta_chkin.tcl
alias mind      meta-indexing
alias gd        godel_draw.tcl
alias cdk       'eval `cdk.tcl \!*`'
alias lcd       'eval `lcd.tcl \!*`'
alias jcd       'eval `jcd.tcl \!*`'
alias gok       'eval `gok.tcl \!*`'
alias gvi       'eval `gvi.tcl \!*`'
alias fa        firefox .index.htm &
alias cdg       cd $GODEL_ROOT

alias f1 "gvim .godel/ghtm.tcl"
alias f2 "gvim .godel/vars.tcl"
alias f3 "gvim .godel/proc.tcl"

alias st    "git status"
alias gitcm "git commit -m n -a"

