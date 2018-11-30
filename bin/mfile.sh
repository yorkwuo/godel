#!/bin/bash

echo "1: default"
echo "2: sjc      /home/USER/unix/york/sjc/sjc.mfile.tcl"
echo "3: none"

read input

if (($input == "1")); then
  echo "default"
  export GODEL_META_FILE=$GODEL_META_CENTER/meta.tcl
elif (($input == "2")); then 
  echo "sjc"
  export GODEL_META_FILE=/cygdrive/c/Users/chihkang/Documents/pages/sjc/sjc.mfile.tcl
else
  echo "None"
fi
