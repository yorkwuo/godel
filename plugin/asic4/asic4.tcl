#: godel_asic_index5
# {{{
  proc godel_asic_index5 {} {
    upvar env env
      upvar define define
      upvar module module
      upvar stage stage
      upvar version version
      set vars(module)  $module
      set vars(stage)   $stage
      set vars(version) $version

      source .godel/vars.tcl

      set just_draw 1
      godel_draw $vars(flow_name)
  }

# }}}
#: godel_asic_index4
# {{{
proc godel_asic_index4 {} {
  upvar env env
  upvar define define

  upvar module module
  upvar stage stage
  upvar version version
  upvar corner corner
  set vars(module)  $module
  set vars(stage)   $stage
  set vars(version) $version
  set vars(corner)  $corner

  source .godel/vars.tcl

  #parray vars
  godel_draw asic4_ghtm4
#  set fout [open "index4.htm" w]
#  puts $fout ""
#  puts $fout "<html>"
#  puts $fout "<head>"
#  puts $fout "<title>4. Corner list ($stage) </title>"
#  #puts $fout "<link rel=\"stylesheet\" type=\"text/css\" href=\".style.css\">"
#  puts $fout "<STYLE>"
#  puts $fout "body {font-family: arial; font-size:14px;}"
#  puts $fout "table,th,td {"
#  puts $fout "  border: 1px solid black;"
#  puts $fout "  border-collapse: collapse;"
#  puts $fout "}"
#  puts $fout "th, td {"
#  puts $fout "  padding: 3px;"
#  puts $fout "  text-align: center; font-size:14px;"
#  puts $fout "}"
#  puts $fout "td ul li {"
#  puts $fout "    padding:0;"
#  puts $fout "    margin:0;"
#  puts $fout "}"
#  puts $fout "</STYLE>"
#  puts $fout "</head>"
#  puts $fout "<body>"
#  ghtm_top_bar index4
#
## by modes
## {{{
#  puts $fout "<h3> by modes</h3>"
#  puts $fout "<TABLE>"
#  puts $fout "<thead>"
#  puts $fout "    <tr>"
#  puts $fout "        <th></th>"
#  puts $fout "        <th colspan=2 ><a href=all/index5.htm>all</a></th>"
#  puts $fout "        <th colspan=2 >func</th>"
#  puts $fout "        <th colspan=2 >shift</th>"
#  puts $fout "        <th colspan=2 >dccap</th>"
#  puts $fout "    </tr>"
#  puts $fout "    <tr>"
#  puts $fout "        <th></th>"
#  puts $fout "        <th>max</th>"
#  puts $fout "        <th>min</th>"
#  puts $fout "        <th>max</th>"
#  puts $fout "        <th>min</th>"
#  puts $fout "        <th>max</th>"
#  puts $fout "        <th>min</th>"
#  puts $fout "        <th>max</th>"
#  puts $fout "        <th>min</th>"
#  puts $fout "    </tr>"
#  puts $fout "</thead>"
#  puts $fout "<tbody>"
#  puts $fout "    <tr>"
#  puts $fout "        <td>NVP</td>"
#  puts $fout "        <td>$vars(all,max,nvp)</td>"
#  puts $fout "        <td>$vars(all,min,nvp)</td>"
#  puts $fout "        <td>$vars(func_max,nvp)</td>"
#  puts $fout "        <td>$vars(func_min,nvp)</td>"
#  puts $fout "        <td>$vars(shift_max,nvp)</td>"
#  puts $fout "        <td>$vars(shift_min,nvp)</td>"
#  puts $fout "        <td>$vars(dccap_max,nvp)</td>"
#  puts $fout "        <td>$vars(dccap_min,nvp)</td>"
#  puts $fout "    </tr>"
#  puts $fout "    <tr>"
#  puts $fout "        <td>WNS</td>"
#  puts $fout "        <td>$vars(all,max,wns)</td>"
#  puts $fout "        <td>$vars(all,min,wns)</td>"
#  puts $fout "        <td>$vars(func_max,wns)</td>"
#  puts $fout "        <td>$vars(func_min,wns)</td>"
#  puts $fout "        <td>$vars(shift_max,wns)</td>"
#  puts $fout "        <td>$vars(shift_min,wns)</td>"
#  puts $fout "        <td>$vars(dccap_max,wns)</td>"
#  puts $fout "        <td>$vars(dccap_min,wns)</td>"
#  puts $fout "    </tr>"
#  puts $fout "</tbody>"
#  puts $fout "</TABLE>"
## }}}
#  #puts $fout "<img src=modes_nvp_wns.png>"
## by corner
## {{{
#  puts $fout "<h3> by corner </h3>"
## func mode
#  puts $fout "<TABLE>"
#  puts $fout "<thead>"
#  puts $fout "    <tr>"
#  puts $fout "        <th scope=\"col\"></th>"
#  puts $fout "        <th scope=\"col\" colspan=4>Setup</th>"
#  puts $fout "        <th scope=\"col\" colspan=16>Hold</th>"
#  puts $fout "    </tr>"
#  puts $fout "    <tr>"
#  puts $fout "        <th scope=\"col\"></th>"
#  puts $fout "        <th scope=\"col\" colspan=4>$define(pt,ss_voltage)</th>"
#  puts $fout "        <th scope=\"col\" colspan=8>$define(pt,ss_voltage)</th>"
#  puts $fout "        <th scope=\"col\" colspan=8>$define(pt,ff_voltage)</th>"
#  puts $fout "    </tr>"
#  puts $fout "    <tr>"
#  puts $fout "        <th></th>"
#  puts $fout "        <th>prcs</th>"
#  puts $fout "        <th>pcss</th>"
#  puts $fout "        <th>prcs</th>"
#  puts $fout "        <th>pcss</th>"
#
#  puts $fout "        <th>prcs</th>"
#  puts $fout "        <th>prcf</th>"
#  puts $fout "        <th>pcss</th>"
#  puts $fout "        <th>pcff</th>"
#  puts $fout "        <th>prcs</th>"
#  puts $fout "        <th>prcf</th>"
#  puts $fout "        <th>pcss</th>"
#  puts $fout "        <th>pcff</th>"
#
#  puts $fout "        <th>prcs</th>"
#  puts $fout "        <th>prcf</th>"
#  puts $fout "        <th>pcss</th>"
#  puts $fout "        <th>pcff</th>"
#  puts $fout "        <th>prcs</th>"
#  puts $fout "        <th>prcf</th>"
#  puts $fout "        <th>pcss</th>"
#  puts $fout "        <th>pcff</th>"
#  puts $fout "    </tr>"
#  puts $fout "    <tr>"
#  puts $fout "        <th></th>"
#  puts $fout "        <th colspan=2>m40C</th>"
#  puts $fout "        <th colspan=2>125C</th>"
#  puts $fout "        <th colspan=4>m40C</th>"
#  puts $fout "        <th colspan=4>125C</th>"
#  puts $fout "        <th colspan=4>m40C</th>"
#  puts $fout "        <th colspan=4>125C</th>"
#  puts $fout "    </tr>"
#  puts $fout "</thead>"
#  puts $fout "<tbody>"
#  puts $fout "<tr>"
#  puts $fout "<td>func</td>"
#  godel_index4_corner_td [list 001 002 003 004] ""
#  godel_index4_corner_td [list 005 006 007 008 009 010 011 012] peachpuff
#  godel_index4_corner_td [list 013 014 015 016 017 018 019 020] ""
#  puts $fout "</tr>"
## shift mode
#  puts $fout "<tr>"
#  puts $fout "<td>shift</td>"
#  godel_index4_corner_td [list 021 022 023 024] ""
#  godel_index4_corner_td [list 025 026 027 028 029 030 031 032] peachpuff
#  godel_index4_corner_td [list 033 034 035 036 037 038 039 040] ""
#  puts $fout "</tr>"
## dccap mode
#  puts $fout "<tr>"
#  puts $fout "<td>dccap</td>"
#  godel_index4_corner_td [list 041 042 043 044] ""
#  godel_index4_corner_td [list 045 046 047 048 049 050 051 052] peachpuff
#  godel_index4_corner_td [list 053 054 055 056 057 058 059 060] ""
#  puts $fout "</tr>"
#  puts $fout "</tbody>"
#  puts $fout "</TABLE>"
## }}}
#  #puts $fout "<img src=func.png>"
#  #puts $fout "<img src=shift.png>"
#  #puts $fout "<img src=dccap.png>"
#  puts $fout "</body>"
#  puts $fout "</html>"
#  close $fout
}

# }}}
#: godel_asic_index3
# {{{
proc godel_asic_index3 {} {
  upvar signoff signoff
  upvar env     env

  upvar module module
  upvar stage stage
  upvar version version
  upvar corner corner
  set vars(module)  $module
  set vars(stage)   $stage
  set vars(version) $version
  set vars(corner)  $corner

  source .godel/vars.tcl

  godel_draw asic4_ghtm3
}
# }}}
#: godel_asic_index2
# {{{
proc godel_asic_index2 {} {
  upvar signoff signoff
  upvar env env

  upvar module module
  upvar stage stage
  upvar version version
  upvar corner corner
  set vars(module)  $module
  set vars(stage)   $stage
  set vars(version) $version
  set vars(corner)  $corner
  source .godel/vars.tcl

  godel_draw asic4_ghtm2
}
# }}}
#: godel_asic_index1
# {{{
proc godel_asic_index1 {} {
  upvar env env
  upvar signoff signoff

  upvar module module
  upvar stage stage
  upvar version version
  upvar corner corner
  set vars(module)  $module
  set vars(stage)   $stage
  set vars(version) $version
  set vars(corner)  $corner

  source .godel/vars.tcl

  godel_draw asic4_ghtm1
}
# }}}
# godel_update_vars5
# {{{
proc godel_update_vars5 {} {
  upvar module module
  upvar stage stage
  upvar version version
  upvar corner corner
  upvar flow_name flow_name
  upvar define define


  if [file exist .godel/vars.tcl] {
    source .godel/vars.tcl
  }

  if ![info exist vars(flow_name)] {
    set vars(flow_name) $flow_name
  }
  godel_init_vars max,wns        NA
  godel_init_vars max,nvp        NA
  godel_init_vars min,wns        NA
  godel_init_vars min,nvp        NA
  godel_init_vars clock_period     NA
  godel_init_vars pdk            NA
  godel_init_vars uncertainty    NA
  godel_init_vars current_speed  NA
  godel_init_vars opt_speed      NA
  
# calculate current_speed
  if {$vars(max,wns) != "NA" && $vars(uncertainty) != "NA"} {
    set clock_period $vars(clock_period)
    set vars(current_speed) [format "%.f" [expr 1/($clock_period.0 - $vars(max,wns) + $vars(uncertainty)) * 1000000]]
  }

  godel_array_save vars .godel/vars.tcl


  # prepare for next level
  godel_level_promotion $corner
}
# }}}
# godel_update_vars4
# {{{
proc godel_update_vars4 {} {
  upvar define define
  upvar module module
  upvar stage stage
  upvar version version

  if [file exist .godel/vars.tcl] {source .godel/vars.tcl}
# nvp
  godel_init_vars all,max,nvp   NA
  godel_init_vars all,min,nvp   NA
  godel_init_vars func_max,nvp  NA
  godel_init_vars func_min,nvp  NA
  godel_init_vars shift_max,nvp NA
  godel_init_vars shift_min,nvp NA
  godel_init_vars dccap_max,nvp NA
  godel_init_vars dccap_min,nvp NA
# wns
  godel_init_vars all,max,wns   NA
  godel_init_vars all,min,wns   NA
  godel_init_vars func_max,wns  NA
  godel_init_vars func_min,wns  NA
  godel_init_vars shift_max,wns NA
  godel_init_vars shift_min,wns NA
  godel_init_vars dccap_max,wns NA
  godel_init_vars dccap_min,wns NA

  set vars(module)  $module
  set vars(stage)   $stage
  set vars(version) $version

  # source previous level vars to update current level
  if [file exist ~/.promoted.vars.tcl] { source ~/.promoted.vars.tcl}

  godel_array_save vars .godel/vars.tcl

  if [info exist vars(current_corner)] {
    set var2pass $vars(current_corner)
  } else {
    set var2pass all
  }
  puts $var2pass
  # prepare for next level
  godel_vars2passdown $var2pass

  godel_level_promotion $version
}
# }}}
# godel_update_vars3
# {{{
proc godel_update_vars3 {{mode normal}} {
  upvar module module
  upvar stage stage
  upvar version version
  upvar define define
# Follow this sequence to update vars
  if [file exist .godel/vars.tcl] {
    source .godel/vars.tcl
  }
  set vars(module)  $module
  set vars(stage)   $stage
  if {$mode == "import"} {
# version_list
    if [info exist vars(version_list)] {
      godel_list_uniq_add vars(version_list) $version
    } else {
      set vars(version_list) $version
    }
# latest_version
    if [info exist vars(latest_version)] {
      set vars(latest_version) [lindex [lsort -decreasing $vars(version_list)] 0]
    } else {
      set vars(latest_version) $version
    }
# current_version
    #if ![info exist vars(current_version)] {
      set vars(current_version) $vars(latest_version)
    #}
  }
  # source previous level vars to update current level
  if [file exist ~/.promoted.vars.tcl] { source ~/.promoted.vars.tcl}

  godel_array_save vars .godel/vars.tcl

  godel_vars2passdown $vars(current_version)
  godel_level_promotion $stage
}
# }}}
# godel_update_vars2
# {{{
proc godel_update_vars2 {{mode normal}} {
  upvar module module
  upvar stage  stage
  upvar define define

  if [file exist .godel/vars.tcl] {
    source .godel/vars.tcl
  }
  if {$mode == "import"} {
# stage_list
    if [info exist vars(stage_list)] {
      godel_list_uniq_add vars(stage_list) $stage
    } else {
      set vars(stage_list) $stage
    }
  }
  set vars(module)  $module

  # source previous level vars to update current level
  if [file exist ~/.promoted.vars.tcl] { source ~/.promoted.vars.tcl}

  if [info exist vars(current_stage)] {
    set curstage              $vars(current_stage)
  } else {
    set vars(current_stage)   $define(current_stage)
    set curstage              $vars(current_stage)
  }
  godel_array_save vars .godel/vars.tcl
  #godel_web_index2

  godel_vars2passdown  $curstage
  godel_level_promotion $module
}
# }}}
# godel_update_vars1
# {{{
proc godel_update_vars1 {{mode normal}} {
  upvar module module

  if [file exist .godel/vars.tcl] {
    source .godel/vars.tcl
  }
  if {$mode == "import"} {
# module_list
    if [info exist vars(module_list)] {
      godel_list_uniq_add vars(module_list) $module
    } else {
      set vars(module_list) $module
    }
  }
  # source previous level vars to update current level
  if [file exist ~/.promoted.vars.tcl] { source ~/.promoted.vars.tcl}
  godel_array_save vars .godel/vars.tcl
  file delete -force ~/.promoted.vars.tcl
}
# }}}
#@>godel_level_promotion
# {{{
proc godel_level_promotion {next_level} {
  upvar vars vars
  # prepare for next level
  godel_array_add_prefix vars $next_level
  godel_array_save       vars ~/.promoted.vars.tcl
  godel_array_reset      vars
}
# }}}
#@>godel_create_dir4
# {{{
proc godel_create_dir4 {{type NA}} {
  upvar env env
  upvar module module
  upvar stage stage
  upvar version version
  upvar define define
  upvar flow_name flow_name
  upvar corner corner
  upvar pp pp

  #cd $pp
  #set fpath [pwd]

  #puts "\033\[0;36mCopy files...(godel_create_dir4)\033\[0m"
  set pwdpath [pwd]

  set fout [open "~/.tmp.gmi" w]
  foreach i $define($flow_name,filelist) {
    set f [lindex $i 0]
    
    if [info exist define($f,$stage)] {
      puts [format "    %-40s %s" $define($f,$stage) $f]
      set orgfile $define($f,$stage)
      if [file exist $orgfile] {
        set fname [file tail $orgfile]
        puts $fout "cp $pwdpath/$orgfile ."
        if [regexp "\.gz$" $fname] {
          puts $fout "gunzip $fname"
          regsub {.gz} $fname {} fname
        }
        puts $fout "mv $fname $f"
      }
    } elseif [info exist define($f,$stage,$module)] {
      puts [format "    %-40s %s" $define($f,$stage,$module) $f]
      set orgfile $define($f,$stage,$module)
      if [file exist $orgfile] {
        set fname [file tail $orgfile]
        puts $fout "cp $pwdpath/$orgfile ."
        #puts $fout "ln -s $pwdpath/$orgfile ."
        if [regexp "\.gz$" $fname] {
          puts $fout "gunzip $fname"
          regsub {.gz} $fname {} fname
        }
        puts $fout "mv $fname $f"
      }
    } else {
      if [file exist $f] {
        puts $fout "cp $pwdpath/$f ."
        #puts $fout "rm -f $f; ln -s $pwdpath/$f ."
      }
    }
  }
  close $fout

  set vars(srcpath) [pwd]

# Create directory/note.txt in godel_center
    file mkdir             "$env(GODEL_CENTER)/$module/$stage/$version/$corner/.godel"
    #cd $env(GODEL_CENTER)
    #exec tcsh -fc "touch    $env(GODEL_CENTER)/$module/$stage/$version/$corner/note.txt"
    #exec tcsh -fc "touch    $env(GODEL_CENTER)/$module/$stage/$version/note.txt"
    #exec tcsh -fc "touch    $env(GODEL_CENTER)/$module/$stage/$version/.vars.tcl"
    #exec tcsh -fc "touch    $env(GODEL_CENTER)/$module/$stage/note.txt"
    #exec tcsh -fc "touch    $env(GODEL_CENTER)/$module/$stage/.vars.tcl"
    #exec tcsh -fc "touch    $env(GODEL_CENTER)/$module/note.txt"
# copy
    exec tcsh -fc "cd       $env(GODEL_CENTER)/$module/$stage/$version/$corner; source ~/.tmp.gmi"
}
# }}}
# godel_vars2passdown
# {{{
proc godel_vars2passdown {target} {
# If you do godel_vars2passdown v1.1,
# v1.1 vars type defined in define(vars2passdown) will be passdown to next level.
# for example: v1.1,P, v1.1,V, v1.1,nvp
  upvar vars vars
  upvar define define
  foreach i $define(vars2passdown) {
# godel_pass_down_vars nvp  v1.1,nvp
    godel_pass_down_vars $i       $target,$i
  }
}
# }}}
#@>godel_pass_down_vars
# {{{
proc godel_pass_down_vars {to from} {
# godel_pass_down_vars nvp  v1.1,nvp
# vars(nvp) will be created with value equal to vars(v1.1,nvp)
  upvar vars vars

  if [info exist vars($from)] {
    set vars($to) $vars($from)
  } else {
    set vars($to) "NA"
  }
}
# }}}
#@>godel_complete_vars
# {{{
proc godel_complete_vars {} {
  upvar env     env
  upvar module  module
  upvar version version
  upvar corner  corner
  upvar stage   stage
  upvar flow_name flow_name
  upvar define define

  #puts "\033\[0;36mvars.tcl updating...(godel_complete_vars)\033\[0m"
#============
# 5. Detail
#============
  #puts "    5.. Detail       (godel_update_vars5)"
  cd $env(GODEL_CENTER)/$module/$stage/$version/$corner
  godel_update_vars5
#============
# 4. Corner    (001, 002, ..)
#============
  #puts "    4.. Corner       (godel_update_vars4)"
  cd ..
  godel_update_vars4
#============
# 3. Version   (v1.1, v2.3)
#============
  #puts "    3.. Version      (godel_update_vars3)"
  cd ..
  godel_update_vars3 import
#============
# 2. Stage     (sta, dc, icc2...)
#============
  #puts "    2.. Stage        (godel_update_vars2)"
  cd ..
  godel_update_vars2 import
#============
# 1. Module    (arm9, usb)
#============
  #puts "    1.. Module       (godel_update_vars1)"
  cd ..
  godel_update_vars1 import
  exec tcsh -fc "rm -rf ~/.promoted.vars.tcl"
}
# }}}
#@>godel_htmldraw
# {{{
proc godel_htmdraw {} {
  upvar env     env
  upvar module  module
  upvar version version
  upvar corner  corner
  upvar define  define
  upvar signoff signoff
  upvar stage   stage

  #puts "\033\[0;36mHTML drawing...(godel_htmldraw)\033\[0m"

  cd $env(GODEL_CENTER)/$module/$stage/$version
  #puts "    4.. Corner       (godel_asic_index4)"
#  cd ..
  godel_asic_index4

  #puts "    3.. Version      (godel_asic_index3)"
  cd ..
  godel_asic_index3

  #puts "    2.. Stage        (godel_asic_index2)"
  cd ..
  godel_asic_index2

  #puts "    1.. Module       (godel_asic_index1)"
  cd ..
  godel_asic_index1
}
# }}}
# vim:fdm=marker
