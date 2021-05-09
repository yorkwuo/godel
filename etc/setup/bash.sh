
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


cdk    () { 
  eval `cdk.tcl $*` 
}
gok    () { 
  eval `gok.tcl $*` 
}
gvi    () { 
  eval `gvi.tcl $*` 
}

alias tpage="gget todo -o"
alias gdr="godel_draw.tcl; xdotool search --name \"Mozilla\" key ctrl+r"
alias gd="godel_draw.tcl"
alias cdg='cd $GODEL_ROOT'
alias mci=meta_chkin.tcl
alias mind=meta-indexing
alias fa="firefox .index.htm&"
alias f1="gvim .godel/ghtm.tcl"
alias f2="gvim .godel/vars.tcl"
alias f3="gvim .godel/proc.tcl"
alias f4="gvim .godel/dyvars.tcl"
alias lv=lvars
alias lsv=lsetvar


function lcd { 
  `lcd.tcl "$@"`
}
function jcd { 
  `jcd.tcl "$@"`
}
