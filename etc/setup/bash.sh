
export GODEL_PLUGIN=$GODEL_ROOT/plugin
#export GODEL_USER_PLUGIN    $dir/plugin

export PATH=$GODEL_ROOT/bin:$PATH

alias gim=godel_import.tcl
alias gc=godel_codes.tcl
alias gco=godel_checkout.tcl
alias gpage=godel_page.csh
alias gre=godel_redraw.tcl
alias gdel=godel_delete.csh
alias ddg=godel_delete_ghtm.tcl
alias glist=godel_list.tcl
alias greset=godel_chart_reset.csh
alias gd=godel_draw.tcl
alias gg=gg.tcl
alias ga=godel_gather.tcl
alias gaset='setenv GA_ROOT `pwd`; echo $GA_ROOT'
#alias gacd='cd $GA_ROOT/\!*'

#alias gcd='set k = `echo \!* | sed "s/CENTER//"`; eval cd $GODEL_CENTER/$k'
#alias cdk='eval `gcd.tcl \!*`'
cdk () {
  eval `gcd.tcl $*`
}

gok () {
  eval `gok.tcl $*`
}

#alias gvi='eval `gvi.tcl \!*`'
gvi () {
  eval `gvi.tcl $*`
}

alias gpa=godel_pa.tcl
alias gevo=godel_evolve.tcl
alias gdnew=gdnew.tcl
alias gdrm=gdrm.tcl
alias cdg='cd $GODEL_ROOT'

#alias tlist=tbox_list.tcl
#alias tcygpath=tbox_cygpath.tcl
