# (C) 2001-2023 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


#########################################################################################
# This file contains timing script utilities that are specific to SF methodology (e.g. SM)
#########################################################################################
 
set script_dir [file dirname [info script]]
 
load_package sdc_ext
load_package design

# ----------------------------------------------------------------
#
proc xcvrphy_is_node_type_refreg { node_id node_search ip_inst_name} {
#
# Description: Given a node, checks if a string is present or not
#              Removed check for ip_inst_name as it might be diff
#					in case of Sys PLL clock
# ----------------------------------------------------------------
 if {[regexp $node_search [get_node_info -name $node_id]] == 1} { 
      set result 1
   } else {
      set result 0
   }
   return $result
}

# ----------------------------------------------------------------
#
proc xcvrphy_is_node_type_pin { node_id node_search ip_inst_name } {
#
# Description: Given a node, tells whether or not it is a certain type or not (e.g. pin, port)
#              Also check for ip_inst_name to find the right node
#
# ----------------------------------------------------------------
   set node_type [get_node_info -type $node_id]

   if {$node_type == $node_search && [regexp [get_node_info -name $node_id] "$ip_inst_name"] == 1} {
      set result 1
   } else {
      set result 0
   }
   return $result		
}

#
# ----------------------------------------------------------------
#
proc xcvrphy_traverse_fanin_up_to_depth { node_id match_command edge_type results_array_name depth node_search ip_inst_name} {
#
# Description: Recurses through the timing netlist starting from the given
#              node_id through edges of type edge_type to find nodes
#              satisfying match_command.
#              Recursion depth is bound to the specified depth.
#              Adds the resulting TDB node ids to the results_array.
#
# ----------------------------------------------------------------
   upvar 1 $results_array_name results
 
   if {$depth < 0} {
      error "Internal error: Bad timing netlist search depth"
   }
   set fanin_edges [get_node_info -${edge_type}_edges $node_id]
   set number_of_fanin_edges [llength $fanin_edges]
	#post_message -type info "number_of_fanin_edges $number_of_fanin_edges"
	for {set i 0} {$i != $number_of_fanin_edges} {incr i} {
      set fanin_edge [lindex $fanin_edges $i]
      set fanin_id [get_edge_info -src $fanin_edge]
		#post_message -type info "fanin_id [get_node_info -name $fanin_id]"
		if {$match_command == "" || [eval $match_command $fanin_id $node_search $ip_inst_name] != 0} {
			#post_message -type info "fanin_id [get_node_info -name $fanin_id]"
			#post_message -type info "match"
			set results($fanin_id) [expr {$i+1}]
      } elseif {$depth == 0} {
			puts "no more here"
         # Max recursion depth
      } else {
			#post_message -type info "disabled edge info : [get_edge_info -is_disabled $fanin_edge]"
			if {[get_edge_info -is_disabled $fanin_edge]==0} {
				xcvrphy_traverse_fanin_up_to_depth $fanin_id $match_command $edge_type results [expr {$depth - 1}] $node_search $ip_inst_name
			} else { 
			# no further traversal if edge is disabled
			}
      }
   }
}


#
# ----------------------------------------------------------------
#
proc xcvrphy_get_input_clk_id { xcvr_inclk_id var_array_name ip_inst_name} {
#
# Description: calls the recursive traversing function to search for clock_edges 
#
# ----------------------------------------------------------------
 
   upvar 1 $var_array_name var
 
   array set results_array [list]
 
   # Find the input pin
   # Depth set to 10 to adaquately handle ref clock tree traversal
   xcvrphy_traverse_fanin_up_to_depth $xcvr_inclk_id $var(node_check_command) clock results_array $var(xcvr_inclock_search_depth) $var(node_search) $ip_inst_name
   if {[array size results_array] == 1} {
      # Fed by a dedicated input pin
		set pin_id [lindex [array names results_array] 0]
		set result $pin_id
   } else {
      post_message -type critical_warning "Could not find XCVR clock for [get_node_info -name $xcvr_inclk_id]"
      set result -1
   }
 
   return $result
}


# ----------------------------------------------------------------
#
proc xcvrphy_traverse_fanins { ip_inst_name dummy_sip_flop_name clk_type ip_inst_name ip_sdc_debug} {
#
# Description: Retruns source clk_ref/reg node for XCVR user clock which drives dummy flop placed in SIP
#
# ----------------------------------------------------------------

	set var(xcvr_inclock_search_depth) 3
	set var(node_check_command) xcvrphy_is_node_type_pin
	
	set dummy_sip_flop_node [get_nodes $ip_inst_name|*|${dummy_sip_flop_name}*|clk]
	
	set var(node_search) "pin"
	set dummy_flop_clock_pin [xcvrphy_get_input_clk_id $dummy_sip_flop_node var  $ip_inst_name]
	
	set dummy_flop_clock_pin_node [get_node_info -name $dummy_flop_clock_pin ]
	
	if {$ip_sdc_debug == 1} {
		if {$clk_type == "pin"} {
			post_message -type info "IP SDC: Clock Pin source found for $dummy_sip_flop_name: $dummy_flop_clock_pin_node"
		}
	}
   
   if {$clk_type != "pin"} {
		set var(node_check_command) xcvrphy_is_node_type_refreg
		set var(node_search) $clk_type
				
		set xcvrclk_src [xcvrphy_get_input_clk_id $dummy_flop_clock_pin_node var  $ip_inst_name]
		set xcvrclk_src_node [get_node_info -name $xcvrclk_src]
		
		if {$ip_sdc_debug == 1} {
			if {[regexp "reg" $clk_type] == 1} {
				post_message -type info "IP SDC: Clock Reg source found for $dummy_sip_flop_name: $xcvrclk_src_node"
			} else {
				post_message -type info "IP SDC: Clock Ref source found for $dummy_sip_flop_name: $xcvrclk_src_node"
			}
		}
	}

	if {$clk_type == "pin"} {
		return $dummy_flop_clock_pin_node 
	} else {
      return $xcvrclk_src_node 
	}
}


# ----------------------------------------------------------------
#
proc lookup_clock_target { lookup_string } {
#
# Description: Retruns whether lookup_string is present in target of any of already created clocks in the design
#
# ----------------------------------------------------------------
    set clocks_collection [get_clocks -nowarn]
	 if {[get_collection_size $clocks_collection] > 0} {
		foreach_in_collection clock $clocks_collection {
			if { ![is_clock_defined $clock] } {
					continue
				}
			set clock_name [get_clock_info -name $clock]
		
	    set clock_target_name_collection [get_clock_info -target $clock]
      if {[get_collection_size $clock_target_name_collection] > 0} { 
          foreach_in_collection clock_target $clock_target_name_collection {
          set clock_target_name [get_node_info -name $clock_target]
			      if {[string equal $lookup_string $clock_target_name] == 1} {
				      return 1
#				break
      		  } 
      		}
		    }
    }
    return 0
	} else {
		return 0
	}
}


# ----------------------------------------------------------------
#
proc lookup_clock_target_name { lookup_string } {
#
# Description: Retruns already created clock name whose target has lookup_string
#
# ----------------------------------------------------------------

    set clocks_collection [get_clocks]
	 if {[get_collection_size $clocks_collection] > 0} {	 
		foreach_in_collection clock $clocks_collection {
			if { ![is_clock_defined $clock] } {
					continue
				}
			set clock_name [get_clock_info -name $clock]
	    set clock_target_name_collection [get_clock_info -target $clock]
      if {[get_collection_size $clock_target_name_collection] > 0} { 
          foreach_in_collection clock_target $clock_target_name_collection {
          set clock_target_name [get_node_info -name $clock_target]
			      if {[string equal $lookup_string $clock_target_name] == 1} {
				      return $clock_name
#				break
      		  } 
      		}
		    }
    }
 	} else {
		return 0
	}
}
