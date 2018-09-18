set define(default,init) $env(GODEL_ROOT)/etc/init/default_init.tcl
# vars2passdown
# {{{
  set     define(vars2passdown) [list]
  lappend define(vars2passdown) PE
  lappend define(vars2passdown) speed      
  lappend define(vars2passdown) area_normalize      
  lappend define(vars2passdown) num_seq_cell      
  lappend define(vars2passdown) eda_ver      
  lappend define(vars2passdown) current_speed
  lappend define(vars2passdown) opt_speed    
  lappend define(vars2passdown) wns          
  lappend define(vars2passdown) nvp          
  lappend define(vars2passdown) pdk          
  lappend define(vars2passdown) drc          
  lappend define(vars2passdown) date         
  lappend define(vars2passdown) clock_period 
  lappend define(vars2passdown) uncertainty  
  lappend define(vars2passdown) P
  lappend define(vars2passdown) T            
  lappend define(vars2passdown) V            
  lappend define(vars2passdown) density      
  lappend define(vars2passdown) leakage      
  lappend define(vars2passdown) area         
  lappend define(vars2passdown) runtime      
  lappend define(vars2passdown) inst         
  lappend define(vars2passdown) mbff         
  lappend define(vars2passdown) icg          
  lappend define(vars2passdown) errors       
  lappend define(vars2passdown) derate       
  lappend define(vars2passdown) power_internal
  lappend define(vars2passdown) power_switching
  lappend define(vars2passdown) power_leakage
  lappend define(vars2passdown) power_total
# ptpx
  lappend define(vars2passdown) power_net_switching
  lappend define(vars2passdown) power_clock_network
  lappend define(vars2passdown) power_register
  lappend define(vars2passdown) power_combo
  lappend define(vars2passdown) power_seq
  #lappend define(vars2passdown) 
  #lappend define(vars2passdown) 
# }}}
lappend define(qor.rpt,genus) dft/rpts/rc.report_qor.gz

set define(current_stage) dc

# vim:fdm=marker
