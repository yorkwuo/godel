#!/usr/bin/tclsh
source $env(GODEL_ROOT)/bin/eda_shell
source $env(GODEL_ROOT)/bin/godel.tcl

source [lindex $argv 0]

#godel_array_save upfvars upfvars.tcl
upf_rp_power_domains
upf_rp_supply_ports
upf_rp_supply_nets
upf_rp_net_connects
upf_rp_port_state
upf_rp_pst_states
upf_rp_isolation
upf_rp_related_supply
