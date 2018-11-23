#!/usr/bin/perl
use strict;
use warnings;

while(<>){
  next if m/^#/;
  if(m'([\-0-9a-zA-Z./_]+/[\-0-9a-zA-Z./_]+)'){
    if(-e $1) {
      print "good! -> $1\n";
    }else{
      print "bad! -> $1\n";
    }
  }
}
