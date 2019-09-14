
#=====================================
# TCLLIBPATH
#=====================================
pp="$GODEL_ROOT/scripts/tcl $TCLLIBPATH"
# uniquify
pp=$(echo $pp | tr ' ' '\n' | sort -u)
export TCLLIBPATH=$pp

#=====================================
# PATH
#=====================================
export PATH=$GODEL_ROOT/bin:$PATH


export GODEL_PLUGIN=$GODEL_ROOT/plugin

tlist  () { 
  eval `tdolist $*` 
}
cdk    () { 
  eval `cdk.tcl $*` 
}
gok    () { 
  eval `gok.tcl $*` 
}
gvi    () { 
  eval `gvi.tcl $*` 
}
mscope () { 
  export GODEL_META_SCOPE=`mscope.tcl $*` 
}
tdoset () { 
  gget todo todo_set $* 
}
mt () {
  genmeta.tcl > .godel/lmeta.tcl
  lind.tcl
}

alias gd=godel_draw.tcl
alias cdg='cd $GODEL_ROOT'
alias mci=meta_chkin.tcl
alias mind=meta-indexing
alias mfile='. mfile.sh'
alias tkg="tkgdl.tcl &"
alias fa="firefox .index.htm&"
alias f1="gvim .godel/ghtm.tcl"
alias f2="gvim .godel/vars.tcl"
alias f3="gvim .godel/proc.tcl"

gmkdir () {
  echo $1
  path=`pwd`
  godel_draw.tcl
  cd ..
}

#export GODEL_GVIM=/cygdrive/c/Program\ Files\ \(x86\)/Vim/vim81/gvim.exe
#export GODEL_FIREFOX=/cygdrive/c/Program\ Files/Mozilla\ Firefox/firefox.exe
