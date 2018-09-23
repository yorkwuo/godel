dir=`pwd`

export GODEL_ROOT=$dir

export GODEL_IN_CYGWIN=1
export CYGWIN_INSTALL=C:/cygwin64

export GODEL_DEV_MODE=1

if [ ! -e $HOME/data/CENTER ]; then
  mkdir -p $HOME/data/CENTER
  mkdir -p $HOME/data/META_CENTER
  mkdir -p $HOME/data/CLCENTER
fi
export GODEL_CENTER=$HOME/data/CENTER
export GODEL_META_CENTER=$HOME/data/META_CENTER
export CLCENTER=$HOME/data/CLCENTER

source $GODEL_ROOT/etc/setup/bash.sh
